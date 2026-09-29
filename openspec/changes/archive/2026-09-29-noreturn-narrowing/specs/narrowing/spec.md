# Spec Delta

## ADDED Requirements

### Requirement: 以 noreturn 调用结尾的 `if` 分支不参与后续收窄合并

`if` 的某个分支以「永不正常返回的调用」结尾时（`---@noreturn` 函数，或推断为 `noreturn` 的函数），
该分支的流 SHALL NOT 参与 `if` 之后的收窄合并；合并时 SHALL 只取该分支守护后的另一侧，
与以 `return` / `goto` / `break` / `continue` 结尾的分支同待遇。

#### Scenario: 守卫后的非 nil 收窄

- **WHEN** `i` 为 `integer | nil`，代码为 `if not i then decode_error("bad") end`（`decode_error` 永不正常返回）
- **THEN** `if` 之后 `i` SHALL 是 `integer`（不并入 `nil`）

#### Scenario: 返回值注解不因守卫合并而误报

- **WHEN** 函数体把守卫后的整数写入表字段并 `---@return {f: integer}` 返回该表
- **THEN** SHALL NOT 报 `return-type-mismatch`（实参字段不再含 `nil` 成员）

#### Scenario: 普通分支照常合并

- **WHEN** 分支以普通调用结尾（该函数可以正常返回）
- **THEN** 两支的流 SHALL 照常合并，`if` 之后的收窄结果与改动前一致
