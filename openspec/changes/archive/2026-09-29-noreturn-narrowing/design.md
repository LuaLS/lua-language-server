# Design

背景与动机见 `proposal.md`；行为契约见 `specs/noreturn/spec.md`、`specs/narrowing/spec.md`。

## Context

现有「分支不参与 `if` 之后合并」的判定链条是三段，且都在**语法层**：

1. `script/parser/ast/block.lua:191-205`：分支最后一条语句是 `return` → `block.returns`；
   `goto`/`break`/`continue` → `block.exits`。
2. `script/vm/coder/block.lua:75-103`（`if` provider）：`child.returns`/`child.exits`
   翻译成 flow 标记 `tracer:openNode('return' | 'exit')`，作为分支数组的第 1 个元素。
3. `script/node/tracer.lua:609-636`（`W:traceIfChild`）：读到该标记 → `stack.terminated = true`，
   `W:traceIf`（`:569-601`）对该分支只合并 `otherSide`。

`noreturn` 判定需要**类型层**信息（`error` 是内建、`decode_error` 是未注解包装），
语法层拿不到，所以必须把判定点从 (1) 下移到 (3)。

相关既有能力：`Node.FCall.matchedFuncs`（`script/node/fcall.lua:119`）能把调用点解析到
`Node.Function[]`；`scope.vm:getNode(ast)`（`script/node/runtime-helper.lua:220`）能做 AST → Node 反查；
`Node.Function` 已有 `setAsync()` 这类由 coder 设置的标记（`script/node/function.lua:46`），
`---@noreturn` 沿用同一形状。步进式收窄的既有机制见 `.github/skills/.../facts/narrowing.md`。

## Goals / Non-Goals

**Goals**

- `---@noreturn` 注解可用（函数定义上），语义 = 调用之后同分支不可达。
- 未注解包装函数（体最后一条语句是对 noreturn 函数的调用）自动推断为 `noreturn`。
- `if ... then <noreturn 调用> end` 之后的收窄不再并入 `nil`。
- 只有「确定 `noreturn`」时才终止分支；其余调用一律照旧合并（`log()` 一类不得终止）。

**Non-Goals**

- 不做控制流的可达性诊断（`code-after-break` 一类）；`noreturn` 只影响收窄与调用值。
- 不处理 `pcall` / `coroutine` / `goto` 与 `noreturn` 的组合语义。
- 不动 `script/node/table.lua` 的视图 `checkSkip`（另开，见 proposal「不做」）。
- 不把 `assert` 改写成 `noreturn`（`assert(v)` 在 v 为真时正常返回）。

## Decisions

### D1 判定点放在 walker（`W:traceIfChild`），不放 parser/coder

`W:traceIfChild`（`script/node/tracer.lua:609`）在 `self:traceBlock(ifchild, bodyStart)` 之后，
检查该分支**最后一个** flow unit：若是 `{'call', callAlias, funcAlias, argAliases}`
（`script/vm/coder/tracer.lua:229` 的 `appendCall` 形状），用 `funcAlias` 取
`self.map[funcAlias]` → 解析出 `Node.Function[]` → 全为 `noreturn` 则 `terminated = true`。

实测的 guard 形状（`--probe-flow`，`tmp/repro-rtm-json/flow.lua`）：

```lua
{ "if", {
    { "condition", { "not", { "ref", "v@4:18", "var:v@5:12-5:12" } } },
    { "ref", "fatal@1:16", "var:fatal@6:9-6:13" },
    { "value", "string@6:15-6:18" },
    { "call", "call@6:9-6:19", "var:fatal@6:9-6:13", { "string@6:15-6:18" } },  -- 末位即调用
} }
```

- 为什么不下移到 coder：coder 生成 middle code 时**不解析被调用者**（`fcall` 只生成
  `rt.call(...)`，目标解析在 Node 层 `matchedFuncs`）。在 coder 里解析会重复实现一套目标解析，
  且 meta 与用户文件的编译顺序不可依赖。
- 为什么不用 parser 标记：parser 只有语法，判不出 `error`。
- 备选（未采用）：把 `---@noreturn` 的信息在 coder 里展开成 `'exit'` flow 标记——
  同样卡在目标解析上，且 `decode_error` 的推断需要跨函数信息。

### D1b `noreturn` 的两条来源与共享判定

- 注解：`---@noreturn` **不需要注册 cat parser**——未注册 subtype 的 cat 是普通的
  `LuaParser.Node.Cat`（`script/parser/ast/cats/cat.lua:176-183` 只在有 config 时建 `cat.value`），
  与 `---@async` 同路；coder 在 `getCatGroup` 的结果里按 `cat.subtype == 'noreturn'` 识别
  （`script/vm/coder/function.lua`，与 async 的写法一致）。
- 推断：函数体（其自身 flow）的**最后一条** unit 是对 noreturn 函数的调用。
- 两者共用一个判定 `ls.node.tailCallNoReturn(units, map)`（定义在 `script/node/function.lua`），
  walker 传分支 block + 自己的 `map`，`Node.Function:isNoReturn()` 传自身的
  `flowTracer.flow` + `flowTracer.map`；结果记忆在函数节点上，求值中再次进入直接返回 false（环保护）。
- 函数节点的 flow 由 `coder:finishTracer(funcKey)` 发射 `{func}:setFlowTracer({tracer})` 挂上
  （`startTracer` 时主函数的 `rt.func()` 还没执行，故不能在 startTracer 里发射）。

