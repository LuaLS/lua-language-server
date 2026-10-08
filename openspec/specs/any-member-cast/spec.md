# any-member-cast Specification

## Purpose
约束「显式标注里带 `any` 成员的联合类型」（`X | any`）在类型检查中的地位：它等价于 `any`，
赋给/传给/返回给任何已标注类型都不报。三条类型检查（assign / param / return）必须同规则，
避免同一声明出现「赋值不报、传参报」的不一致。

## Requirements

### Requirement: 含 any 成员的联合等价于 any

实参/返回值/被赋值表达式的类型里**含 `any` 成员**（或本身就是 `any`）时，
类型检查 SHALL 按宽松放行（不报 assign / param / return 不匹配）；
该放宽 SHALL 由三条类型检查共享同一判定实现。

#### Scenario: 传参方向不报

- **WHEN** 实参类型是 `X | any`（X 不是 `any`），形参标注为 `string`
- **THEN** SHALL NOT 报 `param-type-mismatch`

#### Scenario: 返回值方向不报

- **WHEN** 返回值类型是 `X | any`，函数标注 `---@return string`
- **THEN** SHALL NOT 报 `return-type-mismatch`

#### Scenario: 赋值方向维持既有行为

- **WHEN** 被赋值表达式的类型是 `X | any`，变量标注 `---@type string`
- **THEN** SHALL NOT 报 `assign-type-mismatch`（与本规则落地前一致）

#### Scenario: 不含 any 成员时照旧报

- **WHEN** 实参/返回值类型是 `X`（不含 `any` 成员）且不可转换为目标类型
- **THEN** SHALL 照旧报对应的类型不匹配诊断
