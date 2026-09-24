# Design

## 观察到的三段链路

```
local child = parseExp()          -- 无 ---@return 注解的递归局部函数
if child then                     -- then 分支里 child 的 flow 值 = never ✗
    ... child.start ...
```

1. **阅读顺序**：诊断 provider 走 `vfile:getNode(var)` → `Variable.value` getter →
   `self.tracer:trace()` → 拿 `getCurrentValue() / getExpectValue() / getGuessValue()`
2. **收窄值失效**：`currentValue` 是 getter 字段（`setCurrentValue` 写入），`class.flush` 会清掉；
   `Walker.started` 一旦为真，`trace()` 直接返回 ⇒ 清掉后不会重算
3. **调用点 head 的返回类型**：`FCall:onView` 看到 head = `fun(…):nil`，
   而同一个 `parseExp` 变量节点在别的时机是 `fun(…):{...} | nil`；
   `List:select(1)` 命中「空 list ⇒ `NIL`」分支（`script/node/list.lua:128-130`）

## 候选 1：按 flush 代数重跑 walk（不采用）

```
runtime: traceEpoch（flush 清掉 raw currentValue 时 +1）、tracing（walk 中不做代数变更）
tracer : M:trace 里 walker.running 防重入；walker.epoch ~= rt.traceEpoch 时重跑 walk
```

实测 0/0，且诊断链暴露了方案的不闭合点：

- `setCurrentValue` 会 `flushCache()` 把自己登记进 flush 列表 ⇒ **同一趟 walk 内**，
  后一次写入触发的 flush 会把先前写好的值清掉
- 代数只在 walk 结束时对齐（`walker.epoch = rt.traceEpoch`），于是「被同趟 flush 清掉的值」
  与「没被清的值」无法区分 ⇒ 不会重跑
- 去掉 `Walker.started` 的早退后，`W:getUpvalue` 里直接 `walker:start(...)`（绕过了新的防重入）
  会重跑并清空 `stacks` ⇒ `attempt to index a nil value (local 'stack')`；
  该调用点改走 `parent:trace()` 后，另一条（闭包内递归）又触发 C 栈溢出 ⇒ 边界比预期多

## 候选 2：返回值集合变化时失效 `returnsPack`（不采用）

`addReturnDef` / `addReturnList` 加 `self:flushCache()`（与 `class.lua` 的 `addField` 同约定）。

实测 0/0 ⇒ 空 list 不是（只是）early-cache 造成的；`headReturns=nil` 说明
这个 head 的 `returns` 压根没算（或算在另一个实例上）。

## 下一步的两个前置

1. **最小 repro**：无注解的递归局部函数 + 在定义之前调用 + `if f() then`，
   钉住「调用点 head 的返回类型 = nil」这一事实（先不碰收窄/失效）
2. 若要走「收窄值失效」这条线，先让 walk 的写入不受同趟 flush 影响
   （收集 `written` 后统一写入，或写入后按需 `rawset` 回填），否则代数方案不闭合
