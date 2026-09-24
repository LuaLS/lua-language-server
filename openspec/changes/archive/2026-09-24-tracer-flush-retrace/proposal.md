# Proposal

## Why

上一轮清完面板后，目标工程还剩 **276 条**，其中最大的单文件一族是
`script/parser/compile.lua` 的 **29 条 `need-check-nil`**，形状统一：

```lua
local child = parseExp()      -- parseExp 是没有 ---@return 注解的递归局部函数
...
if child then
    local rtn = { start = child.start, ... }   -- 29 条都报 Need check nil
```

## 定位（探针 + 中间码 + 临时打印）

1. `if child then` 的 **then 分支**里 `child` 的 flow 值 = **`never`**
   （`W:traceRef` 打印 `value=type:never`）⇒ 分支内读值退化成 nil
2. `child` 的静态值 = `select:nil`；拆开看：`selHead=fcall selKey=value:1 headReturns=nil selValue=nil`
   ⇒ `List:select(1)` 命中了**空 list** 分支（`values[key] or values[#values] or NIL`）
3. 同一个调用点在**不同时机**的 view 不一致：探针一次给 `fun(…):{...} | nil`（变量视图），
   一次给 `fun(…):nil`（调用点 head 视图）⇒ 与「编译早期算出来的结果被缓存」有关
4. 收窄值本身还叠加了第二层问题：`Node.Variable.currentValue` 由 Tracer 写入、随
   `class.flush` 失效，而 `Walker.started` 会让 `Node.Tracer:trace()` 直接返回 ⇒
   被清掉的收窄值**不会重算**（面板/诊断读到的就是退化的 `guess`）

## What Changes

1. **Tracer 按 flush 代数重跑**（`script/node/runtime.lua` 加 `traceEpoch`/`tracing`；
   `script/node/tracer.lua` 的 `M:trace` 按 `Walker.epoch` 决定是否重 walk，加 `running` 防重入，
   `W:getUpvalue` 改走 `parent:trace()`）
2. **返回值集合变化时失效缓存**（`script/node/function.lua` 的 `addReturnDef`/`addReturnList`
   加 `self:flushCache()`）

## Capabilities

### New Capabilities

### Modified Capabilities

（本轮无 spec 增量：两处候选都不采用）

## Impact

- 候选 1：`script/node/{tracer,runtime}.lua`
- 候选 2：`script/node/function.lua`

## 判据（先量后改）

- 基线：目标工程 **276** 条（`tmp/scan-round8.txt`）
- 目标：净减少且新增项可逐项分诊；全量 `--test` 保持绿

## 实测结论（2026-09-24，均不采用）

| 候选 | 目标工程 | 判决 |
|---|---|---|
| 候选 1（Tracer 按代数重跑） | 276 → 276（移除 0 / 新增 0） | 不采用：诊断链证明这条**不完整**——walk 内部的 `setCurrentValue` 会把自己登记进 flush 列表，早期写入的值在同一趟 walk 里就被清掉，而代数已在 walk 结束时对齐 ⇒ 不会再重跑；顺带 `Walker.started` 的早退被去掉后还暴露了两处调用点（`W:getUpvalue` 直接 `start`、以及重入）导致 C 栈溢出 / `stacks` 为空，说明这条路的边界很多 |
| 候选 2（`addReturn*` flushCache） | 276 → 276（移除 0 / 新增 0） | 不采用：说明空 list 不是（只是）early-cache 造成的 |
| 组合（1+2） | 276 → 276 | 同上 |

- 两次改动都**已回退**（`git checkout`），全量 `--test` 绿（每次改动前后各跑一次）
- 结论落台账 `facts/returns.md` **F2**（含完整的诊断链与下一步：先查清「调用点 head 的返回类型
  为什么是 `nil`」——是 `matchedFuncs` 拿到了另一个函数实例，还是 `returnsPack` 在递归求值里
  被当成 `PROVISIONAL` 后缓存）

## 下一步（下一轮入口）

1. 先把「调用点 head 的返回类型 = nil」单独钉死（最小 repro：无注解的递归局部函数 + `if f() then`）
2. 再决定是否动「收窄值的失效/重算」——那需要让 walk 的写入不受同趟 flush 影响
   （例如先收集 `written` 再统一写入），否则代数方案不闭合
