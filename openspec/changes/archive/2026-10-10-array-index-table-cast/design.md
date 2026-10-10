# Design

## Context

见 proposal.md。Array:get(INTEGER) 返回元素，Table:onCanBeCast 逐目标键检查，但 table 泛型实例可能通过其它包装的 onCanCast 先行失败；先用最小诊断和节点测试定位。

## Goals / Non-Goals

**Goals:** T[] 向整数索引表转换只按元素兼容性判定，错误元素保留诊断。

**Non-Goals:** 不重写泛型、数组 nil 语义或类字段宽限。

## Decisions

- 最小节点测试证明数组对裸整数索引表已经兼容，拦截点为 Node.Call 缺少目标侧 onCanBeCast。复杂泛型实例委托 other:canCast(self.value)，复用 Table 既有结构转换，不在诊断 provider 特判。
- 测试同时覆盖裸结构表与 table<integer, T>，辨别泛型包装与数组自身问题。

## Risks / Trade-offs

- any 可能掩盖元素错误 → number[] 对 string 索引值的负向断言。
- 字符串索引被数组误接受 → 对不同键域保留不兼容断言。
- 批量变化 → 比较目标基线并逐条做语义判断，不以新增数直接决定去留。
