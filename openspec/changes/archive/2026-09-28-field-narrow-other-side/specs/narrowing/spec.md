# narrowing Specification (delta)

## ADDED Requirements

### Requirement: 字段判等收窄的「另一侧」不按补集整块排除

`x.field == 值` 的另一侧（`x.field ≠ 值`）SHALL NOT 用「字段可能相等」那批成员
（narrowed）的补集作为成员集合：①「没有该字段」的成员 SHALL 保留（F18 已定），
②「字段是多值（`string` / `any` 一类）、去掉这一个字面量后还有别的取值」的成员 SHALL 保留；
只有「字段恰是该值」（单值且互相可转）的成员 SHALL 在这一侧被排除。
真值测试（`if x.field then` 一类，传进来的「比较值」是字段自己的类型）SHALL 维持
「按字段能否取到该值」互补的判定。

#### Scenario: 多值字段的成员在另一侧保留

- **WHEN** `src : A | B`，`A.type: string`（多值）、`B.type: 'b'`（字面量），条件为 `src.type == 'x'`
- **THEN** 假分支里 `src` SHALL 仍含 `A`（`A.type` 可以 ≠ `'x'`）
- **AND** 读 `A` 独有的字段 SHALL NOT 报 `undefined-field`

#### Scenario: 恰是该值的单值成员在另一侧排除

- **WHEN** 某成员的字段类型恰是 `'x'`（单值），条件为 `x.field == 'x'`
- **THEN** 该成员 SHALL NOT 出现在另一侧（它的字段不可能 ≠ `'x'`）

#### Scenario: 真值测试的行为不变

- **WHEN** 条件为真值测试（`if x.field then`），且字段类型恒真（如 `string`）
- **THEN** 假分支的成员集合 SHALL 仍是「字段能取到假值」的那批（本例为空）
