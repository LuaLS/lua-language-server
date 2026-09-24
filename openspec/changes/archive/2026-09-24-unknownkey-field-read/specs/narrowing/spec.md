# narrowing Specification (delta)

## ADDED Requirements

### Requirement: 动态键标记作为读值时的字段读取

`unknownkey` 是动态键写入（`t[expr] = v`，键不可解析）的标记类型，它不携带成员集。
当读值恰为 `unknownkey` 时（典型来源：`for k in pairs(t)` 的键），
其字段读取 SHALL 按 `any` 处理，SHALL NOT 报「未定义字段」——
与 `any` / `unknown` / `truthy` / `provisional` 一致。

#### Scenario: 遍历含动态键写入的表

- **WHEN** 某表被动态键写过值（`t[k] = v`），随后 `for k in pairs(t) do k.field end`
- **THEN** `k` 的读值 SHALL 是 `unknownkey`，`k.field` SHALL 得到 `any`
- **AND** SHALL NOT 报 `undefined-field`

#### Scenario: 动态键的写入/读取结构语义不受影响

- **WHEN** 以同一变量节点为键对表做写入与读取（F9/F10/F12 的往返）
- **THEN** 字面量键读取 SHALL 不命中动态键写入的字段（保持原有语义）
- **AND** `unknown` 键读取 SHALL 能命中
