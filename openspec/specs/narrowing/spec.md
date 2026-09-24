# narrowing Specification

## Purpose

流收窄（flow narrowing）的系统行为：判等 / 真值 / 动态键判定的收窄结果，
以及收窄标记（`truthy` / `falsy`）作为读值暴露时的语义。
事实台账（`.github/skills/luals-server-dev/references/facts/<能力>.md`）是证据层，
本目录逐步承接其「已成立」的结论（迁移中，2026-09-24 起）。

## Requirements

### Requirement: 真假标记 `truthy` 作为读值时不产生字段存在性误报

`truthy` 是收窄标记（不携带成员集）。当读值恰为 `truthy` 时，其字段读取 SHALL 按 `any` 处理，
SHALL NOT 报「未定义字段」。

#### Scenario: 对 `truthy` 读值取字段

- **WHEN** 某表达式被真值收窄成 `truthy` 后立即读它的字段（`if x then x.field end` 一类）
- **THEN** 该字段读取 SHALL 得到 `any`，且不报 `undefined-field`

#### Scenario: 真值收窄本身不受影响

- **WHEN** `if not args or not other then return end` 之后用 `args` 做实参反推（F2）
- **THEN** `args` 的 `truthy` 标记 SHALL 保留，反推结果里的 nil SHALL 仍被去掉

### Requirement: 复合条件向外暴露的「另一分支」事实不漏键

`and` / `or` 节点向外交出的另一分支事实（`otherSide`）SHALL 覆盖两侧操作数各自贡献的键：
两侧都有则取并集，仅一侧有则取该侧。嵌套操作数（`(A and B) and C`）作为左侧时，
其内部已成立的真值事实 SHALL 继续向外传达。

#### Scenario: 嵌套 and 链里后续操作数不继承左侧的假值降解

- **WHEN** 追踪 `if not (A and B and C) then` 的假分支（`revert = true`），
  其中 `A`、`B` 是 `any` 上的字段读取
- **THEN** 求值 `C` 时读 `B` SHALL 得到真值事实（`truthy`），SHALL NOT 得到 `A` 的假值降解
  （`false | nil`）；对 `B` 取字段 SHALL NOT 报 `undefined-field`

#### Scenario: and 为真时不丢左侧的真值事实

- **WHEN** 追踪 `if A and B then`（`revert = false`）
- **THEN** `B` SHALL 继承「`A` 为真」的事实，`A` 被排除的假值 SHALL NOT 出现在 `B` 的读值里

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
