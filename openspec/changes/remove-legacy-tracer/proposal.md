# Proposal

## Why

在基于 4.0.0 的实验分支上移除旧 tracer，给后续单独讨论的 coder 流图实现留出干净的起点。

## What Changes

- 删除 coder 的 tracer 指令与传输数据、节点 walker、临时读值写回和对应探针。
- 删除 `Variable.staticValue`，普通 VM 取值保留 `assignValue`、赋值记录和注解查询。
- **BREAKING**：分支收窄、流式 `@cast` 和尾调用的 `noreturn` 推导暂时缺失；显式 `@noreturn` 保留。不实现替代流图。

## Capabilities

### New Capabilities

无。

### Modified Capabilities

`narrowing` 和 `noreturn` 存在实现缺口，先保留主规范与端到端用例，不把退化变成要求。本变更尚不能归档。

## Impact

- 语义依据：本仓库分支读取测试预期 `5`，删除后实测为初值 `10`；该断言不改。普通节点、多返回和模块加载专项通过。
- 目标工程诊断基线：改前和改后均未扫描，移除数和新增数未知；不沿用旧实验分支的数字。
- 试过但未采用：把即时写回测试直接改用 `setAssignValue`，观察到期望 `string`、实际仍为锁内缓存的 `string | nil`。普通赋值保留延迟刷新，不复刻 tracer 写回。
