# Spec Delta

## Purpose

`---@noreturn` 与「永不正常返回」语义：让调用（`error` 一类总是抛错的函数）之后的分支
被判为不可达，从而不把不该有的 `nil` 带进后续收窄；同时支持对未注解包装函数做函数级推断。

## ADDED Requirements

### Requirement: `---@noreturn` 注解使调用之后的分支不可达

函数定义上标注 `---@noreturn` 时，该函数 SHALL 被视为永不正常返回。
对它的调用作为语句出现时，同一分支在其之后的语句 SHALL 视为不可达，
该分支 SHALL NOT 参与该 `if` 之后的收窄合并（与以 `return` 结尾的分支同待遇）。

#### Scenario: 守卫之后不再带 nil

- **WHEN** 代码为 `if not i then fatal("bad") end`，其中 `fatal` 标了 `---@noreturn`，`i` 的类型是 `integer | nil`
- **THEN** `if` 之后读 `i` 得到 `integer`，SHALL NOT 报与 `nil` 相关的诊断（如 `need-check-nil`、`assign-type-mismatch`）

### Requirement: 函数级 `noreturn` 推断

函数体（不含嵌套函数）的最后一条语句是对 `noreturn` 函数的调用时，
该函数自身 SHALL 被视为 `noreturn`，即使它没有任何 `---@noreturn` 注解。

#### Scenario: 未注解的包装函数

- **WHEN** 代码为 `local function decode_error(msg) error(msg) end`（`error` 为内建 `noreturn`），调用点写成 `if not i then decode_error("bad") end`
- **THEN** `decode_error` SHALL 被推断为 `noreturn`，`if` 之后的 `i` SHALL 收窄到非 `nil` 侧

### Requirement: 内建 `error` 是 `noreturn`

标准库声明中 `error` SHALL 标为 `noreturn`（`error` 总是抛出，从不正常返回）。

#### Scenario: 直接调用 error

- **WHEN** 代码为 `if not i then error("bad") end`
- **THEN** `if` 之后的 `i` SHALL 收窄到非 `nil` 侧

### Requirement: 普通调用 SHALL NOT 终止分支

除 `noreturn` 调用外，作为语句的普通函数调用 SHALL NOT 让分支被认为终止。

#### Scenario: 普通调用后仍需判空

- **WHEN** 代码为 `if not i then log("miss") end`，`log` 是普通函数（有返回、可正常返回）
- **THEN** `if` 之后读 `i` 仍是 `integer | nil`，后续对 `i` 的 `nil` 检查 SHALL 仍被要求

#### Scenario: 未知函数不得当作终止

- **WHEN** 被调用者类型无法解析为函数定义（`any` / 动态字段调用）
- **THEN** 该调用 SHALL NOT 终止分支
