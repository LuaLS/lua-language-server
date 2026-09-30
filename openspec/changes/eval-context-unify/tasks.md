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

- [ ] 3.1 需要环保护的 getter（`variable` / `union` / `intersection` / `table` / `select` / `fcall` …）：
  进入时查 `ctx.inProgress[self]`，命中即返回占位且 `needCache = false`
- [ ] 3.2 去掉「把 `rt.PROVISIONAL` 写进 getter 缓存字段」的写法（保留常量语义供 `==` 识别）
- [ ] 3.3 验证：全量 `--test` 绿 + 目标工程 `--baseline` **期望 154 → ≤154**（若 F2 族顺带消失要记数字）
  + 面板复验（请用户重启 LS 后看 `compile.lua:3043/3044`）

## 4. 防回归断言

- [ ] 4.1 加 debug 断言：求值期内不得直接 `flushCacheNow`（`rt.cacheLocked > 0` 时不得旁路）；
  仅在 `--test`/debug 下生效，生产路径不付出代价
- [ ] 4.2 给 `ctx` 栈配一个最小回归测试（`test/node/`）：嵌套求值共享同一 ctx、异常退出后栈为空、
  失效被推迟到求值结束

## 5. 收尾

- [ ] 5.1 事实台账：把「环保护统一（ctx.visited / ctx.inProgress）+ 求值期不失效 + 只缓存完成态」
  写进 `.github/skills/luals-server-dev/references/facts/`（新文件 `eval-context.md` 或并入 `narrowing.md`），
  并与 `returns.md` F2 / `classes.md` F25 交叉引用；`--test tools.facts` 绿
- [ ] 5.2 `项目实践.md` 记本轮（含：147k 爆栈的教训、"不做全量签名改造"的理由）
- [ ] 5.3 归档 `openspec archive eval-context-unify`；若 3.3 顺带修掉 F2 族，单开一轮把
  `returns.md` F2 的依赖边/`addReturnList` 时机收尾
