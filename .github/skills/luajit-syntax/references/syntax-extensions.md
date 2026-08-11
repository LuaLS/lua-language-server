# LuaJIT 3.0 语法扩展参考文档

> 来源：[LuaJIT/LuaJIT#1475](https://github.com/LuaJIT/LuaJIT/issues/1475) MikePall 的第一条评论（权威文档），及 [LuaJIT/LuaJIT#1476](https://github.com/LuaJIT/LuaJIT/issues/1476) 反向移植说明。
> 反向移植到 v2.1 的扩展由官方测试覆盖：`test/parser_test/LuaJIT/`（来自 gist [a8372d92cb2e6380cf56e78f69ee70a4](https://gist.github.com/MikePall/a8372d92cb2e6380cf56e78f69ee70a4)）。

## 反向移植范围（v2.1 backport）

**已移植：**
1. 位运算：一元 `~`，二元 `& | ~ << >> ~>>`
2. 自定义运算符 `! && || !=`
3. 三元条件 `?:`（**本次实现已搁置**，见下文第 3 节）
4. 安全导航 `?.`（含方法形式 `:?`，全部实现）
5. 空值合并 `??`
6. 复合赋值 `+= -= *= …`
7. `continue` 语句
8. `const` 声明
9. 短函数表达式
10. 数字字面量下划线

**未移植（无需支持）：**
- 位运算元方法
- 地板除 `//`
- 复合赋值元方法 `__add(a, b, true)`
- 命名变参 `...name`

## 运算符优先级表（从高到低）

| 运算符 / 结构 | 元数 | 结合性 |
|--------------|------|--------|
| `( )` | 一元 | - |
| `->`（短函数） | 二元 | 右 |
| `.` `:` `[` `]` `f()` `?.` | 二元 | 左 |
| `^` | 二元 | 右 |
| `not` `!` `-` `~` `#` | 一元 | - |
| `*` `/` `//` `%` | 二元 | 左 |
| `+` `-` | 二元 | 左 |
| `..` | 二元 | 右 |
| `<<` `>>` `~>>` | 二元 | 左 |
| `&` | 二元 | 左 |
| `~` | 二元 | 左 |
| `\|` | 二元 | 左 |
| `==` `~=` `!=` `<` `>` `<=` `>=` | 二元 | 左 |
| `and` `&&` | 二元 | 左 |
| `or` `\|\|` `??` | 二元 | 左 |
| `?:` ⏸ | 三元 | 右 |
| `=` `compound=` | 二元 | - |

> 对应 `script/parser/compile.lua` 中 `BinarySymbol` 的数值等级（数值越大优先级越高）：
> - `??` 与 `or` 同级（1）
> - `?:` 已搁置（若未来实现：单独处理，优先级最低，在 `=` 之上）
> - `~>>` 与 `<<`/`>>` 同级（7）

## 各语法详解

### 1. 位运算 `~ & | ~ << >> ~>>`

| 运算符 | 功能 | 对应 bit.* 函数 |
|--------|------|-----------------|
| `~ a` | 按位取反 | `bit.bnot()` |
| `a & b` | 按位与 | `bit.band()` |
| `a \| b` | 按位或 | `bit.bor()` |
| `a ~ b` | 按位异或 | `bit.bxor()` |
| `a << b` | 左移 | `bit.lshift()` |
| `a >> b` | 逻辑右移 | `bit.rshift()` |
| `a ~>> b` | **算术右移** | `bit.arshift()` |

- `~>>`（算术右移）当前 **未实现**，是本规划要补的（tokenizer + `BinarySymbol`）。
- 测试：`expr_bit.lua`、`ffi_expr_bit*.lua`。注意测试中 `LL`/`ULL` 后缀仅 LuaJIT 支持（`dropNumberTail` 已处理）。

### 2. 自定义运算符 `! && || !=`

| 自定义写法 | 等价经典写法 | 功能 |
|-----------|--------------|------|
| `!` | `not` | 逻辑非 |
| `&&` | `and` | 短路与 |
| `\|\|` | `or` | 短路或 |
| `!=` | `~=` | 不相等比较 |

- 语义与经典运算符完全一致。
- compile.lua 已有 `UnaryAlias`（`!`）与 `BinaryAlias`（`&&`、`||`、`!=`）；`BinaryAlias` 带 `ERR_NONSTANDARD_SYMBOL` 检查。
- 测试：`expr_customary.lua`。

### 3. 三元条件 `?:`（研究完成，待实现）

```
a ? b : c
```
- `a` 为条件（真值判定同 `if`）；为真求 `b`，否则求 `c`。
- **右结合**，可嵌套：`cond1 ? a : cond2 ? b : x` = `cond1 ? a : (cond2 ? b : x)`。
- 短路：未选中的分支不求值。
- **语法歧义（源码确认）**：b 部分解析使用 `EXPR_F_NOCOLON` 标志（`lj_parse.c expr()`），在后缀解析中遇到 `:` 即 break，禁止方法调用；括号内方法调用需加括号：`cond ? (obj:method()) : default`。

**NOCOLON 传播/重置规则**（源码 `lj_parse.c` 依据）：
- 传播（eflags 透传）：一元操作数、二元操作数、后缀链（name/表/字符串后缀）
- 重置（传 0）：括号 `expr(v,0)`、索引 `expr_bracket→expr(v,0)`、函数参数 `parse_args→expr_list→expr(v,0)`、表值、lambda
- 推论：`a ? x + obj:method() : c` 也报错（操作数传播屏蔽）；`a ? f(obj:method()) : c` 合法（参数重置）

**compile.lua 实现方案**：
- `parseExp` 二元循环后处理三元（优先级最低、右结合）：b = `parseExp(nil, nil, true)`（noMethod），c = `parseExp()`
- 加 `noMethod` 参数：`parseExp(asAction, level, noMethod)`、`parseExpUnit(noMethod)`、`parseSimple(node, funcName, noMethod)`
- `parseSimple` 的 `:` 分支：`if noMethod then break`
- 重置点：parseParen / parseIndex / parseExpList / parseTable 值 / parseLambda
- tokenizer 无需改动（`?` `:` 均为单字符 token）
- AST：`ternary` 节点（`[1]`=条件、`[2]`=b、`[3]`=c），需 guide + vm 类型推断
- 测试：expr_cond.lua 移入正式测试

**测试要点**（expr_cond.lua）：
- `a ? obj:method() : c` → 报错 eof；`a ? (a:b()) : c` → 合法
- `a ? a : b():c() + 30` → 合法（c 部分不屏蔽）
- 无空格 `a?b:c` → 报错（方法调用歧义）；`a ? : c`、`a ? b :` → 报错

### 4. 安全导航 `?.`

| 原表达式 | 安全导航写法 | 检查对象 |
|----------|--------------|----------|
| `a[key]` | `a?.[key]` | a |
| `a.field` | `a?.field` | a |
| `a[key] = expr` | `a?.[key] = expr` | a |
| `a.field = expr` | `a?.field = expr` | a |
| `f(…)` | `f?.(…)` | f |
| `f"…"` | `f?."…"` | f |
| `f{…}` | `f?.{…}` | f |
| `obj:method(…)` | `obj?.:method(…)` | obj |
| `obj:method(…)` | `obj:method?.(…)` | method |
| `obj:method(…)` | `obj?.:method?.(…)` | 两者 |

- 规则：`.` 可直接替换为 `?.`；调用类（`()`, `""`, `{}`）与 `:` 需要 `?.` 和原符号**同时出现**。
- 左结合，可链式：`a?.b?.[c]?.d?.:e?.()`（五种检查全部支持）。
- 短路：左侧为 nil（或 NULL cdata）时，右侧操作与后续链不执行；赋值时右侧表达式也不求值。
- 本规划实现 `?.` 的**全部形式**：`.`/`[]`/`()`/`""`/`{}`、赋值形式、以及 `:?` 方法形式（`obj?.:method`、`obj:method?.`、`obj?.:method?.`）。
- 实现提示：`parseSimple` 中需区分 token 序列 `?.`+`:`（obj?.:method）与 `:`+`?.`（obj:method?.），前者检查 obj，后者检查 method。
- 测试：`expr_nav.lua`（全部用例应通过）。

### 5. 空值合并 `??`

```
a ?? b
```
- 仅当 `a` 等于 nil 时求 `b` 并返回，否则返回 `a`（`a` 只求值一次）。
- 与 `or` 同级优先级（`or || ??`），短路。
- 测试：`expr_coal.lua`。

### 6. 复合赋值

| 运算符 | 功能 | 长形式 |
|--------|------|--------|
| `a += b` | 加 | `a = a + b` |
| `a -= b` | 减 | `a = a - b` |
| `a *= b` | 乘 | `a = a * b` |
| `a /= b` | 除 | `a = a / b` |
| `a %= b` | 取模 | `a = a % b` |
| `a &= b` | 按位与 | `a = a & b` |
| `a \|= b` | 按位或 | `a = a \| b` |
| `a ~= b` | 按位异或 | `a = a ~ b` |
| `a <<= b` | 左移 | `a = a << b` |
| `a >>= b` | 逻辑右移 | `a = a >> b` |
| `a ~>>= b` | **算术右移** | `a = a ~>> b` |
| `a ..= b` | **连接** | `a = a .. b` |

- 索引表达式只求值一次前缀：`x.y.z.field += b` ≈ `local tmp = x.y.z; tmp.field = tmp.field + b`。
- **不支持**并行赋值：`x, y, z += u, v, w` 为语法错误。
- **没有** `^=`（故意省略，避免与异或混淆）。
- 可与安全导航组合：`a?.field += f()`。
- 现状：`+= -= *= /= %= &= |= <<= >>=` 已支持；需新增 `..=` 与 `~>>=`。
- 测试：`stmt_compound.lua`。

### 7. `continue` 语句

- 跳转语义：`while`/`repeat` → 循环条件；`for` → 循环更新逻辑。
- 只能作为（嵌套）块的最后一个语句（同 `break`）。
- **soft keyword**：可作变量名/字段名/函数名/参数名。
- `repeat` 中不能跳入其后声明的局部变量作用域（同 `goto` 规则）：
  `repeat if x then continue end; local a = a; until not a` → 报错。
- 现状：`parseAction` 已支持（`nonstandardSymbol['continue']` → `parseBreak()`），但语义是当作 break 处理，需要确认 `repeat`/`for` 的跳转目标正确性。
- 测试：`stmt_continue.lua`。

### 8. `const` 声明

```
const x = 1
const y, z = 2, 3
const foo                 -- 无赋值，值为 nil，但不可再赋值
const function foo() end  -- const 局部函数
```
- 块级局部常量：不可重新赋值、不可在相同或内层作用域重复声明、不可作为函数参数重复声明。
- **soft keyword**：可作变量名、字段名、函数名、参数名（`local const = 1` 合法；`const const = 1` 也合法——第一个是关键字，第二个是名字）。
- 变量本身不可变，但引用对象（如 table）内容可变。
- 需新增 `parseAction` 支持；错误码参考测试中的 `assign to const` / `declare const`。
- 测试：`stmt_const.lua`。

### 9. 短函数表达式

```
|…| -> expr          -- 返回 expr 结果
|…| -> do … end      -- 语句块，无 return 则返回 0 个结果
x -> x+1             -- 单参数可省略管道
|| -> true           -- 无参数
|a, b, ...| -> ...   -- 支持变参
```
- 可在任何函数表达式位置使用。
- expr 变体只返回**单个**结果（多返回用语句块形式）。
- `->` 优先级最高（仅低于 `()`），右结合。
- 现状：`|x| -> expr` 已有（`|lambda|`），但 `->` 无独立 token；需补 `x -> expr`、`|| -> expr`、`-> do … end`。
- 测试：`expr_shortfunc.lua`。

### 10. 数字字面量下划线

```
1_234_567_890
0x1_2     0b1_0
1_2.3_4   1e1_0
0x1_2p_3
```
- 下划线在**任何位置**（初始数字之后）都被忽略，适用于所有进制、所有后缀（含 `LL`/`ULL`）、整数与浮点。
- `tonumber()` 与字符串隐式转换**不接受**下划线。
- 需修改 tokenizer 的 `Number` 规则与 `parseNumber10/16/2`。
- 测试：`number_underscore.lua`。

## 测试文件对照表

| 文件 | 覆盖语法 |
|------|----------|
| `expr_bit.lua` | 位运算（`~ & \| << >> ~>>`） |
| `expr_bit_bitop.lua` | `bit.*` 库运行时行为（语法层面价值低） |
| `expr_coal.lua` | `??` 空值合并 |
| `expr_cond.lua` ⏸ | `?:` 三元条件（已搁置，本阶段不要求通过） |
| `expr_customary.lua` | `! && \|\| !=` |
| `expr_nav.lua` | `?.` 安全导航（全部形式，含 `:?` 方法形式） |
| `expr_shortfunc.lua` | 短函数 `->` |
| `ffi_expr_bit.lua` / `_bit64` / `_bitop` | FFI 位运算 + `LL`/`ULL` 后缀 |
| `number_underscore.lua` | 数字下划线 |
| `stmt_compound.lua` | 复合赋值 |
| `stmt_const.lua` | `const` 声明 |
| `stmt_continue.lua` | `continue` 语句 |

> 补充：`expr_cond.lua`（三元 `?:`）已搁置，本阶段不要求通过。
> 所有文件内容现已被包裹为 `return [[ … ]]` 字符串形式，可作为代码字符串测试源。
