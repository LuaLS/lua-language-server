---
name: luajit-syntax
description: 'LuaJIT 3.0 扩展语法支持的实施规划与实现指南。Use when implementing LuaJIT extension syntax support (bitwise ~>>, ternary ?:, safe navigation ?., nil-coalescing ??, customary operators ! && || !=, compound assignment, continue, const declaration, short function expression, number underscores) in the Lua language server, when modifying script/parser/compile.lua, script/parser/tokens.lua, script/config/template.lua, script/files.lua, or adding tests under test/parser_test/LuaJIT/.'
---

# LuaJIT 扩展语法支持规划

## 实施进度

| 阶段 | 内容 | 状态 |
|------|------|------|
| 阶段 0 | 设置 `Lua.runtime.enableLuaJITExtensions`、options 传递、initState 判定（语法处单独判断） | ✅ 完成 |
| 阶段 1 | tokenizer 新增 `-> ?? ?. ~>> ~>>= ..=` | ✅ 完成 |
| 阶段 2 | 语法解析（`~>>`、复合赋值、数字下划线、`??`、`?.` 全形式、`const`、短函数、`continue` soft keyword、`a ~= b` 异或赋值） | ✅ 完成 |
| 阶段 3 | 语义层（`?.`→optional、`??` 类型合并、`~>>`→integer） | ✅ 完成 |
| 阶段 4 | 诊断文案 `PARSER_DECLARE_CONST`（6 语言） | ✅ 完成 |
| 阶段 5 | 正式测试接入 `test/parser_test/luajit_ext.lua` | ✅ 完成 |
| 阶段 6 | 三元 `?:`（noMethod/noTernary 机制、ternary AST 节点、vm 类型推断） | ✅ 完成 |

验证：
- 语法层 40 用例（`temp/tmp_test_luajit.lua`）、语义层 7 用例（`temp/test_luajit_semantic.lua`）通过
- 三元语法用例（`temp/tmp_test_ternary.lua`）、语义用例（`temp/test_ternary_semantic.lua`）通过
- `parser_test`（含 `luajit_ext`：**14 个官方测试文件全部编译通过**，含 expr_cond/expr_coal/expr_nav）、`type_inference`、`hover` 回归通过

实现中发现的现有问题及修复：
- LuaJIT 下 `<<`/`>>` 误报 `UNSUPPORT_SYMBOL`（已修复：LuaJIT 支持 `<<`/`>>`，`//` 仍不支持）
- `a ~= b` 在语句上下文应识别为异或复合赋值（已修复，与现有 `+=` 简化一致）
- `continue` 是 soft keyword，需按后续 token 判断（`continue = 2` 是变量赋值）
- `safe` 字段只在 `safe == true` 时设置，否则普通 AST 会多出 `safe = false`（ast 测试失败教训）

三元 `?:` 实现要点（源码依据 lj_parse.c）：
- 三元在 `expr()` 尾部（`expr_binop` 完整解析后）检查 `?`，**优先级最低、右结合**
- b 部分用 `EXPR_F_NOCOLON`（0x02）禁止方法调用：`a ? obj:method() : c` 报错，`a ? (obj:method()) : c` 合法
- NOCOLON 传播到一元/二元操作数与后缀链；**重置**于括号/索引/参数/表值/lambda
- **b 部分嵌套三元非法**（`a ? b ? c : d : e` 中 `d:e` 方法调用歧义，与 LuaJIT 一致）；右结合靠 **c 部分递归**（`a ? b : c ? d : e`）
- compile.lua：`parseExp(asAction, level, noMethod, noTernary)`；操作数位置 `noTernary=true`；`parseSimple` 的 `:` 分支 `noMethod` 时 break；`?.` 后紧跟 `:` 且 noMethod 时 break 不消费
- AST：`type='ternary'`，`[1]`=条件、`[2]`=b、`[3]`=c；guide childMap `['ternary'] = {1,2,3}`
- vm：`testCondition` 恒真→b、恒假→c、不确定→b|c 合并

## 概述