### D2 `noreturn` 是 `Node.Function` 的惰性、带记忆的属性（注解 + 推断同处实现）

`Node.Function` 增加 `noreturn` 标记（`setNoReturn()`）与 `Node.Function:isNoReturn()`：

1. 注解路径：LuaCats 新增 `---@noreturn`，经
   `script/vm/coder/function.lua` 的 `getCatGroup(source)` 机制发射 `{func}:setNoReturn()`
   （与 `async` 同形状，`script/vm/coder/function.lua:145-155`）。
2. 推断路径：函数体最后一条语句是调用语句时，取该语句在自身 flow 里的调用 unit
   → `map[funcAlias].value` → 全部 `noreturn` 则为真（`ls.node.tailCallNoReturn`，见 D1b）。
3. 记忆与环保护：结果缓存在 `Node.Function` 上；求值中的函数标记为「处理中」，
   遇到自身直接返回 false（递归互调不得死循环）。

- 备选（未采用）：在 `Node.Function:returnsPack` 里把 `noreturn` 折成 `never` 返回值——
  会把「不可达」与「返回值类型」两件事耦在一起，`return-type-mismatch` 一族（`facts/returns.md` F1/F2）
  已经在返回值个数上很脆，不往里加语义。
- 备选（未采用）：用函数自身 AST（`LuaParser.Node.Function` 继承 `Block`）判末位语句——
  Node → AST 没有反向索引（`vfile:getNode(ast)` 只是 AST → Node），而 flow 已经是同一份信息的现成形态。
- 备选（未采用）：要求用户给包装函数手写注解（改目标工程 `decode_error`）——
  目标工程侧的正当修法可以做，但不能作为引擎行为的替代（未注解代码同样常见）。

### D2b 语法名选 `---@noreturn`，不用 meta 里既有的 `---@throw`

`meta/whimsical/basic.lua` 里已有 `---@throw`（`error` 一行）与 `---@throw => args[1].isFalsy`
（`assert`），但本仓库没有任何 `throw` 的实现（`catParserMap` 里没有；`---@narrow` 那套 DSL 是实现的）。
不用它的原因：DSL 形式带**条件语义**（assert 只有参数为假时抛），要支持就得专门写 parser 并把
「无条件抛」与「条件抛」分开，否则会把 `assert(v)` 之后的代码误判为不可达。
故本轮只做无参的 `---@noreturn`（写法与 `async` 同族）；`---@throw` 是否复用留待后续（记进 fact）。

### D3 调用值：`noreturn` 函数的调用结果视为 `never`（**实测后不采用**）

原计划：`Node.FCall:select` / `value` 在 `matchedFuncs` 全为 `noreturn` 时返回 `rt.NEVER`。
实测（在 meta 已标 `error`、收窄判定已生效的基础上）：目标工程 **216 → 199 不变（移除 0 / 新增 0）**，
而诊断耗时 9.74s → 10.12s（+3.9%）；原因是 `value` 是热路径，加一次 `matchedFuncs`（泛型匹配）
换不来任何诊断收益。**已回退**，spec 里对应的「返回值位置按不可达处理」场景一并删除。

### D4 meta 只标 `error`

`meta/template/basic.lua:54`、`meta/whimsical/basic.lua:50` 的 `error` 标 `---@noreturn`。
`assert` 不标（可为真值时正常返回，见 Non-Goals）；`pcall` 内的 `error` 语义由调用关系自然承担。

## Risks / Trade-offs

- [惰性推断在收窄热路径上递归（调 `matchedFuncs` → 泛型解析）] → 结果记忆在 `Node.Function` 上，
  且只在「分支最后一条语句是调用」时求值，不在每个调用点求值；先在目标工程上量耗时（218 条基线量的耗时）。
- [定义错 `noreturn` 会吞掉后续诊断] → 只在明确注解或「体最后一条语句是对 noreturn 的调用」时成立；
  `matchedFuncs` 为空（未知函数）一律 false（spec 的「未知函数不得当作终止」）。
- [D3 让调用值变 `never` 可能影响既有分析] → 单独一步、可回退；用基线比对决定去留。
- [`decode_error` 这类包装只在**体最后一条语句**成立] → 目标工程的 `decode_error` 正好是这种；
  体中间抛出但末尾有其它语句的形式本 change 不承诺（spec 只写最后一条语句）。
- [meta 加注解会改变所有工程的 `error` 相关推断] → 基线比对 + 全量 `--test`；若有回归，
  可只保留「注解 + 推断」机制而不给 meta 加注解（此时目标工程 12 条不会消，按实测记录让步）。

## Migration Plan

1. 先存基线（已存 `tmp/scan-noreturn-base.txt`，216 条）。
2. 按 tasks 顺序实现：parser cat → coder 发射 → Node 标记/推断 → walker 终止判定 → meta → D3。
3. 每步 `--baseline=tmp/scan-noreturn-base.txt` 比对，只保留「移除 ≥ 新增」的组合；回退用 git 单点还原。
4. 收尾：全量 `--test` 绿、目标工程 216 → 204、本仓库问题面板 `minSeverity=information` 无新增、
   结论上提 fact 并 `--test tools.facts`；归档时把 spec 增量并入主 spec 并更新 `项目实践.md`。
