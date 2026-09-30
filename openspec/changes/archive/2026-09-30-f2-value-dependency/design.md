# Design

动机与「试过未采用」见 `proposal.md`；事实见 `facts/returns.md` F2 与 `facts/eval-context.md` E1–E3。

## Context

F2 的失效路径缺失（函数 → 调用的依赖边没登记；`returnsPack`/`FCall.returns`/`Select.value` 的早期结果
一直留在缓存里）。change #24 补那条边时炸在 **147014 层栈溢出**；当时的归因是「清缓存 ⇒ 节点重建 ⇒
身份键环保护失效」。change #25 把 `intersection` 的环保护换成**结构签名键**并引入「求值期不失效」，
所以本轮**重放**那条路以验证归因。

## Goals / Non-Goals

**Goals**：验证「新地基能否让 F2 的依赖边方案收敛」；无论成败都把实测数字与新栈记进台账。

**Non-Goals**：不在本轮修 `intersection` 的深度护栏；不做目标侧注解（C 方案，另轮）；不动 coder/parser。

## Decisions

### D1 先重放，不先改设计

直接把 #24 的两处改动放回去（`f:addRef(self)` + `addReturnList → flushCache()`），跑目标工程比对。
**结果：仍 147014 层爆栈**（`script\class.lua:593 → intersection.lua:154 buildValues
→ intersection.lua:254/270 → intersection.lua:382 onCanCast → node.canCast → …`，起点仍是
`undefined-field provider`）。

### D2 归因修正：这是**深度爆炸**，不是签名环

- 结构签名键的环保护**不触发**：`buildValues` 每层经 `rt.intersection(parts)` **新建**交集节点，
  签名各不相同 ⇒ 没有"同一个签名再次进入"的情形；
- `values` getter 里已有的 `enterDepth(state)` + `DEPTH_LIMIT = 64` **没有拦住**这条路径
  ⇒ 需要另查：`buildValues → rt.intersection(...) → 新节点的 value getter` 是否都在计数内、
  以及 `state.taskDepths` 的 task 键在递归里是否稳定（`ls.task.getCurrentTask()` 的语义）。
- ⇒ 结论：**F2 的依赖边方案在「深度爆炸」修掉之前都不可能采用**（这次实测把 change #24 的归因
  从"身份键"修正为"深度 + 签名各不相同"）。

### D3 本轮不采用代码改动

实验已 `git checkout` 回退；把栈、层数、修正后的归因写进 `facts/returns.md` F2。
下一步入口（二选一）：
1. 查 `DEPTH_LIMIT` 为什么没拦住 `buildValues` 的递归（若是计数/任务键问题，修它即可让 F2 方案可用）；
2. 目标侧 C 方案：给无注解递归函数补 `---@return`（`returnsDef` 在编码期即有值 ⇒ `Select` 首次计算
   就正确），代价是要盯住新的返回值不匹配诊断。

## Risks / Trade-offs

- [重放实验把批量扫描跑崩] → 只在 test 模式下爆栈（`--test` 的 harness），生产路径不加载该 harness；
  实验已回退、基线 154 未受影响（改动前后均为 154）
- [归因再次偏差] → 已把「结构键也拦不住」与「DEPTH_LIMIT 未拦住」两条写进台账，避免下次再按老归因重试

## Migration Plan

无（本轮不落地代码）。后续按 D3 的两个入口之一开新轮。
