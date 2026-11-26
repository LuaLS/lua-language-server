# tree-sitter 预研记录

> 状态：**已暂停**（2026-08-10 决定暂时搁置，本文档保留完整调研结论，供后续重启时参考）
>
> 目标：预研用 [tree-sitter](https://tree-sitter.github.io/) 替代 luals 的**分词（lexer）+ 语法解析（parser）**部分，语义层（coder / tracer / narrowing / node 系统）仍由 luals 实现。

---

## 一、当前架构盘点（代码事实）

```
源码
 ├─ script/parser/lexer.lua      lpeglabel 分词（Word/Num/Symbol/NL/Unknown）
 ├─ script/parser/compile.lua    手写递归下降解析 → LuaParser.Ast
 │    ├─ 后处理：resolveAllGoto()、checkAssignConst()
 │    └─ LuaCats：注释内类型语法，独立子解析器（status 在 Lua/Cats/InLineCats/LuaInCats 间切换）
 └─ script/vm/coder/coder.lua    makeFromAst 遍历 ast.main → 生成 middle code + flow 元数据
      └─ script/vm/coder/tracer.lua / node 系统 → narrowing / 语义值
```

几个决定性的结构事实：

1. **AST 是强类型的富节点**（`script/parser/ast/base.lua`）：每个节点除了字节偏移，还携带 `parentBlock` / `parentFunction` / `referBlock` / `referFunction` / `uniqueKey` / `effectStart`、字面量转换缓存（`asNumber` / `asString`）、`dummy` / `optional` 等派生元数据。coder 按 `kind` 把节点分派到不同的 provider。
2. **LuaCats 是注释内的第二门语言**（`script/parser/ast/cats/cat.lua`，`catParserMap` 注册 class/type/alias/overload…）：tree-sitter 只会把它们当普通注释。
3. **非标准符号**（LuaJIT 扩展 + luals 扩展：`//` `&&` `||` `!=`、复合赋值、反引号、`::`）和多 Lua 版本（5.1–5.4/JIT、envMode）都由自家 lexer/parser 支持。
4. **解析目前是整文件重跑**：`script/scope/document.lua` 的 `ast` getter 用 `astPool` 缓存结果但每次改动全量 `parser.compile`；且 **coder worker 里又独立 parse 了一次**（`coder-worker.lua`），产物以纯数据（middle code 字符串 + map）跨 worker 通道回传。
5. **server 侧没有 semantic tokens/高亮实现**（`script/lsp/spec.lua` 里只有协议类型定义）——高亮在客户端。

## 二、tree-sitter 能力概览

- **增量解析框架**：运行时库 + 文法 DSL（`grammar.js` → `tree-sitter generate` → C 解析器）。
- **产出 CST（具体语法树）而非 AST**：完全无损，注释/空白/标点全部保留；节点带精确字节范围。
- **增量解析原理**：编辑只标记受影响区域为 dirty，局部重解析，未变化子树按"字节范围 + 身份"复用。
- **内置错误恢复**：半成品代码产出 `ERROR` / `MISSING` 节点，编辑器场景友好。
- **查询系统**（`ts_query`）：支持高亮/折叠/结构搜索等。
- **本质边界**：只做语法层，不做类型推断、作用域、符号表、跨文件语义。

| 能力 | 对 luals 的价值 |
|---|---|
| 增量解析（编辑局部重解析 + 子树复用） | 大文件高频 `didChange` 下省解析时间 |
| 健壮的错误恢复，产出完整 CST | 半成品代码的结构遍历 |
| 保留全部 token 的 CST + query 系统 | 高亮/折叠/缩进/结构选择/结构搜索 |
| 社区维护 grammar | 少写文法（但见下文反例） |

## 三、社区 Lua grammar 覆盖情况

主流 grammar 已迁移维护至 **`tree-sitter-grammars/tree-sitter-lua`**（原 `MunifTanjim/tree-sitter-lua`），目标 **"Lua 5.x + LuaJIT 2.x"**。

**标准 Lua 5.x 基本全覆盖：**

- 语句：`;`、赋值、函数调用、`::label::`、`break`、`goto`、`do/while/repeat/if/for`、`function`/`local function`/`local`/`return`。
- 表达式：完整优先级表（`or/and` < 比较 < 位运算 < `..` < 加减 < 乘除整除 < 一元 < 幂），含 Lua 5.3+ 全部运算符；4 个 supertypes（`statement`/`expression`/`declaration`/`variable`），带完整 field 名，查询友好。
- 字面量：十进制/十六进制/科学计数法、LuaJIT 后缀（`U?LL`、`i/I` 虚数）、完整字符串转义（`\xNN`/`\u{...}`/`\z`/十进制/`\0`）、`[[...]]` 长字符串（嵌套，external scanner 计数）。
- 注释：`--` 行注释、`--[[ ]]` 块注释（**支持嵌套**）；`#!` shebang。
- 表构造器三种字段 + `,`/`;` 分隔符（含尾随分隔符）；方法调用 `:`、`.`/`[]` 索引。
- 附带 `highlights.scm` / `injections.scm` / `locals.scm` / `tags.scm`。

## 四、与 luals 的差距（预研关键）

**标准 Lua 5.x 覆盖率没问题，但 luals 需要的自定义扩展基本全部缺失：**

| luals 需求 | 社区 grammar | 影响 |
|---|---|---|
| **LuaCats 类型注解**（`---@class/@type/@alias/@overload`、`---@param`、泛型、`--[[@@@]]` 等） | 全部被当作普通 `comment` | 类型系统完全不在语法层，必须自己再解析注释 |
| 复合赋值 `+= -= *= /= //= %= &= |= ^=` | ❌ 无 | luals 非标准扩展，需 fork |
| `&&`、`||`、`!=`（`and/or/~=` 别名） | ❌ 无 | 同上 |
| `/* */` 块注释、反引号字符串 | ❌ 无 | 同上 |
| `continue` 关键字 | ❌ 无（标准 Lua 没有） | 同上 |
| Unicode 标识符（`unicodeName` 选项） | ❌ 无（标准 ASCII 标识符） | 需改 grammar |
| 多 Lua 版本模式（5.1–5.4/JIT、`envMode`） | 单一 grammar，无版本开关 | 语义差异只能靠后处理 |
| 精确错误节点 / 错误恢复形态 | 有 `ERROR`/`MISSING`，但形态与 luals 的 `Node.Error` 不同 | 需要适配 |

**直接影响：**

1. **"免费维护"只覆盖标准 Lua**——luals 需要的那一列全部要 fork grammar 自己维护。替换成本的核心不在"能不能解析 Lua"，而在"你的 Lua 不是社区那个 Lua"。
2. **LuaCats 是最大的洞**：community grammar 对 `---@type` 这类语法零认知。即便只是做"分词+语法替换"，Cats 部分仍要保留 luals 自己的注释子解析器，等于替换只完成了一半。
3. **非标准符号差距是硬性的**：`+=`、`&&`、`continue` 等会导致整段解析成 `ERROR` 节点或误解析，无法靠后处理"智能修正"。

## 五、关键障碍

### 1. 语义层对"富 AST"强耦合 —— 最大的坎

coder 按 `kind` 分派、遍历 typed node 生成 middle code；tracer 依赖节点的流敏感信息。tree-sitter 给的是**通用字符串类型节点**的 CST，两者之间没有免费通道：

- **路径 A：CST → luals AST 转换器**，下游全部不动。
  - 优点：语义层零改动。
  - 缺点：这个转换器要重建 `parentBlock`/`referFunction`/`uniqueKey`/字面量缓存等全部不变量，**等于重写半个 parser**；且转换器必须重建整棵 typed AST，**增量解析的收益被转换环节吞掉大半**。
- **路径 B：coder/tracer 直接消费 CST**。
  - 优点：增量收益最大化。
  - 缺点：要重写 coder + tracer + narrowing，等于重写整个语义前端，风险和周期不可接受。

### 2. LuaCats / 非标准符号 / 多版本 = 必须 fork grammar

社区 grammar 不覆盖 luals 的类型注解语法和非标准符号。要替换就得 fork 一份自定义 grammar 并持续维护——"社区免费维护"这一项就没了，且类型系统语法还在快速演进（LuaCats 的 class/alias/overload/generic 都是活跃开发中）。

### 3. 原生依赖与 worker 边界

- tree-sitter 是 C 库。嵌入方式有先例（`3rd/lpeglabel` 就是编译进 bee 运行时的 C 解析器），但每个平台都要构建绑定。
- **tree-sitter tree 是 C 指针对象，无法跨 worker 通道**（AGENTS.md 明确要求通道只传纯数据）。现在 coder worker 内独立 parse，替换后 tree 必须留在 worker 内完成 CST→AST 再回传，或把整条 coder 链路留在 worker——架构改动不小。

### 4. 增量收益被下游稀释（最重要的一点）

增量解析只省"重新解析"时间。而 luals 每次改动还要**全量重跑 coder 生成 middle code → tracer 语义分析**。即便 parse 从 10ms 降到 1ms，只要 coder+tracer 还是全量，总耗时几乎不变。**真正的热点在下游，而 tree-sitter 恰恰帮不上下游的忙。**

## 六、动态规则（配置感知符号）的可行方案

luals 的"配置感知符号"散落在多个 parser 文件（都查 `nssymbolMap`）：

- `script/parser/ast/comment.lua`：`//` 是否当注释（`parseShortComment`）、`/**/` 块注释
- `script/parser/ast/binary.lua`：`//` 是否当整除、`&&`/`||` 等别名运算符
- `script/parser/ast/unary.lua`：`~` 等非标准一元运算符
- `script/parser/ast/string.lua`：反引号字符串
- `script/parser/ast/state/break.lua`：`continue` 关键字

以 `//` 为例的 luals 消歧机制（**"贪心优先 + 上下文感知"**）：

1. **注释层**（`parseShortComment`）：语句间隙（`inExp == false`）一律当注释；表达式内（`inExp == true`）仅当配置声明 `nssymbolMap['//']` 时才当注释。
2. **二元运算层**（`binary.lua`）：运算符位置直接拒绝把 `//` 当整除符，把消费权留给注释逻辑。

tree-sitter **没有"运行期参数化 grammar"这种一等 API**（`grammar.js` 只在生成期执行一次）。三个可行出口，按推荐程度排序：

### 方案 A：external scanner（官方机制，推荐）

`scan()` 每次收到 `valid_symbols[]`（当前 parse 状态愿意接受的 token），scanner 据此对同一串字符做不同切分。

**难点**：`comment` 通常是 `extra` token（任意位置合法），`SLASH_SLASH` 只在表达式内合法，很多状态下 `valid_symbols` 里**两个符号同时被接受**，scanner 无法仅凭它区分"语句间隙"和"运算符位置"。因此 scanner 需**自己维护上下文状态**（跟踪最近的非 extra token / 括号深度）——跟 luals 的 `inExp` 标志本质是**同一个问题、同样的复杂度**。配置开关放进 scanner 的 **payload（宿主创建，per-parser 实例）**，提供 C setter 在 parse 前设置。

**注意**："把 `//` 当注释"没法靠"grammar 全收 + 后处理解释"绕过——注释模式会把整行剩余内容都吞掉，CST 完全不同，后处理修不回来。

### 方案 B：生成期多变体（两个 `TSLanguage`）

`grammar.js` 里用生成期常量/环境变量切换规则，生成两份 `parser.c`，运行时按配置加载不同 Language。

- 优点：完全受支持、无 hack、文法层面干净。
- 缺点：二进制翻倍、两份 grammar 持续同步维护、**增量解析树不能跨变体复用**（语义变了必须全量重解析）。

### 方案 C：scanner 全局开关（不推荐）

`scanner.c` 里 `static bool` + setter。luals 是多 worker 多线程架构，全局变量跨线程串扰风险大；真要这么做应改为 per-parser 的 payload 字段，即退化回方案 A。

### 增量解析与动态配置的关系（关键约束）

- 不同配置的文件 → 用**不同的 parser 实例**（各自独立的 scanner 状态），互不影响，增量复用各自成立；✓
- 同一文件编辑过程中配置几乎不会变 → 增量复用不受影响；✓
- 唯一需要重建树的场景是"同一文件配置中途改变"（改配置后重载），一次全量重解析即可，可接受。✓

**结论**：这类"参数决定规则"的需求统一按**方案 A**建模（唯一不牺牲增量复用的动态决策机制）；只有当配置导致**语法结构层面**的大规模差异时才考虑方案 B。

## 七、总体结论

> **"替换"（replacement）性价比很低；"互补"（complementary）才是合理定位。**

- 把 lexer+parser 整段换成 tree-sitter：技术上可行（有 lpeglabel 嵌入先例），但要为它付出 fork grammar、重写转换层/语义前端、平台构建的代价，而**吃掉增量红利的路径（B）风险过高，保守路径（A）又抵消了增量收益**。语义层与富 AST 的强耦合是决定性阻碍。
- tree-sitter 真正高价值的位置是**前端侧**：语法高亮、折叠、缩进、结构选择、结构搜索，或未来做 semantic tokens / 内嵌编辑器的场景——这些 server 现在都还没做，反而是更值得先落地的增量方向。
- 如果目标是"减少每次编辑的解析开销"，更务实的路线是**给现有 parser 做定点增量**：`didChange` 里做增量分词 + 局部子树重解析，并缓存 lexer 结果。收益接近 tree-sitter 方案，风险小一个数量级。

## 八、若重启预研的 spike plan

1. **量化瓶颈**：在 `document.lua` 的 `ast` getter 和 `coder-worker.lua` 里加计时，统计典型大文件的 parse / coder / tracer 耗时占比。如果 parse 占比 < 20%，基本可以直接下"不值得替换"的结论。
2. **差距盘点**：拿 `test/parser/` 全部用例跑一遍 tree-sitter-lua grammar，统计覆盖率和失败点，重点看 Cats 语法与非标准符号的差距。
3. **微型原型**：只挑一个子集（如表达式/语句）写 CST → typed AST 转换器，实测转换成本与信息丢失，验证路径 A 的真实工作量。
4. **收益模拟**：即便 parse 增量，估算"parse 节省 / coder+tracer 全量"后的实际总耗时变化，验证第 5.4 节的判断。

## 附录：相关代码位置

| 关注点 | 位置 |
|---|---|
| 分词 | `script/parser/lexer.lua` |
| 手写递归下降解析 | `script/parser/compile.lua`、`script/parser/ast/` |
| AST 富节点 | `script/parser/ast/base.lua` |
| LuaCats（注释内类型语法） | `script/parser/ast/cats/` |
| 配置感知符号（`nssymbolMap`） | `comment.lua`、`binary.lua`、`unary.lua`、`string.lua`、`state/break.lua` |
| AST 缓存/全量重跑 | `script/scope/document.lua` |
| coder worker 二次 parse | `coder-worker.lua`、`script/vm/coder/` |
| 语义分析 | `script/vm/coder/tracer.lua`、`script/node/` |
