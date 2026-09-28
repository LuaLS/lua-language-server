# class-fields Specification

## Purpose
TBD - created by archiving change class-field-visibility. Update Purpose after archive.

## Requirements

### Requirement: `---@class` 绑定值推断出的字段对读取可见

`---@class X` 的字段集 SHALL 包含「绑定到 X 的变量的字面量字段」；
绑定值经**调用返回**（`local x = setmetatable({ field = ... }, ...)`）时，
该字面量的字段同样 SHALL 计入。以 X 为类型的方法体（`self`）或该变量读其字段时，
SHALL NOT 报「未定义字段」。

#### Scenario: 同名类第二次绑定经 `setmetatable`

- **WHEN** `---@class C` + `local builder = { switch = 1 }`，随后同一函数/文件里
  `---@class C` + `local b = setmetatable({ extra = true }, { __index = builder })`
- **THEN** `b.extra` 与 `builder` 方法体里的 `self.extra` SHALL 都可读
- **AND** SHALL NOT 报 `undefined-field`

#### Scenario: 无注解的 `setmetatable` 返回值

- **WHEN** `local t = setmetatable({ a = 1 }, {})`（无 `---@class`）
- **THEN** `t.a` SHALL 可读（与变量值路径一致）
- **AND** SHALL NOT 报 `undefined-field`

### Requirement: `---@class` 目标的赋值检查不要求「推断出来的字段」

赋值目标是 `---@class` 标注（该变量绑定了类）时，赋值检查 SHALL 只按 `---@field`
声明的字段与继承来的字段比对；由绑定值推断出来的字段 SHALL NOT 作为赋值要求
（推断字段是「读取可见性」，不是注解要求）。非表值（如 `local d = 1`）SHALL 仍报
`assign-type-mismatch`。

#### Scenario: 同名类多次声明各自绑定部分字段

- **WHEN** `---@class Dup` + `local d1 = { a = 1 }`，随后 `---@class Dup` + `local d2 = { b = 2 }`
- **THEN** 两次绑定 SHALL 均不报 `assign-type-mismatch`

#### Scenario: 非表值仍要报

- **WHEN** `---@class Dup2` + `local d = 1`
- **THEN** SHALL 报 `assign-type-mismatch`

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
