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

## F2 内联 cast 挂在**索引读取**上时有效（含条件位置）

- 断言：`t[i]--[[@as T]]` 的这次读取值为 `T`；即使该调用出现在**条件位置**
  （`if matchKey(t[i]--[[@as T], x) then`，即 truthy 检测会做「实参反推」的那条路）也有效。
- 证据：`test/project/repro/inline-cast-index.lua`（三种形态 `return` / `if` / 无 cast 对照，0 诊断）
- 用途/结论：目标工程 `core/completion/completion.lua` 1166 / 1861 / 1884 用这种写法断言
  luadoc 构造节点的 `[1]`（`parser.object|any` 那层注解太宽）——**这是目标工程侧的正解**，
  不要当成我们的缺口去改引擎。
- 排查教训（省时间）：诊断的 **range（列）** 才是出问题的那一个实参 ——
  `completion.lua:1861` 的区间是第 2 个实参 `name`，不是第一个 `source[1]`；
  先看列再下结论（我第一次改错了一个实参，白跑两趟扫描）。
- 状态：成立（2026-09-27；目标工程 220 → 218，移除 2 / 新增 0）

## F3 `canCast` 的递归深度必须有上限（超限按 unknown 宽松放行）

- 断言：`Node:canCast` 的递归层数 SHALL 有上限；超限 SHALL 按「unknown（宽松 `true`）」返回
  （与 `castCache` 命中 `'unknown'` 同义），SHALL NOT 无限下探。
- 为什么必须有：`castCache` 的环保护键是**身份路径** `{self, other}`，而这条链**每层都新建节点**
  （`intersection.buildValues` → `rt.intersection(parts)`），身份永不重复 ⇒ 剪枝无从生效。
- 证据（2026-09-30 实测；触发场景 = 重放 F2 依赖边补丁，见 `returns.md` F2）：
  - **147014 层栈溢出**，栈形：`undefined-field provider → … → intersection.onCanCast
    → .value → #self.values → values getter → getValues → buildValues → rt.intersection → __init`；
    `logOverflow` 落盘的 traceback 里可见 `node.lua:261 canCast ↔ union.lua:55 onCanCast ↔
    node.lua:261 ↔ table.lua:405 onCanBeCast ↔ node.lua:267`，`skipping 8833 / 9989 / 11982 levels`。
  - 插桩（临时，已撤）：`values` getter **嵌套**最大值 `maxNesting=9`、构造嵌套 `maxInitNesting=1`、
    守卫计数 `maxD=19`、`bailDepth=0`、`states=0 / tasks=0 / rts=1`（单 state、无 task、单 runtime）
    ⇒ `intersection` 的 `DEPTH_LIMIT=64` **从未触发**：它只数自己 getter 的嵌套，
    而失控发生在 `canCast` 那一层（护栏装错了层）。
- 代码：`script/node/node.lua` 的 `CAST_DEPTH_LIMIT = 64`（`M:canCast` 包装 + 模块级 `castImpl`）；
  计数挂 `rt.castDepth`，并在 `Runtime:flushCacheNow` / `Runtime:reset` 一并清掉
  （异常穿出时不留「永久宽松」）。
- 数字：**仅护栏** ⇒ 目标工程 154 → 154（移除 0 / 新增 0，批量零行为变化）；
  **护栏 + 重放 F2 依赖边补丁** ⇒ 154 → 149（移除 5 / 新增 0）且**不再爆栈**
  ⇒ F2 的依赖边方案（`f:addRef(call)` + `addReturnList → flushCache`）从此可采用。
- 试过但未采用：
  - 用**结构签名键**替代身份键剪枝（按 `typeName`/`kind` 组合）：能命中「每层结构相同」的环，
    但会改变正常路径的裁剪时机（未实测），且与 `castCache` 的身份键语义并成两套判定；
  - 调大 `intersection` 的 `DEPTH_LIMIT`：护栏不在那条链上（`bailDepth=0`），无效。
- 状态：成立（2026-09-30）