为 lua-language-server 增加 LuaJIT v3 反向移植到 v2.1 的扩展语法支持（对应 [LuaLS/lua-language-server#3434](https://github.com/LuaLS/lua-language-server/issues/3434)）。

## 背景与参考

| 主题 | 链接 |
|------|------|
| LuaLS 需求 issue | https://github.com/LuaLS/lua-language-server/issues/3434 |
| LuaJIT v3 语法总览（权威文档，见 MikePall 第一条评论） | https://github.com/LuaJIT/LuaJIT/issues/1475 |
| 反向移植到 v2.1 说明 | https://github.com/LuaJIT/LuaJIT/issues/1476 |
| 官方测试用例 gist | https://gist.github.com/MikePall/a8372d92cb2e6380cf56e78f69ee70a4 |
| 本地测试文件 | `test/parser_test/LuaJIT/`（已包裹为 `return [[...]]`） |
| 语法扩展详细文档 | `references/syntax-extensions.md` |

## 开关设计（新设置）

新增设置：**`Lua.runtime.enableLuaJITExtensions`**（`Boolean`，默认 `false`）

生效条件（**两者同时满足**才启用）：
1. `Lua.runtime.version == 'LuaJIT'`
2. `Lua.runtime.enableLuaJITExtensions == true`

传递链路：
```
用户配置
  → script/config/template.lua 注册设置
  → script/files.lua 构造 options：enableLuaJITExtensions = config.get(uri, 'Lua.runtime.enableLuaJITExtensions')
  → parser.compile(text, 'Lua', version, options)
  → script/parser/compile.lua initState 中判定：
      if version == 'LuaJIT' and options.enableLuaJITExtensions then
          state.luaJITExtensions = true
      end
```

要点：
- 启用后，相关 LuaJIT 语法**直接生效**，无需用户再去 `Lua.runtime.nonstandardSymbol` 手动勾选。
- 与 `nonstandardSymbol` 的关系：`continue`、`|lambda|`、`&&`、`||`、`!`、`!=`、复合赋值等原本由 `nonstandardSymbol` 控制；启用本开关时这些项自动视为开启。
- **单独启用（2026-08-13 完成）**：10 项 LuaJIT 扩展语法也已加入 `Lua.runtime.nonstandardSymbol` 枚举（`?.` `??` `?:` `~>>` `~>>=` `..=` `~=` `const` `->` `number_underscore`），可单独启用，**不要求** version == 'LuaJIT'。生效判定统一走 `compile.lua` 的 `isLuaJITExt(symbol)` helper（`State.luaJITExtensions or nonstandardSymbol[symbol]`）。
- `//`（注释）与反引号字符串 `` ` `` 属于 LuaLS 自身扩展，**不属于** LuaJIT 语法，保持由 `nonstandardSymbol` 独立控制。

## 支持范围速览

### ✅ 现有代码已支持（本次基本无需改动）
| 语法 | 现状 |
|------|------|
| 位运算 `~ & \| << >>` | LuaJIT 2.1 原生，compile 已支持 |
| 自定义运算符 `! && \|\| !=` | tokenizer 已有 token；compile 有 `UnaryAlias`/`BinaryAlias`，带 `ERR_NONSTANDARD_SYMBOL` 检查 |
| 复合赋值 `+= -= *= /= %= &= \|= <<= >>=` | `expectAssign` 已支持（需 `nonstandardSymbol`） |
| `continue` 语句 | `parseAction` 已支持（`nonstandardSymbol['continue']` → `parseBreak()`） |
| 短函数 `\|x\| -> expr` | `parseLambda` 已支持（`nonstandardSymbol['\|lambda\|']`），但 `->` 尚无独立 token |
| 数字后缀 `LL`/`ULL`/`I` | `dropNumberTail` 已支持（仅 LuaJIT） |

### ✅ 已实现（本次规划核心）
| # | 语法 | 涉及 | 状态 |
|---|------|------|------|
| 1 | `~>>` 算术右移 与 `~>>=` 复合赋值 | tokenizer + `BinarySymbol` + `expectAssign` | ✅ |
| 2 | `..=` 字符串连接复合赋值 | tokenizer + `expectAssign` | ✅ |
| 3 | `??` 空值合并 | tokenizer + `BinarySymbol` + 类型语义 | ✅ |
| 4 | `?.` 安全导航（属性/索引/调用/**方法形式 `:?`**） | tokenizer + `parseSimple` | ✅ |
| 5 | `const` 声明 | `parseAction` + 局部常量语义 | ✅ |
| 6 | 数字下划线 `1_000` | tokenizer `Number` + `parseNumber*` | ✅ |
| 7 | 短函数完整形式（`x -> expr`、`\|\| -> expr`、`-> do ... end`） | tokenizer `->` + `parseLambda` 扩展 | ✅ |
| 8 | **三元 `ternary`**（符号 `?:`，`cond ? x : y`，NOCOLON 屏蔽方法调用、右结合；**key 为 `ternary`，与无点号安全方法 `?:` 拆开**） | `parseExp` + `parseSimple` + guide + vm | ✅ |

### ⏸ 未反向移植到 v2.1（无需支持）
- `//` 地板除、命名变参 `...name`、位运算元方法、`__add(a, b, true)` 元方法。

## 实现步骤

### 阶段 0：基础设施
1. `script/config/template.lua`：注册 `Lua.runtime.enableLuaJITExtensions`。
2. `script/files.lua`：两处（`compileStateAsync` 与 `compileState`）构造 options 时传入。
3. `script/parser/compile.lua` `initState`：判定并设置 `state.luaJITExtensions`。
4. 各 `locale/*/setting.lua` 补充设置说明文案。

### 阶段 1：tokenizer（script/parser/tokens.lua）
新增 token（注意顺序，长 token 在前）：
- `->`（短函数箭头）
- `??`、`?.`（均需排在单字符 `?` 之前）
- `~>>`、`~>>=`（`~>>=` 排在 `~>>` 之前）
- `..=`（排在 `..` 之前）
- 说明：`?` 与 `:` 均为单字符 token（已存在），三元无需新 token。

### 阶段 2：compile.lua 语法解析
按依赖顺序（建议）：
1. **`~>>`**：`BinarySymbol` 加 `['~>>'] = 7`（与 `<<`/`>>` 同级）。
2. **复合赋值补全**：`expectAssign` 加 `..=`、`~>>=`。
3. **数字下划线**：`parseNumber10/16/2` 允许下划线；注意 `dropNumberTail` 需放行下划线。
4. **`??`**：`BinarySymbol` 加 `['??']`（与 `or` 同级），复用 `parseExp` 的二元循环；检查短路语义。
5. **`?.`**：`parseSimple` 中 `token == '.'` 分支旁新增 `token == '?.'` 分支；支持 `a?.field`、`a?.[key]`、`f?.()`、`f?."str"`、`f?.{...}`、`a?.field = v`、`a?.[key] = v`；**并支持 `:?` 方法形式**：
   - `obj?.:method(...)`（检查 obj）
   - `obj:method?.(...)`（检查 method）
   - `obj?.:method?.(...)`（两者都检查）
6. **`const`**：`parseAction` 中处理 soft keyword `const`；`const x = 1` 为块级局部常量，禁止重复声明/重新赋值；`const function foo() end` 一并考虑。
7. **短函数**：`parseExpUnit` 中识别 `->`；`parseLambda` 支持 `x -> expr`（单参数省略管道）、`|| -> expr`、`-> do ... end` 语句体。

### 阶段 3：AST 与语义层
- 新节点类型（建议在实现时定稿）：
  - `?.` → `getfield`/`getindex`/`call`/`getmethod` 的安全导航变体（可加标记字段，如 `safe = true`），语义层需处理 nullable 访问；`obj:method?.` 的检查目标是 method，`obj?.:method` 的检查目标是 obj。
  - `??` → 复用 `binary`（op = `??`）。
  - `const` → 复用 `local` 结构并打 const 标记，或新节点类型。
  - `?:` → `ternary` 节点：`[1]`=条件、`[2]`=b、`[3]`=c（guide childMap 已加 `['ternary'] = {1,2,3}`）。
- `script/parser/guide.lua`、`script/vm/*`：让类型推断/引用/悬停等理解新节点。
- 运算符优先级遵循 LuaJIT 官方表（见 references/syntax-extensions.md）。

### 阶段 4：诊断与文案
- 新错误码直接在 compile.lua 中 `type = 'XXX'` 定义（`script/proto/diagnostic.lua` 的 `getDiagAndErrNameMap` 会自动从源码提取注册）。
- 需要的新错误码示例：
  - `?.` 使用但未启用扩展 → 复用 `ERR_NONSTANDARD_SYMBOL` 或新增
  - `const` 重新赋值 / 重复声明 → 参考测试中的 `assign to const` / `declare const`（注意现已有 `SET_CONST`、`ASSIGN_CONST_GLOBAL`）
- 各 `locale/*/diagnostic.lua` 补充翻译。

### 阶段 5：测试
- `test/parser_test/LuaJIT/` 下的 14 个测试文件已包裹为 `return [[...]]`，可作为代码字符串测试源。
- 需接入现有 parser_test 框架（参考 `test/parser_test/ast/` 的结构），或用语法检查断言（`syntax_check.lua` 的 `TestWith` 模式）。
- 为开关状态各写测试：未启用时报错、启用后通过。

## 如何测试（实测方法）
- **直接运行**：`bin/lua-language-server.exe test.lua` —— `lua-language-server.exe` 可直接作为 Lua 运行时执行脚本。
- **限定测试范围**：`test.lua` 支持 `--name=<pattern>` 参数，`test(name)` 内部用 `name:match(TARGET_TEST_NAME)` 过滤，例如：
  - `bin/lua-language-server.exe test.lua --name=parser_test` 只跑 `parser_test`
- **自定义测试脚本**：可自行改造 `test.lua` 或编写独立脚本，直接 `bin/lua-language-server.exe <script>.lua` 运行（需正确设置 `package.path`，见 `test.lua` 开头）。
- **当前进度验证脚本**：`temp/tmp_test_luajit.lua`（临时，验证 compile 解析 LuaJIT 扩展语法，含开关开关两种状态的断言）。

## 关键文件地图

| 文件 | 职责 |
|------|------|
| `script/config/template.lua` | 注册 `Lua.runtime.enableLuaJITExtensions` |
| `script/files.lua` | 构造 compile options（两处） |
| `script/parser/tokens.lua` | 词法：新增 token |
| `script/parser/compile.lua` | 语法：`initState`/`parseExp`/`parseSimple`/`parseLambda`/`expectAssign`/`parseAction`/`parseNumber*`/`dropNumberTail` |
| `script/parser/guide.lua` | AST 辅助（行号、块、子节点遍历） |
| `script/vm/*` | 语义/类型推断 |
| `script/proto/diagnostic.lua` | 错误码注册（自动提取） |
| `locale/*/setting.lua`、`locale/*/diagnostic.lua` | 文案 |
| `test/parser_test/LuaJIT/` | LuaJIT 官方测试（已包裹） |

## 注意事项
- **优先级表**：所有新增运算符的优先级必须严格遵循 LuaJIT 官方定义（见 references/syntax-extensions.md「运算符优先级」）。
- **三元 `ternary` 已实现（2026-08-13 拆分）**：见 references/syntax-extensions.md 第 3 节；b 部分禁止方法调用（NOCOLON），需括号 `(obj:method())` 绕过；b 部分嵌套三元非法（`d:e` 歧义），c 部分右结合递归合法。**一个 key 只承载一个功能**：三元从 `?:` 拆出，改用 **`ternary`** key（`isLuaJITExt('ternary')`，主开关 enableLuaJITExtensions 也启用，因三元是 LuaJIT 官方语法）；`?:` 专用于无点号安全方法 `obj?:get()`（仅 `nonstandardSymbol['?:']` 门控，主开关不启用）。
- **`?.` 与 `:` 的歧义**：实现安全导航的方法形式时需小心区分 `obj?.:method`（`?.` + `:`）与 `obj:method?.`（`:` + `?.`），以及普通方法调用 `obj:method`，三者 token 序列不同，需在 `parseSimple` 中分别处理。
- **`?.` 已拆分为 3 项（2026-08-13）**：`?.`（字段/方法：`a?.b` / `obj?.:method` / `obj:method?.`）、`?.(`（安全调用：`f?.()` / `f?."str"` / `f?.{...}` / `f?.[[...]]`）、`?.[`（安全索引：`t?.[key]`）。parseSimple 在 `?.` 后按后缀选择启用项：`(`/`{`/引号→`?.('`；`[`→看 `Tokens[Index+5]` 是否为 `[`/`=`（长字符串调用 vs 索引）；其他→`?.`。主开关 enableLuaJITExtensions 仍一并启用全部。
- **无点号可选链 `?(` / `?[`（2026-08-13 新增，非 LuaJIT 语法）**：`f?()` / `t?[1]` 等价于 `f?.()` / `t?.[1]`，AST 一致（`call`/`getindex` 的 `safe=true`）。仅由 `nonstandardSymbol['?(']`/`['?[']` 单独启用，**与 LuaJIT 无关**（主开关 enableLuaJITExtensions 不启用，与版本无关）；与三元（`ternary`）解析冲突（`a ? (x) : c` 会被当作 `a?(x)`），template 注释与 locale 描述均有警告。
- **无点号安全方法 `obj?:get()`（2026-08-13，非 LuaJIT 语法）**：`?:` 选项只做无点号安全方法（`obj?:get()` = `obj?.:get()`），与三元拆开（三元用 `ternary`）。parseSimple 的 `?` 分支处理 `?`+`:`（需 `nonstandardSymbol['?:']` 且 `not noMethod`，三元 b 部分不消费）。合法三元 `a ? b : c` 的 `?` 后跟表达式不受影响（仅 `?`+`:` 相邻才走方法）。
- **soft keyword**：`const` 与 `continue` 都是 soft keyword，可作变量名/字段名/函数名，解析时必须先识别上下文。
- **短路语义**：`??`、`?.` 都有短路行为，虽然语法层不关心求值，但 AST 结构与类型推断需正确表达。
- **`continue` 与 `repeat`**：`continue` 跳转到循环条件；在 `repeat` 中不能跳入其后声明的局部变量作用域（测试 `stmt_continue.lua` 有覆盖）。
