# Tasks

> 每步：`bin\lua-language-server.exe --test` 全量绿 + 目标工程
> `--test project.external-diagnostic --test-project=d:\github\vscode-lua\server --mem-limit=2 --baseline=tmp\scan-154.txt`
> 保持 154（本轮是地基重构，先要求零行为变化）+ 本仓库面板 0。
> 顺序按 design D5：**先只加不删**，每步可独立回退。

## 1. 引入求值上下文与失效推迟（零行为变化）

- [x] 1.1 `script/node/node.lua`：`Node.ResolveContext` **扩展**（不新增类型名，避免改 18 处引用）——
  增加 `inProgress? table<Node, Node>`（正在求值的节点 → 占位值），`resolveContext` 工厂补该字段
- [x] 1.2 `script/node/runtime.lua`：加 ambient 栈 `enterEval/exitEval/evalContext/withEval`；
  **按协程隔离**（`setmetatable({}, ls.util.MODE_K)` 以 `coroutine.running()` 为键，LS 的 task 会交错）；
  最外层 `enterEval` 同时 `lockCache()`、`exitEval` 同时 `unlockCache()`（静默点批量 flush）
- [x] 1.3 求值入口接上 `withEval`：`script/feature/diagnostic/file.lua` 的按文件诊断 task body；
  注意 `withEval` 与传入的闭包都要标 `---@async`（否则 `await-in-sync`/`missing-return*`，已修）
- [x] 1.4 验证：全量 `--test` 绿；目标工程 **154（removed 2 / added 0，与改前一致）**；本仓库面板 0；
  A/B 计时 基线 **10.26s** → 本步 **9.88s**（无回归，之前 11.5/12.4s 是机器噪声）

## 2. 把各家自有状态接进 ctx（行为等价；按事实分两类）

- [x] 2a **不做**（2026-09-30 决定）：`union` / `table` / `variable` 的 `visited` 是**每次遍历**的环保护
  （`ls.util.visited` 9 处 / 手写 `visited = visited or {}` 13 处 / 每次新建 8 处），接 ambient 会让同一次求值里
  第二个独立遍历吞掉合法的重复访问 ✗；`union:each/every` 的 `visited` 还是公开 API 参数。
  ⇒ **per-traversal 去重由各自内部维护**，ctx 只管 per-eval 部分（理由已写进 design D5-2a）
- [x] 2b **结构键（`intersection`）**：新增 `Node.Intersection.EvalState`（`building` / `buildingHasGeneric` /
  `taskDepths` / `depth`）挂到 `ctx.intersection`（无 ctx 时退回模块级）；`enterDepth/leaveDepth` 改为接收 state。
  验证：全量 `--test` 绿；目标工程 **154（removed 2 / added 0）**；`[Intersection] values cycle detected`
  日志数与基线**相同（2）**；本仓库面板 0
- [x] 2c 记录「**不要**把结构键改成身份键」（身份随节点重建失效 ⇒ 147k 爆栈诱因之一）——已写进 design D5-2b/2a
- [x] 2d 顺带记一条实测教训：**跨文件改动不会让已缓存的文件重算**（`calculated && version`）——
  本仓库面板里 `intersection.lua` 的告警是旧缓存，touch 该文件后才刷新；排查面板时要留意

## 3. `PROVISIONAL` 迁到 `ctx.inProgress`（只缓存完成态）

- [x] 3.1 `Node.Variable.__getter.value`（`variable.lua:1034`，**唯一**把占位写进缓存字段的地方）：
  入口查 `ctx.inProgress[self]` → 命中即 `return placeholder, false`（占位不缓存）；计算前
  `ctx.inProgress[self] = rt.PROVISIONAL`、算完清空；**没有 ctx 时退回旧写法**（占位写缓存字段）保持行为一致。
  该 getter 的 `needCache` 标注由 `---@return true` 放宽为 `boolean`（占位路径返回 `false`）
- [x] 3.2 `PROVISIONAL` 作为**类型/识别标记**保留：`runtime.lua` 的定义与 `anykv`/`truthy`/`falsy` preset、
  `tracer.lua:387/441` 的「不采纳未完成值」、`union.lua:155/163` 的跳过占位成员 —— 均不动
- [x] 3.3 验证：全量 `--test` 绿；目标工程 **154（removed 2 / added 0）**；面板 0。
  **F2 / F27 族未顺带消失**（符合预期：那两条的 stale 值是 `Select.value`/`FCall.returns`，
  不是 `Variable.value`）⇒ 数字记在 `returns.md` F2 与 `项目实践.md`。
  附带收益：占位不再写进缓存字段 ⇒ 求值中途异常也不会把「半成品」永久留在变量缓存里

## 4. 防回归断言

- [x] 4.1 `script/node/runtime.lua` 的 `flushCacheNow`：`test` 模式下若 `cacheLocked > 0` 直接
  `error('[eval-context] flushCacheNow bypassed while cache locked')`（求值期不得旁路失效）。
  验证：全量 `--test` **零命中**（说明现有测试路径没有旁路）；目标工程扫描（同为 test 模式）也**零命中** ✓
  ⇒ 不变量在当前代码里成立，断言留给以后防回归
- [x] 4.2 新增 `test/node/eval-context.lua`（并在 `test/node/init.lua` 里 require）：
  ①嵌套求值共享可见（最内层可见、出栈回外层）；②`withEval` 里抛异常后 ctx 栈仍清空；
  ③求值期内 `flushCache` 被推迟（期间值还在，出栈后失效生效）。
  验证：`bin\lua-language-server.exe --test node` 绿 + 全量 `--test` 绿

## 5. 收尾

- [ ] 5.1 事实台账：把「环保护统一（ctx.visited / ctx.inProgress）+ 求值期不失效 + 只缓存完成态」
  写进 `.github/skills/luals-server-dev/references/facts/`（新文件 `eval-context.md` 或并入 `narrowing.md`），
  并与 `returns.md` F2 / `classes.md` F25 交叉引用；`--test tools.facts` 绿
- [ ] 5.2 `项目实践.md` 记本轮（含：147k 爆栈的教训、"不做全量签名改造"的理由）
- [ ] 5.3 归档 `openspec archive eval-context-unify`；若 3.3 顺带修掉 F2 族，单开一轮把
  `returns.md` F2 的依赖边/`addReturnList` 时机收尾
