# Proposal

## Why

目标工程 utility.lua:713 将 any[] 传给 table<integer, any> 误报。本仓库约定 T[] 等价于整数索引表，因此注解与用法正确，转换语义应一致。

## What Changes

- 核查数组到整数索引表转换链，按 Node 机制最小修复。
- 增加数组元素兼容与不兼容、非整数索引对照，避免宽松放行所有表。
- 基线 98 → 97（移除 1 / 新增 0），本例消失；文件 tmp/array-index-before.txt 与 tmp/array-index-after.txt。
- 试过未采用：本轮尚无实现实验；不改目标注解绕过，不改数组下标增加 nil。

## Capabilities

### New Capabilities

- `array-index-cast`: 数组与索引表的结构转换兼容性。

### Modified Capabilities

无。

## Impact

Node 转换机制、节点与诊断测试、type-check 事实台账；无新依赖。
