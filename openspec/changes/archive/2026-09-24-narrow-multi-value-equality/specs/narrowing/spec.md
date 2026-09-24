# narrowing Specification (delta)

## ADDED Requirements

### Requirement: 多值类型与单值比较的判等收窄

多值类型（`string` 一类，或含多值成员的联合体）与**单值**比较值判等时，
相等侧 SHALL 是该单值本身（交集），SHALL NOT 是 `never`——除非该单值与本类型不相容。
不等侧 SHALL 保留仍能取到其它取值的成员（多值成员只去掉一个字面量仍要保留）。

#### Scenario: `string` 与字面量判等

- **WHEN** `---@type string` 的 `x` 与 `'a'` 判等（`x == 'a'`）
- **THEN** 相等侧 SHALL 是 `'a'`，不等侧 SHALL 是 `string`
- **AND** 该收窄结果写入流后，后续读值 SHALL NOT 出现 `never`

#### Scenario: 联合体里的多值成员

- **WHEN** `'generic' | string` 与 `'doc.field'` 判等
- **THEN** 相等侧 SHALL 是 `'doc.field'`（不收留整个 `string`）
- **AND** 不等侧 SHALL 保留 `'generic'` 与 `string`

#### Scenario: 不相容时相等侧仍为不可能

- **WHEN** `number` 与 `'a'` 判等
- **THEN** 相等侧 SHALL 是 `never`

### Requirement: 字段反推在「不等于」方向不得收窄缺字段的基值成员

`x` 的成员里有缺 `key` 字段的成员时，`x.key ~= 值` 的**不等于**方向 SHALL NOT 按字段
把 `x` 收窄成「不满足」的那批成员；相等方向不受此限。

#### Scenario: 成员缺字段时的 `~=` 反推

- **WHEN** `x: { base: { type: string } } | { other: 1 }`，条件为 `x.base.type ~= 'local'`
- **THEN** `x` 的读值 SHALL 保持原联合体（不得变成缺 `base` 的那个成员或 `never`）
- **AND** 随后对 `x.base` 的访问 SHALL NOT 报未定义字段

#### Scenario: 相等方向的反推照旧

- **WHEN** `node.type == 'global'`（字段类型是多值）
- **THEN** 该反推 SHALL 照常把基值收窄到满足条件的成员
