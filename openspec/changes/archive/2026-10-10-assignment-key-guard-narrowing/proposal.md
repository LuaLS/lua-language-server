# Proposal

## Why

目标 main.lua:41 在 if key 守卫内的索引键方法调用仍报 need-check-nil；Lua 语义保证该处 key 非 nil。独立探针读值为 string、诊断批扫仍报，需定位诊断求值时序而非直接改写赋值顺序。

## What Changes

- 为索引赋值键读取与守卫建立正负向回归，定位收窄失效时序。
- 只修已取证的 Node/诊断求值问题，不改目标写法。
- 原始条数 97 → 117；按唯一位置/code 为 65 → 69（移除 4 / 新增 8）。此前 97 → 127 的差分不对应源于 8 个位置重复诊断 5 → 7 条，非消息变化。批扫打印现明确区分原始条数与唯一位置。
- 批扫补 withEval 后，锁内旧缓存最小回归失败：写 currentValue=string 仍读 string | nil。setCurrentValue 只清本变量 value 缓存，级联继续延迟；锁定基线 127 → 117（移除 10 / 新增 0）。
- 剩余 8 处新增都是 parser 字段候选误报，留到下一家族台账，不以新增数回退正确求值边界。
- 实际落点是批扫调用边界：真实诊断已有 withEval、直接批扫缺失，已按调用点补齐，未改 Node。
- 试过未采用：尚无实现实验；探针 string 与批扫报 nil 不一致，不据此假定 coder 漏编译。

## Capabilities

### Modified Capabilities

- `narrowing`: 守卫事实对索引赋值左侧键表达式读取同样有效。

### New Capabilities

无。

## Impact

tracer/Node 求值或诊断读取入口、诊断与节点测试、事实台账；无新增依赖。
