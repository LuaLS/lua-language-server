# Design

## 语义依据（本仓库自己的语义）

- `---@class X` + `local x = <值>` 的语义是「把该值绑定为 X 的一个实例/来源」：
  coder 里 `tryBindCat`（`script/vm/coder/state.lua:40-54`）对 `catstateclass` 发
  `var:addClass(class)` + `class:addVariable(var)`，类字段经
  `Node.Class.fields`（`---@field`）与 `Node.Variable.fields`（绑定值的字面量字段）
  两条汇入 `Type.variableTable` / `extendsValue`。
- 因此「绑定值的字段」有两个用途，必须分开：
  - **读取**：知道即可 ⇒ 应当可见（本轮补上「经调用返回」这条缺口）。
  - **赋值**：是注解要求还是推断？只有 `---@field` 与继承是声明 ⇒ 推断出来的不能当要求。
- 目标工程 `assign-type-mismatch` 里对 `hasMarkClass`（赋值目标带 `---@class`）另做一次宽松
  比对，语义上也是「类标注目标的赋值不按字面量字段硬比」。

## 实现要点

1. `script/node/variable.lua` `Variable.fields`：
   赋值值 `kind` 为 `call` / `fcall` / `select` 时，`value:each('table', ...)` 把沿 value 链
   取到的表并入字段来源（`select` 需要，因为编码器把调用结果包了一层 `Node.Select`）。
   只扩调用这一种：变量值的字段本来就经变量自身的 value 可达，扩到全部会改变
   `local t = X` 的形状（`test/node/variable.lua:234` 钉住）。
2. `script/feature/diagnostic/providers/assign-type-mismatch.lua`：
   用 `variable.classes`（即 `tryBindCat` 的 `addClass` 结果，`---@param` / `---@type`
   不会填它）判「类标注目标」；命中时取各绑定类的 `fields` 与 `extends` 里的
   `Table` / `Type.fieldTable` 合成要求表，`actual >> 要求表` 不再用完整 `expect`。
   `expect` 仍用于消息与「非表值」判定（空表要求下非表值仍不通过）。
   目标工程 `parser.object` 那一族（65 条 `node = getfield`）来自 `---@param node parser.object`，
   是**参数注解**声明的必填字段 ⇒ 不受影响，属目标工程注解偏松（台账已记）。

## 未决 / 已知分歧

- **循环变量在部分时机退回列表值**：`for _, ret in ipairs(returns)` 里，若循环前用
  「形参注解比实参宽」的函数调用过同一个表（如 `countList(returns)`，形参 `Obj[] | nil`），
  嵌套 if 内的读位置会把 `ret` 解析成列表值本身（`Obj[] | nil`）⇒ 元素字段读误报
  `undefined-field`。最小复现 `test/project/repro/ipairs-narrow-field.lua`，
  同族 = 目标工程 `missing-return-value.lua:30/31`、`parser/compile.lua:3451`；
  台账 `facts/returns.md` F3（与 `facts/narrowing.md` F19 同一「读到未收窄值」的家族）。
- **`MT['__index']` 的泛型绑定**：`setmetatable(t, { __index = X })` 当前解析成
  `T & (any | nil)`（`MT` 未绑定 → 拿的是约束 `table|nil` 的字段），因此
  `---@class B` + `setmetatable({}, {__index = A})`（A 与 B 无继承）在**默认配置**下不出诊断，
  而目标工程自己的测试期望它报（仓库配置下面板里仍会报）。要精确对齐得先修
  「返回位置上的泛型字段读取」，不在本轮范围。
