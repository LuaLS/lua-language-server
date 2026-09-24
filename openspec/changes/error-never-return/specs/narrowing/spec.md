# Spec Delta

## Purpose

流收窄（flow narrowing）的定义：分支内读值的收窄规则，以及分支是否参与后续合并的判定。

## ADDED Requirements

### Requirement: 以 `never` 返回的调用结尾的分支不参与 fall-through 合并

若一个分支的最后一条语句是返回类型为 `never` 的调用（如 `error(...)`），
该分支 SHALL NOT 参与 fall-through 合并；后续读值 SHALL 保持进入该 `if` 之前的收窄。

#### Scenario: `error` 守卫之后的读值非 nil

- **WHEN** 代码形如 `local x = f()`（`f` 返回 `T?`）后接 `if not x then error('…') end`
- **THEN** `error(...)` 之后的 `x` SHALL 收窄为 `T`，且不报 `need-check-nil`

#### Scenario: 非 `never` 调用的分支仍参与合并

- **WHEN** 分支最后是普通调用（返回值可能为 nil）
- **THEN** 该分支 SHALL 照常参与 fall-through 合并，读值按原语义收窄
