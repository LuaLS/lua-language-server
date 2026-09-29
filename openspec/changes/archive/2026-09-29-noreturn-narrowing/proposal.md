# Proposal

## Why

分支以「永不正常返回的调用」结尾时（`if not i then decode_error(...) end`），
本仓库只把 `return` / `goto` / `break` / `continue` 当分支终止
（`script/parser/ast/block.lua:191-205` → `script/vm/coder/block.lua:87-90`
→ `script/node/tracer.lua:579,620-634`），于是该分支的 `nil` 仍参与 `if` 之后的收窄合并：
守卫之后的 `i` 停在 `integer | nil`。

目标工程 `script/json-edit.lua` 因此报一条假 `return-type-mismatch`（`:405`）：
`---@return {s: integer, d: integer, f: integer, v: any}` 与实参
`{d: <integer 链>, v: any, ...}`「不匹配」。实测失败字段是 `f`：

```
[castDebug] key=f act=1 | op.add<...> | ... | nil exp=integer
```

即 `ast.f = statusPos`（`:338`）读到的是被污染成 `integer | nil` 的 `statusPos`，
而按 Lua 语义 `decode_error` 永不正常返回（`:103` 直接 `error(...)`），
守卫后的 `statusPos = i` 只可能是 `integer` ⇒ 该注解本身没错，是本仓库漏了这条语义。

## What Changes

- 新增 LuaCats `---@noreturn`：标注「此函数永不正常返回（总是抛错 / 走 `error`）」，
  可与 `---@return` 一样作为状态注解贴在函数定义上。
- 函数级推断：函数体最后一条语句是对 `noreturn` 函数的调用时，该函数自身也是 `noreturn`
  （目标工程的 `decode_error` 是这种未注解包装，必须靠推断才生效）。
- 收窄：`if <cond> then <以 noreturn 调用结尾> end` 之后的分支不再参与合并
  （与 `return` 结尾同语义），守卫后的非 nil 收窄得以成立。
- 内建声明：meta 里 `error` 标为 `noreturn`（`meta/template/basic.lua`、`meta/whimsical/basic.lua`）。

不做（另开条目，见下）：诊断消息 / 视图里因 `checkSkip` 位置环把字段显示成 `{d: ..., v: any, ...}`
的可读性问题（`script/node/table.lua:727-746,811-813`）——它与本 change 的收窄语义无关，
本轮只记进事实台账，不顺手改视图（改视图会牵动大量 view 断言，需单独一轮）。

## 基线（改前 → 改后）

- 目标工程 `d:\github\vscode-lua\server`：**216 → 199（移除 17 / 新增 0）**（已达成）
  （基线文件 `tmp/scan-noreturn-base.txt`，比对输出 `tmp/cmp-01.txt`）
- 落入这一族的实例：`json-edit.lua:249/257/265/322`（`param-type-mismatch`）、
  `json-edit.lua:405`（`return-type-mismatch`）、`json.lua:427/435/443/494`、
  `jsonc.lua:231/239/247/302`（预估 12 条）+ `parser/lines.lua:17`、`proto/converter.lua:108`、
  `text-merger.lua:34/53`、`parser/compile.lua:3368`（2 条）、`tools/lua51.lua:170/204/205/206`
  （这 5 处是本轮实测多出来的同族）。
- 基线里消息含 `op.add<` 的 66 条中是另一族（算术链里嵌 `integer | nil`/模板，未消），
  本轮不动。

## 语义依据

- Lua 运行时：`error()` 不返回；`if not x then f() end`，若 `f` 永不返回，则之后 `x` 非 nil。
- 本仓库既有同族证据：`assert(i)` 之后不报（`assert` 失败即抛，本仓库已按真值收窄处理），
  而 `if not i then error("no") end` 之后报 —— 两者差别只在「调用是否终止分支」。
- 目标工程写法自证：`decode_error(msg)` 本体为 `error(string_format(...), 2)`（`json-edit.lua:103-105`），
  所有调用点都写在 `if <不合法输入> then` 之后，语义上就是「抛出结束」。

## 试过但未采用

- **写站点因素**：把字段写成「字面量表里带 `s`/`d`」 vs 「逐条 `ast.s = ...` 赋值」→ 都报；
  去掉调用实参（`decode_map[chr]()`）→ 仍报。⇒ 与写站点、实参反推无关。
- **算术模板不可转 `integer`**：`local n = 0; n = n + 1; return {x = n}` 一类简单链
  （`tmp/repro-rtm-json/rtm4.lua`）→ **不报**。⇒ 不是模板类型本身的问题，别去改 `op.add` 的 `canCast`。
- **合并丢字段**：插桩 `Node.Table:addChilds` 打印合并键集 = `{d,s,v,f}` 齐全
  ⇒ 字段没被 `mergeTables` 丢掉；失败在 `f` 的**值**带 `nil`。别去改 `mergeTables`。
- **视图上的 `...`**：是 `checkSkip` 因 `field.location` 环跳过字段（`script/node/table.lua:727-746,811-813`），
  与语义无关——但把真实失败字段藏住了，故本 change 一并处理。
- **目标侧绕行**：给 `statusPos` 相关读点加 `--[[@as integer]]` / `---@diagnostic disable`：
  是拿注解迎合实现，不采用（本轮只允许正当修注解/修代码）。
- **`Node.FCall` 值位置给 `never`**（原计划 D3）：实测 216 → 199 **不变**（移除 0 / 新增 0），
  诊断耗时 9.74s → 10.12s（+3.9%，`value` 是热路径）⇒ 回退，spec 里对应场景删除。
- **复用 meta 里既有的 `---@throw`**：`meta/whimsical/basic.lua` 已写在 `error` 上，但本仓库没有任何
  `throw` 实现，且它的 DSL 形式 `---@throw => args[1].isFalsy`（`assert`）带条件语义，
  直接当 noreturn 会把 `assert(v)` 之后的代码误判为不可达 ⇒ 只做无参 `---@noreturn`。
- **前两次同方向尝试**（见台账 `narrowing.md` F15）：`---@return never`（0/0）与
  语句级 `never`（278 → 281 净变差，已回退）——本轮的关键差异是「只认分支**末位**那条调用 +
  要求目标**全部** noreturn + 支持未注解包装的推断」。

## Capabilities

### New Capabilities

- `noreturn`: `---@noreturn` 注解与「永不正常返回」的识别/推断语义
  （注解形式、函数级推断、对调用点与收窄的影响）。

### Modified Capabilities

- `narrowing`: 新增一条要求——`if` 分支以「永不正常返回的调用」结尾时，
  该分支的流 SHALL NOT 参与 `if` 之后的收窄合并（与 `return`/`exit` 结尾同待遇）。

## Impact

- LuaCats：`script/parser/ast/cats/cat.lua`（注册 `noreturn` 解析入口）、
  `script/parser/ast/cats/function.lua`（函数定义上的注解挂载）。
- Node：`script/node/function.lua`（`noreturn` 标记 + 调用点语义）。
- Coder / tracer：`script/vm/coder/cat.lua`、`script/vm/coder/function.lua`（发射标记）、
  `script/node/tracer.lua`（`traceIfChild` / 分支终止判定）。
- meta：`meta/template/basic.lua`、`meta/whimsical/basic.lua`（`error`）。
- 测试：`test/feature/diagnostic/return-type-mismatch.lua`（或新增 `noreturn` 用例文件）、
  `test/node/tracer.lua`；目标工程诊断基线 `216 → 204`。
- 不在本 change：`checkSkip` 视图字段隐藏（只记台账）。
