# 事实台账：多返回值 / 无界返回（vararg）

格式同 `narrowing.md`：断言 / 证据 / 代码 / 状态。

## F1 无界返回的 List：一个值 = 任意位置都有；多个值 = 只有前 min 个保证有
- 断言（单值无界）：`Node.List` 只有**一个值**且无上界（`max = false`，如 `rt.list({T}, 0, false)`）时，
  `select(i)` 对任意 i 都返回 `T`，**不加 `| NIL`**——即 `Node.List:select` 里的
  「无界单元素 list（vararg 语义）：视所有位置均存在，不加可选 | NIL」
- 断言（多值无界）：有多个值且无上界时，超出 `min` 的位置仍带 `| NIL`（`min` = 保证返回的个数，
  只有 `i == min` 不加）
- 证据：test/node/vararg.lua（`list({INTEGER}, 0, false)` → `integer?...`、`select(2)/(100)` = `integer`；
  `list({1,2}, 1, false)` → `select(1)=1`、`select(2)=2 | nil`）；
  test/node/fcall.lua（`return ...` 的函数，调用结果 `select(2)` = `unknown`）
- 代码：`script/node/list.lua`（`select` / `makeViews`）、`script/node/fcall.lua`（`FCall.returns`）
- 踩过的坑：`FCall.returns` 为「不定长返回（spread）」把末位元素**追加**成第二个值时，
  单值无界 list 变成两个值 → `select(2)` 起变成 `T | nil`
  （目标工程 `script/core/command/exportDocument.lua:13` 的 `doc.makeDoc` →
  `local docPath, mdPath = ...` 第二个值报 `any | nil` 就是这个）；现在仅当末位元素
  与已有最后一项不同才追加（`tail:simplify() ~= last:simplify()`）
- 试过（别重走）：把 `Function.returnsPack`（推断路径）的 `min` 从「值个数」改成
  「各 returnList 的 `min` 取最小」（想让 `return ...` 的函数 min = 0）——目标工程
  **+121 处误报**（`return-type-mismatch` 一片，形如 `await.lua:37 return ...`），已还原。
  要动那个 `min` 得先搞清它在 `return-type-mismatch` 里被当成什么用
- 状态：成立（2026-09-22；目标工程 373，本轮移除 4 / 新增 0）


## F2 调用的第 1 个返回值在部分时机解析成 `nil`（未满足）
- 断言（未满足）：`local child = parseExp()`（**无 `---@return` 注解的递归局部函数**）之后，
  调用结果的第 1 个返回值应当是推断出来的返回类型（`{...} | nil`），
  而不是 `nil`；否则 `if child then` 会把它收窄成 `never`，分支内的读值退化成 nil，
  报一片 `need-check-nil`
- 证据（目标工程 `script/parser/compile.lua`，**29 条 need-check-nil** 全是这个形状）：
  - `if child then` 内部 `child.start`（3043/3112/3365/3411/3450 等）
  - 探针（目标工程）：`var:parseExp@3033:19-3033:26` 的 view = `fun(…):{...} | nil` ✓，
    但**同一个调用点**的 `head` 视图 = `fun(…):nil`（`FCall:onView`），
    `selHead=fcall selKey=value:1 headReturns=nil selValue=nil` →
    `List:select(1)` 对**空 list** 返回 `nil`（`script/node/list.lua:128-130` 的
    `values[key] or values[#values] or NIL`）
  - 同一节点在不同时机/顺序下的 view 不一致（探针一次给 `{...}`、一次给 `nil`）⇒ 与
    「编译早期算出来的缓存」有关
- 代码：`script/node/function.lua`（`returnsPack` / `returnList` / `returnsDef`）、
  `script/node/fcall.lua`（`returns`）、`script/node/list.lua`（`select`）；
  以及 `script/node/tracer.lua`（收窄值随 `class.flush` 失效后不重跑）
- 试过（2026-09-24，见 openspec change `tracer-flush-retrace`，**均不采用已回退**）：
  1. Tracer 按「flush 代数」重跑 walk（`Node.Runtime.traceEpoch` + `Walker.epoch/running`）——
     目标工程 276 → 276（0/0）。诊断链说明这条路不完整：walk **内部**的写入会互相 flush
     （`setCurrentValue` 会把自己登记进 flush 列表），早期写入的值在同一趟 walk 里就被清掉，
     代数却已在 walk 结束时对齐 ⇒ 不重跑；要彻底修得让 walk 的写入不受同趟 flush 影响
     （例如先收集 `written` 再统一写入，或写入后按需 `rawset` 回填）
  2. `Function:addReturnDef` / `addReturnList` 里 `flushCache()`（返回值集合变了让 `returnsPack` 重算）——
     目标工程 276 → 276（0/0），说明这个空 list 不是（只是）early-cache 造成的
- 状态：未满足（open）。下一步：先查清「调用点 head 的返回类型为什么是 `nil`」——
  是 `matchedFuncs` 拿到了另一个函数实例（generic resolve / clone），还是 `returnsPack`
  在递归求值中被当成 `PROVISIONAL` 后缓存

## F3 泛型 for 的循环变量在部分时机退回「列表值」而不是元素（未满足）

- 断言（未满足）：`for _, v in ipairs(list)` 的循环变量 `v` 应当恒为 `list` 的**元素**类型；
  现在在「循环前用形参注解比实参宽的调用过同一个表」（如 `countList(returns)`，形参
  `Obj[] | nil`）+ 循环体内嵌套 if 的读位置上，`v` 会解析成**列表值本身**
  （`Obj[] | nil`）⇒ 元素字段读误报「未定义字段」
- 证据（仓库内最小复现）：`test/project/repro/ipairs-narrow-field.lua`
  （去掉文件里的 `---@diagnostic disable-next-line: undefined-field` 即见
  `ipairs-narrow-field.lua:34 | start = ret.start | Undefined field start`）；
  变量在文件不同读位置上取值不一致：循环体内 `countList(ret)` 处 = `any`、
  嵌套 if 里的读 = 列表值（这种「同一变量不同位置取值不同」与 F2、`narrowing.md` F19 同族）
- 目标工程同族：`script/core/diagnostics/missing-return-value.lua:30/31`（`ret.start`）、
  `script/parser/compile.lua:3451`（`c.finish`，`c = parseExp()`），
  以及 `script/utils/init.lua` 一族的 `undefined-field` 残留
- 代码：`script/vm/coder/block.lua`（`for` 的 `forf`/`fors`/`forvar`/`forcall` + 循环变量
  `rt.select(call, i)`）、`script/node/select.lua`、`script/node/fcall.lua`、
  `script/node/list.lua`（元素/`select` 语义）、`script/node/tracer.lua`（读位置取 flow 值 / 静态兜底）
- 机制线索：编码器把循环变量建成 `select(fcall(iterator, {状态, 控制}), i)`；
  `fors` 取的是 explist 的第 2 个值（迭代器的 state = 原表），元素类型要靠
  「泛型 V 在 ipairs 调用时绑定」；一旦泛型绑定退化（truthy 之类标记做参数），
  V 就丢，部分路径退回 state。
  诱因与「读到未收窄值」（`narrowing.md` F19）重叠，但成因在**循环变量的取值建模**上
- 状态：未满足（open）

