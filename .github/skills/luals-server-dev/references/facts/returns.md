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
- 追加证据（2026-09-29，目标工程 `core/diagnostics/missing-return-value.lua` 探针）：
  **同一个循环变量 `ret` 在不同读位置取值不同** ——
  `var:ret@25`（声明）= `any`、`var:ret@26`（循环体顶层，正好是 `vm.countList(ret)` 的实参读）= `any`、
  `var:ret@30` / `@31`（`local rmin, rmax = vm.countList(ret)` 之后的嵌套 if 里，即报错处）
  = `parser.object[] | nil`、第二个循环的 `var:ret@39` / `@40` = `never`。
  ⇒ 循环变量进循环时是对的（`any`＝未知元素），**调用 + 结果比较之后退回未收窄的「声明类型」**
  （`returns? parser.object[]` 的 `parser.object[] | nil`），更深的读位置甚至是 `never`
- 诊断侧的另一半（现象自相矛盾的原因）：`undefined-field` 的 provider 检查的是**基值**
  （`ret` = `parser.object[] | nil` ⇒ `Array` 不认具名字段 ⇒ `exists = false` ⇒ 报），
  而读值/悬浮走的是**读节点自己的值**（= `any`，tracer 的宽松路径）
- 归因（按注解判）：`returns` 声明是 `parser.object[]?`，其元素 = `parser.object | nil`，
  **`start` 是有的** ⇒ 按注解 `ret.start` 不该报 ⇒ 这条是**我们的**缺口（循环变量/元素解析），
  不是目标工程注解问题。两个观察到的诱因（都可能是真凶，下一步用二分确认）：
  1. `for …, v in ipairs(returns)` 里 `<迭代对象>` 是**未收窄**的 `parser.object[] | nil`
     （守卫的 truthy 收窄只体现在读点，槽位仍是声明类型）⇒ 元素/泛型 V 解析退化，
     `v` 退回「迭代对象的表值」；
  2. `local rmin, rmax = vm.countList(ret)` 之后对结果做比较（`rmax < min` / `rmin == rmax`）
     会走 `W:traceLink` 的「间接窄化」→ `W:traceCallEqual`，按 **形参注解** 反推实参
     ⇒ `ret` 被写成 `parser.object[] | nil`（形参 `list: parser.object[]?`，`vm/function.lua:291`）
- 试过的候选（别再重复）：
  1. 让 walker 按 flush 代数重跑 —— 目标 276 → 276；放宽触发条件会 C 栈溢出（`narrowing.md` F19 记）
  2. 让「参数反推」只写回该次读取、不污染变量后续读取（对齐内联 cast 的既有设计）—— **未测**，
     要量：会不会丢掉 `pcall/load` 一族依赖「实参被形参收窄」的既有行为
- **二分结论（2026-09-29 实测，基线 218）**：
  - 候选 ② **就是这两条的元凶**：把 `W:traceLink` 的间接窄化（`tracer.lua:1053-1062` →
    `W:traceCallEqual`）整段停掉 ⇒ `missing-return-value.lua:30/31` 消失，
    但整体 **移除 6 / 新增 7**（净 +1）⇒ **不可整段停**：它同时修掉
    `compile.lua:2789`、`vm/operator.lua:199/205/223`，并挡住 `cli/doc/export.lua:122`、
    `newline-call.lua:46/49`（是**承重**机制，不是纯误报源）
  - 候选 ①（`ipairs(<未收窄表>)` 的元素解析）**不是**这两条的成因：
    停掉 ② 后复现文件里 `ret` 各位置都回到 `repro.Obj`
- **目标侧候选（实测 218 → 217：移除 2 / 新增 1，未采用）**：
  `vm/function.lua:291` 的 `---@param list parser.object[]?` 太**窄**——
  `countList` 的 7 个调用点里 6 个传的是单个 `parser.object`
  （`source.args` / `return` 节点等，按目标工程自己的约定「节点 = 带编号子项」），
  只有 `vm/function.lua:203` 传真正的 `parser.object[]`。
  把它放宽成 `parser.object | parser.object[] | nil` ⇒ 30/31 消失，但本体里
  `local lastArg = list[#list]` 读值变宽、`lastArg.type == 'call'` 的收窄没生效 ⇒
  `function.lua:319` 新增一条 `Cannot assign <并集> to parameter parser.object`
  ⇒ 要**两处一起**（参数注解 + 本体元素读的收窄/注解），或先修「字段判等收窄没作用在索引读值上」那个缺口
- 状态：未满足（open）


