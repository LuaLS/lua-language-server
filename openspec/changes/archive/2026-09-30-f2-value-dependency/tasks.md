# Tasks

> 本轮是**受控测量**：目的就是验证「eval-context 落地后 F2 的依赖边方案能否收敛」。结论：**不能**（仍爆栈）。

- [x] 1.1 重放 #24 的两处改动（`fcall.lua` 的 `f:addRef(self)`、`function.lua` 的
  `addReturnList → flushCache()`），跑目标工程
  `--test project.external-diagnostic --test-project=d:\github\vscode-lua\server --mem-limit=2 --baseline=tmp\scan-156.txt`
- [x] 1.2 读栈：**仍 147014 层**，`script\class.lua:593 → intersection.lua:154 buildValues
  → intersection.lua:254/270 → intersection.lua:382 onCanCast → node.canCast`，起点 `undefined-field provider`
- [x] 1.3 归因修正并记台账（`facts/returns.md` F2）：这是**深度爆炸**（每层新建交集、签名各不相同 ⇒
  结构键环保护不触发），不是签名环；且 `values` getter 里的 `DEPTH_LIMIT = 64` 没拦住这条路径
- [x] 1.4 实验回退（`git checkout -- script/node/fcall.lua script/node/function.lua`）；
  目标工程仍 **154**（0/0）、基线未受影响
- [ ] 2.1 **后续（二选一，另开轮）**：
  ① 查 `DEPTH_LIMIT` 为什么没拦住 `buildValues` 的递归（计数是否覆盖这条链、`taskDepths` 的 task 键是否稳定）；
  ② 目标侧 C 方案（给无注解递归函数补 `---@return`，盯住新的返回值不匹配诊断）
- [ ] 2.2 收尾：归档本 change 并更新 `项目实践.md`（把这次「结构键也拦不住 + 深度护栏没生效」记上）
