# Proposal

## Why

`facts/returns.md` F2：调用的第 1 个返回值在部分时机解析成 `nil` —— 被调函数的**返回集合**在
调用结果**首次求值**时还没齐（coder 还在补 `addReturnList`），那次残缺结果被缓存，
之后没有任何机制把它作废（函数 → 调用的**依赖边缺失**）。目标工程的面板 `compile.lua:3043/3044`
一族就是这个（早期 `nil` 把 `if child then` 判死 ⇒ 分支内读值退化成 `never`）。

修法（依赖边）本身很简单，但两次实测都在 **147014 层爆栈**。上一轮（`f2-depth-limit`）已查明该爆栈
**不是**这条修法的问题，而是 `Node:canCast` 的递归没有上限（`castCache` 的身份路径键对不上
「每层新建节点」的链，见 `facts/casts.md` F3），并已落地 `CAST_DEPTH_LIMIT = 64`。
前置障碍解除后，本轮把依赖边落地。

## What Changes

- `script/node/fcall.lua`：`FCall.matchedFuncs` 里对匹配到的每个函数登记 `f:addRef(self)`
  —— 函数失效时把调用一起作废。
- `script/node/function.lua`：`Function:addReturnList` 末尾 `self:flushCache()`
  —— 返回集合变化 ⇒ 该函数（连带登记的调用）重算。
- `script/feature/diagnostic/init.lua`：诊断 pass 入口复位 `scope.rt.castDepth`
  —— 异常从判定中途穿出会残留护栏计数（让后续判定一律宽松）；
  **失效点不能清**（见下「试过但未采用」）。

不涉及：`Select.value` / `FCall.returns` 的缓存形态本身；`intersection` 的护栏；coder 的发射时机。

## Capabilities

### New Capabilities

- `return-invalidation`：函数返回集合变化必须让依赖它的取值作废重算（依赖边）。
  依据：`facts/returns.md` F2 —— 首次求值早于 `addReturnList` 完成时，残缺结果会一直留在缓存里。

### Modified Capabilities

无。

## Impact

- 代码：`script/node/fcall.lua`（+1 行）、`script/node/function.lua`（+1 行）。
- 语义依据（本仓库自己的语义）：仓库已有「依赖边 + 失效」机制（`RefModule:addRef` + `flushCache`，
  见 `facts/eval-context.md` E1「求值期不失效、静默点批量生效」）；本变更只是给
  「函数 → 调用」补上原本缺的那条边，不新造机制。
- 诊断基线：目标工程 `D:\github\vscode-lua\server` **154 → 149（移除 5 / 新增 0）**
  （上一轮已在 `CAST_DEPTH_LIMIT = 64` 下实测；本轮在最终形态下复测）。
- 本仓库问题面板：0（error / warning / information；hint 不管）。
- 全量 `--test`：绿。
- 面板侧（目标工程长会话）需用户在编辑器里确认：`compile.lua:3043/3044` 一族应消失；
  若出现新问题，回退本 change（两行改动）。

## 试过但未采用

- **在失效点（`Runtime:flushCacheNow`）清 `castDepth`**：实测**把护栏废掉** —— 依赖边让失效
  在递归中途频繁发生，一清计数就归零，立刻复现 `intersection.lua:151` 栈溢出
  （去掉该行即恢复 154 → 149 / 0 新增）。泄漏改用 **pass 边界**复位兜（`casts.md` F3「坑」）。
- **同轮一起把 `canCast` 护栏 + 依赖边落地**（上一轮的选择）：已拆开 —— 护栏零行为变化可独立验证，
  依赖边的收益主要在面板侧，单独落地便于单独回退。
- **只加 `addReturnList → flushCache()`、不登记 `f:addRef(call)`**（change #26 的重放形态之一）：
  失效传播不到调用/取值，实测无效果（`facts/returns.md` F2「试过」第 2 条：0/0）。
- **把重算推到静默期/打标记延迟失效**（F2 记录的 B 方案变体）：在依赖边可用后属于过度设计，
  暂不引入。
