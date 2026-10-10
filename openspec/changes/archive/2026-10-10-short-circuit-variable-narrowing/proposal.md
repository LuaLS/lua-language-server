# Proposal

## Why

目标工程 `script/workspace/require-path.lua:81` 的 `libUri and furi.decode(libUri)` 误报可选实参。Lua 短路语义保证右侧执行时左侧为真，当前值位置遍历未把这条事实传到不同读取点。

## What Changes

- 在新的 tracer 中增加限定于右操作数的变量身份收窄通道，不改变条件位置与旧 flow/branch。
- 覆盖直接变量、嵌套逻辑与作用域退出，保留真实类型错误。
- 最终基线：原始 103 → 98（移除 5 / 新增 0）；相对基础值阶段 100 → 98（移除 2 / 新增 0），完整方案此前新增的 compile.lua:3697 已修复。
- 类/表扩展落地：联合体临时收窄须按当次已解析成员重建快照，避免 rawNodes 的可变包装在后续重新展开时回染 nil。
- 验收以语义为准：新增真实问题可接受；新增误报须修复，移除诊断不能依赖错误类型掩盖。继续核查新增条目及完整方案额外移除条目。
- 试过但未采用：A 复用条件位置走法，103 → 99（移除 8 / 新增 4）；B 按 read-site id 垫临时栈，103 → 103（移除 0 / 新增 0）。本轮改用变量身份，不重走这两条路径。

## Capabilities

### New Capabilities

无。

### Modified Capabilities

- `narrowing`: 值位置短路表达式的右侧读取继承左侧可靠真假事实，事实不外泄。

## Impact

`script/node/tracer.lua`、诊断与节点测试、收窄事实台账及轮次纪要。无新增依赖，不改目标工程。
