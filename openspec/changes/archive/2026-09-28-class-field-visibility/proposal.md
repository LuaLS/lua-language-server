# Proposal

## Why

目标工程 `script/plugins/ffi/init.lua` 的 `self.globalAsts`（88 行）与 `b.globalAsts`（348 行）
被报「未定义字段」，同时 `---@class` 目标上的赋值检查把「由另一次绑定字面量推断出来的字段」
当成必填（85 / 340 行）。

两处同源：`---@class X` 的字段集是「同名多次声明 + 各自绑定的值」拼出来的，
而我们把「绑定值推断出的字段」在**读取**与**赋值要求**两侧当成同一个东西 ——
读取侧要求它可见（当前：经调用返回的字面量看不见），赋值侧要求它必须齐全（当前：要求了）。

## What Changes

- `Node.Variable.fields`：赋值是**调用**（`setmetatable({...})` 一类，含包着一层 `select`）时，
  其返回的表也计入该变量的字段来源 ⇒ `---@class X` + `local x = setmetatable({ field = ... })`
  的字面量字段进入类，方法里读 `self.field` / 外部读 `x.field` 不再误报未定义字段。
- `assign-type-mismatch` provider：赋值目标是 `---@class` 标注（`variable.classes` 非空）时，
  比对只按 `---@field` 声明 + 继承来的字段，**不要求**由绑定值推断出来的字段
  （对齐目标工程 `assign-type-mismatch` 里 `hasMarkClass` 的例外）。
- 最小复现/控制文件落库：`test/project/repro/class-table-fields.lua`、
  `class-setmetatable.lua`、`setmetatable-fields.lua`；另落 `ipairs-narrow-field.lua`
  记录本轮未解决的另一族（循环变量退回列表值）。
- 回归钉：`test/feature/diagnostic/undefined-field.lua`（类第二次绑定经 `setmetatable`，不报）、
  `test/feature/diagnostic/assign-type-mismatch.lua`（`---@class` 多次绑定不报；非表值仍要报）。

## Capabilities

### New Capabilities

- `class-fields`: `---@class` 绑定值推断出的字段，在「读取可见性」与「赋值要求」两侧的边界。

### Modified Capabilities

（无）

## Impact

- 代码：`script/node/variable.lua`（`Variable.fields`）、
  `script/feature/diagnostic/providers/assign-type-mismatch.lua`。
- 目标工程诊断基线：**274 → 270（移除 4 / 新增 0）**。
  移除：`plugins/ffi/init.lua` 的 2 条 `undefined-field`（88 / 348）+ 3 条 `assign-type-mismatch`
  （85 / 340 / `parser/compile.lua:5084` 的 `local state = {...}` → `parser.state`）；
  其中 85 与 5084 是本轮改动**之前**就存在的同族误报。
- `--test` 全量绿；本仓库问题面板 0。

### 试过但未采用（实测数字）

1. `Variable.fields` 对**所有**赋值值（不限调用）沿 value 链找表：
   目标工程同样 270，但 `test/node/variable.lua:234`（`X.a = 1; local t = X` 断言 `t.fields == false`）
   挂 ⇒ 收窄到 `call` / `fcall` / `select`（变量值的字段本来就经变量自身的 value 可达）。
2. 在 `Type:onCanBeCast` 的类分支改用 `fieldTable + extendsTable`（改 cast 语义本体）：
   同时影响 `param-type-mismatch`（目标 144 条）等面，风险面太大 ⇒ 只在赋值诊断这一处改。
3. `hasAnyMember` 扩到 `intersection`（把 `setmetatable` 返回的 `T & (any | nil)` 直接放行）：
   只压掉 1 条，且语义上 `T & any` 应等于 `T`、不能当 `any` 用 ⇒ 未采用。
