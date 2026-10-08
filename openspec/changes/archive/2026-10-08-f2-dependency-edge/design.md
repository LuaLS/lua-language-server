# Design

## Context

- 动机见 `proposal.md`；事实见 `facts/returns.md` F2、`facts/casts.md` F3、`facts/eval-context.md` E1–E3。
- 现有失效机制：`Node.RefModule:addRef` 登记反向依赖，`Node:flushCache` 沿依赖链清缓存；
  求值期内失效被推迟（入口 `lockCache` / 静默点批量 `unlockCache`）。
- 缺的那条边：`FCall.matchedFuncs` 只读函数，**没有** `f:addRef(self)`；
  `Function:addReturnList` 也不触发自身失效 ⇒ 「返回集合补齐」传不到调用。

## Goals / Non-Goals

**Goals**：补齐这条边，使早期残缺的返回集合能被作废重算；保持批量零新增诊断。

**Non-Goals**：不改 coder 的发射时机（不追求「首次求值前就齐」）；不改 `Select`/`FCall` 的缓存形态；
不动 `canCast` 护栏；不引入延迟失效/标记重算。

## Decisions

### D1 两处最小改动

- `FCall.__getter.matchedFuncs`：在 `result[#result+1] = f:resolveGeneric(map, ctx)` 同一循环里
  先 `f:addRef(self)`（对该调用登记反向依赖）。
- `Function:addReturnList`：`table.insert` 后 `self:flushCache()`。

### D2 为什么这两处就够（而不是给 `Select.value` 单独打补丁）

`facts/returns.md` F2 的探针链是 `FCall.returns → List:select(1) (空 list) → Select.value`。
空集合的源头是函数实例的返回集合未齐；只要「函数变化 → 调用失效 → 取值重算」这条链通，
`Select.value` / `FCall.returns` 的缓存会随依赖失效自动重算，无需各自打补丁。

### D3 上一轮爆栈的处置 + 护栏计数不能在失效点清

147k 爆栈的归因已修（`CAST_DEPTH_LIMIT = 64`，`facts/casts.md` F3）；本轮重放后实测不再爆栈。
**但落地时踩到一处**：`castDepth` 若在 `Runtime:flushCacheNow` 里清零，护栏等于不存在 ——
依赖边让失效在递归**中途**频繁发生（`addReturnList → flushCache`），每次失效都把计数归零，
立刻复现 `intersection.lua:151` 栈溢出。
⇒ 计数只在 **pass 边界**复位：`ls.feature.diagnostic` 入口（异常穿出的泄漏兜底）+ `Runtime:reset`（测试）。

## Risks / Trade-offs

- [失效变多导致重算成本上升 / 再次触发深递归] → 上一轮实测 `CAST_DEPTH_LIMIT = 64` 下不爆栈，
  批量扫描耗时与基线同量级；本轮复测基线数字与耗时。
- [面板侧（长会话）出现新的失效相关抖动] → 两行改动，出现问题可直接回退本 change；
  台账记「面板验证由用户在编辑器侧确认」。
- [依赖边登记让 `matchedFuncs` 结果被缓存但依赖集合变化] → `addRef` 只登记引用，
  不影响 `matchedFuncs` 的取值语义。
