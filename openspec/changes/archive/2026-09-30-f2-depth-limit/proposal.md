# Proposal

## Why

`facts/returns.md` F2 的「依赖边」修法（函数返回集合变化 → 失效 → 重算）两次实测都以
**147014 层栈溢出**告终，归因一度是「深度爆炸」。本轮查清了**护栏失效的机制**：

- `intersection` 的 `enterDepth` + `DEPTH_LIMIT = 64` 只数**自己 getter** 的嵌套，
  而失控发生在 **`Node:canCast` 的递归**那一层（`canCast ↔ onCanCast/onCanBeCast` 互相下探）。
  实测插桩：`values` getter 嵌套 `maxNesting=9`、构造嵌套 `maxInitNesting=1`、守卫计数 `maxD=19`、
  `bailDepth=0`、`states=0 / tasks=0 / rts=1`（不是状态/任务/运行时被分片）——**护栏装错了层**。
- 为什么 `canCast` 不会被剪枝：`castCache` 的环保护键是节点**身份路径** `{self, other}`，
  而这条链**每层都新建节点**（`intersection.buildValues` → `rt.intersection(parts)`），身份永不重复。

因此本轮落地 `canCast` 的深度上限：它既消掉真实存在的 147k 爆栈风险，又让 F2 的依赖边方案变为可采用。

## What Changes

- `script/node/node.lua`：新增 `CAST_DEPTH_LIMIT = 64`；`M:canCast` 改为「深度包装」，
  原实现挪到模块级 `castImpl`；超限按 unknown（宽松 `true`，与 `castCache` 命中 `'unknown'` 同义）返回。
- `script/node/runtime.lua`：新增 `Runtime.castDepth` 字段；在 `flushCacheNow` 与 `reset` 里一并清掉
  （异常穿出时不留「永久宽松」）。
- 不落地（本轮决定）：F2 的依赖边补丁（`f:addRef(call)` + `addReturnList → flushCache`）——
  已实测在新护栏下**不再爆栈**且 154 → 149（移除 5 / 新增 0），但它在**面板**（长会话/缓存时机）
  上的效果需要另轮单独验；本轮只把它记成「可采用」，不引入。

## Capabilities

### New Capabilities

- `cast-guard`：转换判定的有界性（上限 + 超限按 unknown 放行）。

### Modified Capabilities

无。

## Impact

- 代码：`script/node/node.lua`（+约 20 行）、`script/node/runtime.lua`（+4 行）。
- 语义依据（本仓库自己的语义）：`castCache` 命中 `'unknown'` 时 `canCast` 已经返回 `true`
  （宽松放行）——「超限」复用同一语义，不新造取值。
- 诊断基线：目标工程 `D:\github\vscode-lua\server` **154 → 154（移除 0 / 新增 0）**（零行为变化）。
- 本仓库问题面板：0（error / warning / information；hint 不管）。
- 全量 `--test`：绿。

## 试过但未采用

- **调大 / 调小 `intersection` 的 `DEPTH_LIMIT`**：护栏根本不在失控链上（实测 `bailDepth=0`、
  `maxD=19`），改数值无效。
- **用结构签名键替代 `castCache` 的身份键**（按 `typeName`/`kind` 组合剪枝）：能命中「每层结构相同」
  的环，但会改变正常路径的裁剪时机（未实测），且与既有身份键语义并存会变成两套判定。
- **本轮一并落 F2 依赖边补丁**：实测可行（149，0 新增），但按「一轮一改」拆开，
  且它的主要收益在面板侧，需要单独一轮带面板验证。
