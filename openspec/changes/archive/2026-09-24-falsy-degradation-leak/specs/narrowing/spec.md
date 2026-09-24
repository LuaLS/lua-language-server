# narrowing Specification (delta)

## ADDED Requirements

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
