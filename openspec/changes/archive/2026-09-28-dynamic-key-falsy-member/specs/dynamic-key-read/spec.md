# dynamic-key-read Specification (delta)

## ADDED Requirements

### Requirement: 动态键读取的元素推导不掺基值的「恒假」成员

键不可静态解析的索引读取（`t[expr]`）SHALL 按基值求元素类型；
基值联合体里**恒假**的成员（`nil` / `false`，运行期不能被索引）SHALL NOT 参与推导。
元素类型自身含 nil（`(integer|nil)[]`）SHALL 不受影响；基值恒假时 SHALL 保持原行为
（取不到元素）。

#### Scenario: 可选字段读出来的数组

- **WHEN** `local lines = state.lines`（`state` 已被 `if not state then ... end` 守卫，
  但槽位上的值仍是 `integer[] | nil`），随后 `lines[row]`（`row` 是变量）
- **THEN** 该读取的元素类型 SHALL 是 `integer`（不带那层 nil）
- **AND** 传给 `---@param v integer` 的形参 SHALL NOT 报 `param-type-mismatch`

#### Scenario: 元素类型自身含 nil

- **WHEN** 基值是 `(integer|nil)[]` 或 `(integer|nil)[]?`
- **THEN** 元素类型 SHALL 仍是 `integer | nil`

#### Scenario: 基值恒假

- **WHEN** 基值联合体全是恒假成员（如只有 `nil`）
- **THEN** SHALL 保持原行为（元素取不到，不额外补 nil 也不报错）
