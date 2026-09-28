# 事实台账：类字段（`---@class` 绑定值的字段集）

格式同 `narrowing.md`：断言 / 证据 / 代码 / 状态。

## F1 `---@class` 绑定值推断出的字段：读取可见，但不是赋值要求

- 断言：
  1. `---@class X` + `local x = <值>` 的**字面量字段**属于 X 的字段集；值经**调用返回**时
     （`local x = setmetatable({ field = ... }, ...)`，编码器可能包一层 `Node.Select`）同样算。
     以 X 为类型的方法体 `self.field`、或该变量 `x.field` 读取，都不该报 `undefined-field`。
  2. 目标是 `---@class` 标注（`variable.classes` 非空）时，赋值检查只按 `---@field` 与继承字段比对；
     由绑定值推断出来的字段**不是**赋值要求 —— 否则「同名类多次声明、各自绑定部分字段」的
     装配写法会互相要求对方缺的字段。
- 证据：
  - `test/project/repro/class-table-fields.lua` —— 目标工程 `plugins/ffi/init.lua` 的形状
    （同名 `---@class` 两次 + 第二次经 `setmetatable({...}, { __index = builder })`），修前
    `self.globalAsts` / `b.globalAsts` / `b.cacheEnums` 误报未定义字段，且两次绑定互相报
    `assign-type-mismatch`；现在整个文件 0 诊断
  - `test/project/repro/class-setmetatable.lua` —— 对齐目标工程测试
    （`test/diagnostics/assign-type-mismatch.lua`）里的 4 种写法：`B: A` + `setmetatable({}, a)`、
    `B: A` + `{__index = a}`、`MyClass` 两次声明 + `setmetatable({initialField = true}, self)`
    都不报；`B`（与 `A` 无继承）+ `{__index = a}` 是**预期报错**那条（文件里 disable 注明）
  - `test/project/repro/setmetatable-fields.lua` —— 对照：无 `---@class` 时
    `setmetatable({ a = 1 }, {})` 的字段本来就读得到
  - 钉：`test/feature/diagnostic/undefined-field.lua`（末条：类第二次绑定经 `setmetatable` 不报）、
    `test/feature/diagnostic/assign-type-mismatch.lua`（末两条：`---@class` 多次绑定不报；
    `---@class` + `local d = 1` 仍报）
- 代码：
  - `script/node/variable.lua` `Variable.fields`：赋值值 `kind` 为 `call` / `fcall` / `select` 时
    `value:each('table', ...)` 并入其返回的表（只扩调用，见「试过」）
  - `script/feature/diagnostic/providers/assign-type-mismatch.lua`：`getDeclaredFields`
    取 `variable.classes` 各绑定类的 `fields` + `extends` 里 `Table` / `Type.fieldTable`
    合成要求表，用它替代完整 `expect` 做 `actual >> requireType`
- 数字：目标工程 274 → **270**（移除 4 / 新增 0）：`plugins/ffi/init.lua` 2 条 `undefined-field`
  （88 / 348）+ 3 条 `assign-type-mismatch`（85 / 340 / `parser/compile.lua:5084` 的
  `local state = {...}` → `parser.state`，后两条是改动前就存在的同族误报）
- 试过（别重走）：
  1. `Variable.fields` 对**所有**赋值值（不限调用）沿 value 链找表 —— 目标工程同样 270，
     但 `test/node/variable.lua:234`（`X.a = 1; local t = X` 断言 `t.fields == false`）挂；
     变量值的字段本来就经变量自身的 value 可达，不需要从这里再引一遍
  2. `Type:onCanBeCast` 的类分支改成只用 `fieldTable + extendsTable`（改 cast 语义本体）——
     会一并影响 `param-type-mismatch`（目标 144 条）等面，风险面太大，未采用
  3. `hasAnyMember` 扩到 `intersection`（把 `setmetatable` 返回的 `T & (any | nil)` 直接放行）——
     只压掉 1 条，且语义上 `T & any` 应等于 `T`、不能当 `any` 用，未采用
- 边界（现状，别把这两条当误报改）：
  - `parser.object` 一族（目标工程 `parser/compile.lua` 的 `node = getfield` 等 65 条
    `assign-type-mismatch`）来自 `---@param node parser.object`，是**参数注解**声明的必填字段，
    不受本轮影响 —— 属目标工程注解偏松
  - `---@class` + 字面量缺 `---@field` 字段**不报**（`{ y = 1 }` vs `---@field x integer`）：
    `Table:onCanBeCast` 对空表/开放字面量本就不判；本轮只把「推断字段」从要求里去掉，没放宽声明字段
- 状态：成立（2026-09-28）

## F2 `setmetatable(t, { __index = X })` 的 `__index` 分量没进返回值（未满足）

- 断言（未满足）：`MT['__index']`（`meta/template/basic.lua` 里 `setmetatable` 的
  `---@return T & MT['__index']`）应当解出实参 `MT` 的 `__index` 字段类型；
  现在 `MT` 拿的是约束 `table|nil`，于是 `setmetatable({...}, { __index = A })`
  的值恒为 `T & (any | nil)` —— `__index` 的类完全没进来
- 证据（探针）：`--test project.probe --test-project=<目标工程或 repro 目录> --probe-file=class-table-fields.lua --probe-filter=call@`
  → `call@15:15 kind=fcall view=(fun<T:table, MT:table | nil, V>(table: T, metatable?: MT):T & (any | nil))(...)`；
  自写同签名的局部函数（非可选的 `mt: MT`）同样如此 ⇒ 与可选参数无关
- 影响：`---@class B` + `setmetatable({}, { __index = A })`（A 与 B 无继承）在**默认配置**下
  不报 `assign-type-mismatch`（目标工程测试期望报）；B 继承 A 时不报是对的
- 代码：泛型在**返回位置的字段读取**（`MT['__index']`）上的解析；见
  `script/node/generic.lua`、`script/node/call.lua` / `script/node/fcall.lua`（`resolveGeneric`）
- 状态：未满足（open）。要精确对齐目标工程测试，先修「返回位置上按已绑定泛型取字段」
