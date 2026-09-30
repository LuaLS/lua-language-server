# Design

## Context

动机见 `proposal.md`；事实见 `facts/returns.md` F2、`facts/casts.md` F3、`facts/eval-context.md` E1–E3。

现有护栏（`script/node/intersection.lua`）：`evalState` 取 `ctx.intersection`（无 ctx 退回模块级
`fallbackState`）；`enterDepth` 按 `ls.task.getCurrentTask()` 计数，无 task 时用 `state.depth`；
`values` / `hasGeneric` getter 在 `d > DEPTH_LIMIT(64)` 时 `logOverflow` + bail。

## Goals / Non-Goals

**Goals**：给出「护栏失效」的机制归属并落地对应修复（让深递归有界），保留可复现步骤与数字。

**Non-Goals**：本轮不改目标工程代码（C 方案另轮）；不改 coder/parser；不动 `intersection` 的护栏数值；
不落 F2 的依赖边补丁（见 proposal「不落地」）。

## Decisions

### D1 三个候选机制：实测落在 M3

- **M1 状态分片**（跨 runtime / 跨 ctx 各一份 `EvalState`）：实测 `states=0`、`rts=1`
  ⇒ 全程单 state、单 runtime，**排除**。
- **M2 任务键分片**（`taskDepths` 的 task 每层不同）：实测 `tasks=0`
  ⇒ `getCurrentTask()` 全程为 nil，走的是 `state.depth` 单一计数，**排除**。
- **M3 路径绕过护栏**（加深的链根本不走 `values`/`hasGeneric` getter）：**成立** ——
  实测 `maxNesting=9`（getter 同时最多 9 层）、`maxInitNesting=1`（构造从不嵌套）、
  `maxD=19`、`bailDepth=0`（护栏从未触发），而栈已 147k 层。
  失控链是 `Node:canCast` ↔ `onCanCast`/`onCanBeCast`（`logOverflow` 的 traceback：
  `node.lua:261 ↔ union.lua:55 ↔ node.lua:261 ↔ table.lua:405 ↔ node.lua:267`，
  `skipping 8833 / 9989 / 11982 levels`）。

### D2 落地 `canCast` 深度上限（而不是改 intersection 的数值）

`castCache` 的键是**身份路径** `{self, other}`，而失控链每层新建节点（`buildValues` → `rt.intersection`），
身份键无从剪枝 ⇒ 只能加**层数**上限。超限复用既有语义（`castCache` 命中 `'unknown'` ⇒ `return true`）。
上限值取 64，与 `intersection` 的 `DEPTH_LIMIT` 同量级。
备选（未采用）：结构签名键剪枝（改变正常路径裁剪时机、与身份键并存成两套判定）。

### D3 记录「F2 依赖边方案已可采用」，但不在本轮流地

实测：**仅护栏** 154 → 154（0/0）；**护栏 + 重放 F2 依赖边补丁** 154 → 149（移除 5 / 新增 0）
且不再爆栈。即 `returns.md` F2 记的「护栏失效」前置条件已解除，依赖边方案从「不可采用」变为「可采用」。
不在本轮落地的理由：其主要收益在**面板**侧（长会话缓存时机），需要在带面板的环境单独验一轮；
按「一轮一改」拆开，便于单独回退。

## Risks / Trade-offs

- [深递归时判为「可转换」，可能少报类型不匹配] → 与既有 `castCache` 的 `'unknown'` 同义（宽松放行）；
  实测批量零变化（154 → 154，0/0）。
- [计数在异常穿出时残留，导致该 runtime 的后续判定永久宽松] → 计数在 `Runtime:flushCacheNow`
  与 `Runtime:reset` 一并清掉；且实测路径进出配对。
- [上限值过小导致正常场景被截断] → 64 与既有 `intersection` 护栏同量级；实测批量零变化。
