# 事实台账：cast（`---@cast` 语句式 / `--[[@as T]]` 内联式）

格式同 `narrowing.md`：断言 / 证据 / 代码 / 状态。

## F1 内联 `--[[@as T]]` cast（作用于当次读取）
- 断言：`f(x--[[@as T]])` 的这次读取值是 `T`（覆盖推断），**且只作用于这一次读取**
  （后续读同一个变量仍是原值——语义是「表达式类型覆盖」，不是变量收窄）
- 证据：test/coder/inline-cast.lua（读值 = cast 类型 / 后续读取保持原类型 / 普通长注释不参与）；
  test/feature/diagnostic/param-type-mismatch.lua 末 4 例（cast 生效 + 对照组不带 cast 必报）；
  test/parser/ast/exp.lua（`a --[[@as integer]]`、`t[1] --[[@as string]]` 挂在该表达式上）
- 代码：
  - parser：`Ast:parseInlineCast`（`script/parser/ast/exp.lua`），在 `parseTerm` 的链循环里
    **`skipSpace` 之前**调用（`skipSpace` 会把注释吃掉）；类型写成 `exp.catAs`；
    注释照常登记进 `parsedComments`/`comments`/`delayComments`
  - coder：`T:appendRef` 见到 `source.catAs` 就在 ref 之后发一条 cast
    （`{'cast', id, nil, typeKey, nil, alias}`，alias = 该读取点的 uniqueKey）
  - walker：`W:traceCast` 带 alias 时**不写回收窄栈**，只把结果写回该读取点
- 已踩过的坑（改动时注意）：
  - `lexer:moveTo(x)` 之后的下一次取词从 `x + 1` 开始（注释末尾要传「最后一个字符的下标」，
    多传 1 会把后面的 `)` 吃掉 → `miss-symbol`）
  - 类型解析用 `moveTo` + `parseCatExp()`（`---@cast` 走 `parseCat` 的老路），要临时把
    `self.status` 切到 `'Cats'`
  - 测试里写 `--[[@as T]]` 的片段必须用 `[==[ ... ]==]` 长括号，否则 `]]` 会提前结束字符串
  - `coder.map` 是严格表：alias 只在 `coder.compiled[varSource]` 为真时记，
    `---@cast x T` 注解里的名字没有运行时节点，记了会 `No such key`
- 状态：成立（2026-09-22，随 `tonumber` 重载一起：目标工程 377 → 375，移除 2 / 新增 0）
- 已知未覆盖：`---@as T`（短注释内联式）与「作用于整个二元表达式」的写法（如 `a + b --[[@as T]]`
  会挂在 `b` 上）；目标工程里那 1 处 `---@as` 写在语句行首，语义不明，暂不处理
