# Task / Await / Progress 并发系统

记录 server 内协作式并发模型的职责划分与关键语义。改 LSP 请求处理、长耗时任务、进度条、取消逻辑前先读。

## 分层

| 层 | 文件 | 全局 | 职责 |
|---|---|---|---|
| Await | `script/tools/await.lua` | `ls.await` | 协程原语：sleep / yield / call |
| Task | `script/language-server/task.lua` | `ls.task` | 请求级任务封装与取消 |
| Progress | `script/language-server/progress.lua` | `ls.progress` | VSCode 进度条（master `script/progress.lua` 的移植） |

## 请求处理模型

- 每个 LSP 请求 = 一个 Task：`language-server.lua` 的 `resolveTask` → `task:execute` → `ls.await.call` 新协程。
- 请求协程挂起后，transport listen 循环继续收下一条消息。**长循环里没有让出点 = 后续请求全部排队**。
- 全局 `ls.server` 在 `main.lua` 赋值；server → client 通知经 `ls.server.client`（判空，测试 mock 环境无完整字段）。

## Await 语义

- `sleep(time)`：`time > 0` 走 `ls.timer.wait`，`time <= 0` 走 `ls.eventLoop.addDelayQueue`。
- `sleep(0)` = 让出一个调度 tick。不可让出上下文（同步代码）调用时经 errorHandler 记日志并直接返回——**业务层不要自行包 `coroutine.isyieldable()` 守卫**，`Task:delay` 已在 task 层内承担。
- `yield(callback)`：callback 同步执行；resume 同步到达时走 fast-path 不真正挂起。
- 所有恢复侧（sleep waker、yield resume）带 `coroutine.status(co) ~= 'suspended'` 守卫——协程死后迟到事件静默跳过，不会出现 dead-resume 报错。

## Task 语义与取消

- `getCurrentTask()`：`execute` 时把当前协程注册进 taskMap，业务层由此拿 task；拿不到（测试等同步上下文）用可选链短路：`ls.task.getCurrentTask()?:delay()`。
- `Task:delay()`：即 `sleep(0)`，长循环让出点。跨 vfile 扫描按文件粒度让出，**先快照列表再迭代**——让出期间其他任务可能往 map 插键，直接 `pairs` 迭代中让出有 `invalid key to 'next'` 风险。单文件内的 pairs 迭代不要中途让出。
- `newThrottledDelayer(n)`：**不是时间节流**，是调用计数——每 n 次 `delay()` 才 `sleep(0)` 一次（诊断 provider 防饿死用，factor 常取 500）。
- **取消机制**：`resolve/reject` → `Delete(self)` → `__del` → 对 suspended 协程 `coroutine.close`。即取消 = 协程当场死亡 + 挂起点永不返回 + 协程栈帧上的 `<close>` 变量立即关闭。单线程下 reject 只可能来自其他协程，此刻目标协程必是 suspended。
- 推论：**循环内 `if task.resolved then break end` 是死代码**——协程活着时 task 必未 resolved，task resolved 后协程已死，跑不到下一迭代。取消靠 close，不靠轮询。
- 已知的 close 后副作用：挂起点相关事件（如 `waitReady` 的 onDidLoad）之后触发时被恢复侧守卫拦下，静默无害。

## Progress 语义

- `ls.progress.create(uri, title, delay)`：`delay` 秒后才真正显示（防闪条）；50ms report 节流；`ls.timer.loop(0.1)` 驱动全局刷新。
- LSP 协议：`window/workDoneProgress/create` request + `$/progress` begin/report/end notify。
- 配置门控 `Lua.window.progressBar`（模板默认 true），走 `ls.scope.find(uri)` → `scope.config:get`。
- `__close` 定义在 class 表上（实例 metatable 即 class 表）→ 支持 `local prog <close> = ...`，异常路径也保证发 `end`。
- `onCancel` 注册后 begin 报文 `cancellable = true`；取消链路：VSCode 取消按钮 → `window/workDoneProgress/cancel`（`capability/workspace/work-done-progress-cancel.lua`）→ `ls.progress.cancel(token)` → `task:reject` → 协程 close → `<close>` 自动发 `end`。
- `window/workDoneProgress/cancel` 注册独立成 capability 文件：progress 类保持纯 API，部分测试环境没有 capability 链。

## 已知陷阱

1. **`<close>` 不能放在 `ls.await.yield(callback)` 的 callback 闭包里**：callback 同步 return 时 TBC 立即关闭，进度条永远不会显示。应放在 `task:execute` 协程内，随协程生命周期关闭（正常结束与取消路径都覆盖）。
2. **取消时机与 'end' 通知**：`coroutine.close` 会立即触发 `<close>`，不需要等当前文件处理完。
3. **feature 层引用 `ls.progress` 时**：真实环境由 `language-server/init.lua` 的 require 顺序保证；测试环境按需预载（如 `pull.lua` 头部 `require 'language-server.progress'`，同 `push.lua` 预载 `language-server.task` 的惯例）。
4. **长任务接入 Progress 的模板**：progress 在 `task:execute` 协程内创建 + `onCancel` 里 reject 当前 task，消费者经 `ls.await.yield` 的 resume 提前拿到空结果。

## 测试注意

- 从同步测试上下文调用 async feature：`await-in-sync` 用 disable 注解压制；真正会挂起的 `yield`（如 `fetchAll`）需要 TEST_FRAME 回调这类可让出上下文。
- mock `ls.server` 时（参考 `test/feature/diagnostic/push.lua` 的 `withMockServer`），progress 的 `getClient` 判空逻辑保证不会炸。
