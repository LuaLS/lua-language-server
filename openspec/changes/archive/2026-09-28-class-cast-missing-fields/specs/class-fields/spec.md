# class-fields Specification (delta)

## ADDED Requirements

### Requirement: 「表值 → 类」的缺字段不算不匹配

实参是**表**、与该类**有同名同字段的交集**、但**缺**该类其它必填字段时，
`实参 >> 该类` SHALL 为相容（缺字段交给 `missing-fields` 一类专门规则）。
交集里的字段类型 SHALL 照旧比较；字段齐全的、以及与该类毫无交集的表
（`{[1] = ...}` 这类索引构造）SHALL 走原判据。

#### Scenario: 部分字段的字面量

- **WHEN** `---@class C ---@field kind string ---@field n integer`，实参 `{ kind = 'x' }`
- **THEN** 该实参传给 `C` 类型的形参 SHALL NOT 报 `param-type-mismatch`

#### Scenario: 已出现字段的类型仍要比

- **WHEN** 同上，实参 `{ kind = 1, n = 1 }`
- **THEN** SHALL 报 `param-type-mismatch`

#### Scenario: 字段齐全 / 无交集

- **WHEN** 实参字段齐全（`{ kind = 'x', n = 1 }`），或与该类毫无交集（`{ other = 1 }`）
- **THEN** SHALL 走原判据（前者相容、后者不匹配）
