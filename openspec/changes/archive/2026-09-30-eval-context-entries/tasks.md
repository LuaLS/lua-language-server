# Tasks

## 1. 接入口

- [x] 1.1 `go-to-definition.lua`：把 `ls.feature.definition(...)` 包进 `scope.rt:withEval(...)`（`---@async` 贴调用、闭包不换行），结果经闭包外 `local results` 带出；验证：全量 `--test` 绿、该文件面板无 warning
- [x] 1.2 `go-to-references.lua`：同上包住 `ls.feature.references(...)`；验证：同上
- [x] 1.3 `go-to-implementation.lua`：同上包住 `ls.feature.implementation(...)`；验证：同上
- [x] 1.4 让出安全性核对：入口内的 `ls.scope.waitReady` 会经 `ls.await.yield` 让出，而 `resume` 用 `presume(co)` 回到**同一协程**（`script/tools/await.lua:58`）⇒ `exitEval` 能拿到同一把栈、锁不会泄漏；验证：代码核对 + 全量 `--test` 绿
- [x] 1.5 本仓库问题面板：`vscodeOperator_readProblems`（`workspacePath` = 本仓库，`pathGlob='d:/github/vscode-lua-4/server/**'`，`minSeverity=information`）为 0（error / warning / information；hint 不管）

## 2. 回归

- [x] 2.1 全量回归绿：`bin\lua-language-server.exe --test`（exit 0，含 `test/node/eval-context.lua` 三条断言；`[Intersection] values cycle detected: 2` 为既定基线）
- [x] 2.2 目标工程基线比对：`--baseline=tmp\scan-154.txt` → **154 → 154（移除 0 / 新增 0）**
- [x] 2.3 本仓库问题面板清零（同 1.5）；hint 不处理

## 3. 记账

- [x] 3.1 台账 `facts/eval-context.md` E1 的「落地范围」改为已包集合（六处），并记「包装位置在 capability 调用点、不在 feature 内部」的理由；验证：`bin\lua-language-server.exe --test tools.facts`
- [x] 3.2 `项目实践.md` 追加本轮纪要（含基线数字与结论）
- [x] 3.3 `openspec archive eval-context-entries`（勾选 tasks 后归档）
