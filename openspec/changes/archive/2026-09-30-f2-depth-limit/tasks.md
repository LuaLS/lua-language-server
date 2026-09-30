# Tasks

## 1. 复现与插桩取证

- [x] 1.1 重放 change #24 依赖边补丁（`FCall.matchedFuncs` 加 `f:addRef(self)`；`Function:addReturnList` 加 `flushCache()`）⇒ 复现 147k 层爆栈（`class.lua:593 stack overflow`，栈含 `intersection.onCanCast → getValues → buildValues → rt.intersection`）
- [x] 1.2 `intersection.lua` 临时插桩：`evalState` 记 state/rt 数、`enterDepth` 记 task 数与该 state 内最大 `d`、两个 getter 记嵌套层数、`onCanCast` 记调用数、`__init` 记构造嵌套、bail 计数（落盘 stdout，事后 `git checkout` 撤销）
- [x] 1.3 读数判定机制：`maxNesting=9` / `maxInitNesting=1` / `maxD=19` / `bailDepth=0` / `states=0` / `tasks=0` / `rts=1` ⇒ **M3（护栏装错了层）**；失控链 = `Node:canCast ↔ onCanCast/onCanBeCast`（traceback `skipping 8833 / 9989 / 11982 levels`）

## 2. 落地 `canCast` 深度上限

- [x] 2.1 `script/node/node.lua`：加 `CAST_DEPTH_LIMIT = 64`，`M:canCast` 改深度包装 + 模块级 `castImpl`；超限按 unknown 返回 `true`
- [x] 2.2 `script/node/runtime.lua`：加 `Runtime.castDepth` 字段，`flushCacheNow` / `reset` 一并清掉
- [x] 2.3 验证「仅护栏」批量零行为变化：`--baseline=tmp\scan-154.txt` ⇒ **154 → 154（移除 0 / 新增 0）**
- [x] 2.4 验证「护栏 + F2 依赖边补丁（仅实验，不落地）」⇒ **154 → 149（移除 5 / 新增 0）且不再爆栈**；实验后 `git checkout` 撤回补丁

## 3. 收尾

- [x] 3.1 撤掉 `intersection.lua` 的全部插桩（`git checkout`），确认 `git diff` 只含 node.lua / runtime.lua
- [x] 3.2 全量 `bin\lua-language-server.exe --test` 绿；`vscodeOperator_readProblems`（本仓库，error/warning/information）为 0（`---@field castDepth? integer` 修 inject-field、`local castImpl` 修 lowercase-global）
- [x] 3.3 台账：`facts/casts.md` 新增 F3（机制 + 实测数字 + 试过未采用）；`facts/returns.md` F2 记「护栏失效已解除、依赖边方案可采用」；跑 `--test tools.facts`
- [x] 3.4 `项目实践.md` 追加本轮纪要；`openspec archive f2-depth-limit`
- [x] 3.5 删除 `tmp/f2depth-run*.txt`（实验日志），保留 `tmp/scan-154.txt`
