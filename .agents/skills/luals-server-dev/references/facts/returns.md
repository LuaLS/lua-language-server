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


## F2 调用的第 1 个返回值在部分时机解析成 `nil`（已满足，2026-10-08）
- 断言（未满足）：`local child = parseExp()`（**无 `---@return` 注解的递归局部函数**）之后，
  调用结果的第 1 个返回值应当是推断出来的返回类型（`{...} | nil`），
  而不是 `nil`；否则 `if child then` 会把它收窄成 `never`，分支内的读值退化成 nil，
  报一片 `need-check-nil`
- **2026-09-30 补充（面板残留的完整链条 + 两条新实测）**：
  - 插桩 `W:traceVar` / `W:traceRef`（目标工程 `compile.lua` 的 `local child = parseExp()`）：
    **每一次 walk** 里 `child` 的静态值都是 `nil`（`[childVar] local:child@3033 static=nil`），
    于是 `if child then` 把分支判死 ⇒ 分支内读点被写成 **`never`**（`[child3043] write value=never`）。
    **`never` 不含 nil ⇒ `need-check-nil` 不报** —— 这是批量 harness「看起来已修好」的原因。
  - 一旦发生**真实 flush**（长会话里随时发生），那些 `never` 被清掉 ⇒ 读值退回静态兜底
    （`parser.object | nil`）⇒ 报 `need-check-nil`（实测：强制 flush 场景下 `cv=nil value=nil`）。
    ⇒ 面板 `compile.lua:3043/3044` 一族 = **F2（错值 `never` 掩盖）+ flush 把它冲掉后暴露**，两个缺陷叠加，
    只修「重走」不够。
  - 新实测（**均不采用，已回退**）：
    1. `W:restart()` 里顺手 flush「本次 walk 写过的收窄节点」⇒ 强制 flush 场景**精确复现面板那批**：
       156 → 193（移除 3 / 新增 32 = 面板的 `compile.lua:1290/1387/1407/3043/3044/…`）；
       普通过程 154 → **174**（净变差）
    2. walk 内的收窄写入跳过 `setCurrentValue` 的 flush（`skipFlush`）⇒ 普通过程 154 → **174**
       （移除 10 / 新增 25），且**把 #21/#22 修好的族带回来**（`json-edit.lua:249/257/265/322/405`、
       `json.lua:427/435`）⇒ `setCurrentValue` 的 flush 是**承重**的（负责让依赖节点按位置重算），
       不能简单去掉
  - 下一步收窄：`W:traceVar` 里 `getStaticValue()` 对 `local child`（赋值来自调用）拿到的是**真 nil**
    —— 而 `getStaticValue()` 的兜底是 `rt.ANY`，能返回 nil 说明链上某条 getter 直接给了 nil
    （`assignValue` / `getGuessValue` / `select`），应从那里查，而不是只看 `List:select` 的空 list 分支
  - **2026-09-30 下午：钉到「异常实例」这一层，三条修法实测无效**：
    - 插桩 `FCall.returns`（空 list 时打印匹配到的函数）：`matched=1 retCalls=1 retList=1 firstVals=0`
      —— 匹配到的函数实例只收到过**一次 `addReturnList`，而且那条 list 是空的**
      （= coder 只为一条 bare `return` 发过 `addReturnList`），其 `returnsPack.min=0` ⇒ `select(1)` = nil。
    - 但**同一时刻**探针（`--probe-var=var:parseExp@3033`）给的是
      `fun(asAction…):{...} | parser.object | any | nil`（**有**返回值）⇒ 同一调用点的函数值
      **在不同运行阶段不一致**（探针不跑诊断/walk）。这就是 F2 的老症状，新证据指向
      「matched 到的那个实例不是有返回值的那个」或「该值在诊断阶段已退化成空」。
    - 实测无效（**均不采用，已回退**）：
      1. `Function:addReturnList` 里 `flushCache()` ⇒ 目标工程 154（0/0）
      2. 同上改为直接清 `returnsPack` 字段 ⇒ 154（0/0）⇒ **不是「缓存早了」**
      3. `FCall.returns` 空 list 时从 `head:each('function')` 里挑「有返回值」的成员兜底 ⇒
         `retFallback` **一次都没触发**（那个时刻 head 上就是没有带返回值的成员）⇒ **是求值时机问题**
    - 下一步入口：查「诊断阶段（walk 触发的那次求值）为什么该调用点拿到的实例/返回值是空的，
      而探针阶段是对的」—— 重点看 `FCall.matchedFuncs` 的 `head:each('function')` 实际遍历到哪些实例、
      以及 `Node.Variable.value` 的 `currentValue/guess/staticValue` 在那条路径上的来源。
  - **2026-09-30 调试图定位（根因链条已完整，修法仍未落地）**：
    在**运行中的 LS**（attach 11466，服务目标工程）里用调试器 + 落盘探针确认：
    - `local child = parseExp()` 编译成 `rt.select(call, 1)`；`Node.Select.value` 是 **getter 缓存字段**；
      它在「函数的返回集合还没齐时」被算过一次 **`nil`** 并**缓存住**，之后没有任何机制作废它。
      活状态实测：`local:child@3033 => variable | { parent: { [1]: nil } }`、
      `select#1@3033 => select | nil`，而**同一时刻**该函数 `retList=[1,1]`、`returnsPack` 完整 ✓
      ⇒ 就是「早期 nil 被缓存」（不是函数真的没返回值）。
    - 后果链：`child = nil` ⇒ `if child then` 判死 ⇒ 分支内读点被写成 `never`（批量 harness 因此不报）
      ⇒ 一旦有 flush 把 `never` 冲掉，读值退回 `nil` 类型 ⇒ 报 `need-check-nil`（面板那批）。
    - 同一进程两次分析结果不同也印证：LS 缓存里那份 30 条含 `3043/3044`；强制 `calculated=false`
      重算后的 63 条不含（need-check-nil 变成 3411/3417/…）。
    - 本轮修法实测（**均不采用，已回退**）：
      1. `Select.value` 取到 `nil` 类型且被调函数有返回值时「按函数的返回集合重算」——
         批量不回归（154，0/新增 0），但**面板无效**：那个 nil 是**已缓存**的，getter 不会再跑
      2. 同上但让「nil 结果**不缓存**」(`return value, false`) ⇒ 批量 154 → **移除 9 / 新增 34** ✗
         （`postfix.lua` 一片新误报：不缓存改变了取值时机）
      3. 依赖登记 `f:addRef(call)`（函数 → 调用）+ `addReturnList` 里**手术式**清依赖节点的缓存
         （`class.flush` 只清字段、不触发求值）⇒ 批量 **147k 层栈溢出**（`intersection.lua:19`，
         在 `undefined-field` provider 里）✗
      4. 早先的 `addReturnList` 里 `flushCache()`（0/0）与 `f:addRef` + eager flush（栈溢出）✗
    - 结论（下一轮的约束）：**「作废缓存」与「交集求值的终止性」强耦合**——清掉这些缓存会让
      intersection/intersection 派生值重算不收敛。要么解决这个耦合，要么改从
      「让函数返回值在 **Select 首次计算前** 就齐」入手（例如 `addReturnList` 的时机/顺序）。
      另一条低成本路线：目标侧给无注解的递归函数补 `---@return`（`returnsDef` 在编码期就有值，
      Select 首次计算即正确），但要注意别引入新的返回值不匹配诊断。
  - **2026-09-30 重试（在 `eval-context-unify` 落地之后，**仍不采用**）**：
    新前提 = ①求值期不失效（入口锁 + 静默点批量）；②`intersection` 环保护换成**结构签名键**
    （`Node.Intersection.EvalState`）；③只缓存完成态。
    重放 #24 那版（`FCall.matchedFuncs` 登记 `f:addRef(self)` + `Function:addReturnList` → `flushCache()`）：
    **仍 147014 层爆栈**，栈形同上次：`undefined-field provider → … → intersection.buildValues
    → rt.intersection(parts)（新节点）→ onCanCast → …`。
    **结论修正**：这条爆栈不是「签名环」（结构键也拦不住），而是**深度爆炸**——
    `buildValues` 里每层都新建交集节点、签名各不相同 ⇒ 结构键的环保护不触发；
    而 `values` getter 里的 `enterDepth` + `DEPTH_LIMIT = 64` **没有拦住这条路径**
    （`buildValues → rt.intersection(...) → 新节点的 value getter` 这条链上的计数/任务键需要另外查）。
    ⇒ 结论：**F2 的依赖边方案在「深度爆炸」修掉之前都不可能采用**；下一条入口是先查
    「为什么 `DEPTH_LIMIT` 没拦住 `buildValues` 的递归」，或走目标侧 `---@return`（C 方案）。
  - **2026-09-30 调试图定位（根因链条完整；含「谁先读它」与「为什么那时还没齐」的实证）**：
    在**运行中的 LS**（attach 11466，`🍄attach` 配置；服务目标工程）里用调试器 + 落盘探针确认：
    - **谁先读 `Select.value`**：不是 coder 期，而是**诊断 pass 里的 tracer walk**。
      三条由探针 `debug.traceback` 落盘的栈完全同形：
      `undefined-field provider → vfile:getNode → Variable.__getter.value → tracer:trace()
      → traceIf → traceIfChild → traceCondition → traceConditionUnit → traceEqual
      → traceByValue → isMultiValue → finalValue → Select.value`
      （即 `node.lua` 的 `finalValue`/`isMultiValue` 在 walk 期间读到了它。）
    - **为什么那时返回集合还是空**：读发生在**首次分析**期间（工作区索引/推断未完成），
      此刻被调函数的返回集合为空 ⇒ `select(1)` = `nil` 被**缓存**在 `Select.value`（getter 字段）上；
      之后没有任何机制作废它（见下「依赖边」）。
    - 活状态（同一时刻）：`local:child@3033 => variable | { parent: { [1]: nil } }`、
      `select#1@3033 => select | nil`，而被调函数 `retList=[1,1]`、`returnsPack` 视图**完整** ✓
      ⇒ 就是「早期 nil 被缓存」，不是函数真的没返回值。
    - 后果链：`child = nil` ⇒ `if child then` 判死 ⇒ 分支内读点被写成 `never`（批量 harness 因此不报）
      ⇒ 一旦有 flush 把 `never` 冲掉，读值退回 `nil` 类型 ⇒ 报 `need-check-nil`（面板那批）。
      旁证：同一进程两次分析结果不同 —— LS 缓存那份 30 条含 `3043/3044`；强制 `calculated=false`
      重算后（此时索引已就绪）的 63 条**不含**（need-check-nil 变成 3411/3417/…）。
  - **依赖边现状（代码坐标，2026-09-30 核对）**：
    - `script/node/select.lua:53-54`：`head:addRef(self)` / `key:addRef(self)` ⇒ **call → select ✓**
    - `script/node/fcall.lua:125-126`：`head:addRef(self)` / `args:addRef(self)` ⇒ **head 变量 / 实参 → call ✓**
    - **函数节点没有出边**：`FCall.matchedFuncs` 不登记 `f:addRef(call)`；
      `Function:addReturnList`（`function.lua:389`）只 `table.insert`、**不 flush**
      ⇒「函数返回集合补齐」传不到 call/select；函数自己的 `returnsPack`（getter 缓存）
      也不会因 `returnList` 变长而失效。
  - **失效为什么难做（本次实测 + 修正后的机制解释）**：
    - 实测：`addReturnList` 里单独 `flushCache()`（**不登记**函数→调用边）⇒ 批量 **0/0**（不炸，但也没用：
      消费端 `FCall.returns`/`Select.value` 各自的缓存还在）；一旦**登记** `f:addRef(call)`，
      再清（eager `flushCache()` 或只 `class.flush` 字段）⇒ **147k 层栈溢出**（`intersection.lua:19`，
      在 `undefined-field` provider 里）。
    - 机制（**不是**「缺缓存所以不收敛」——首次求值同样无缓存却收敛）：首次求值是**单调建立**、
      节点身份一致，环保护（按节点身份记录"正在算"）能认出环；**事后清缓存**发生在已被彼此引用的图上，
      重算会**新建等价节点**（身份变了）⇒ 环保护不再匹配 ⇒ 环重复展开 ⇒ 发散。
      叠加**范围/时机**：登记那条边后，清一个函数会顺着 `函数 → 调用 → select → 读过它们的并集/交集/表`
      一路清（每条 `return` 都触发、与其它文件的求值交错）⇒ 整片图的身份记忆被反复抹掉 ⇒ 不收敛。
      同现象先例：`classes.md` F25「试过 #2」的「每次新建节点，cast 缓存命中不了，表与类互转的递归不收敛」。
    - 结论：**不要在 flush / 依赖边上继续加力**。
  - **候选修法（本轮决定：都先不动，仅记账）**：
    - **A（窄、安全，用户暂不采用）**：不动缓存语义，只在 `ls.scope.onDidLoad` 那次刷新前把
      `vfile.diagnostic.calculated` 清掉，让「索引就绪后的那一趟」覆盖「首次 pass 的残缺结果」
      （实测依据：`calculated=false` 重算不再出 3043/3044）。
    - **B（正、难）**：让「函数返回集合变化」真正传到 call/select，同时保证失效不破坏交集收敛
      （例如失效只打标记、把重算推到静默期；或让 `addReturnList` 在 `Select` 首次计算之前完成）。
    - **C（目标侧）**：给无注解的递归函数补 `---@return`（`returnsDef` 编码期即有值）——
      要注意别引入新的返回值不匹配诊断。
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
- **2026-09-30 前置障碍已解除（护栏装错了层，见 `casts.md` F3）**：147k 爆栈**不是** `intersection`
  的 `DEPTH_LIMIT` 失效，而是**护栏不在失控链上** —— 失控在 `Node:canCast` 的递归
  （`castCache` 身份键对不上：每层新建节点）。实测 `maxNesting=9` / `bailDepth=0` / `states=0` /
  `tasks=0` / `rts=1` 排除了状态/任务/运行时分片。落地 `CAST_DEPTH_LIMIT = 64` 后重放本条的依赖边补丁：
  **不再爆栈**，目标工程 **154 → 149（移除 5 / 新增 0）**（仅护栏则 154 → 154，0/0）
  ⇒ 依赖边方案（`FCall.matchedFuncs` 加 `f:addRef(self)`、`Function:addReturnList` 加 `flushCache()`）
  **从「不可采用」变为「可采用」**；下一步是带**面板**验证的一轮（本轮结论只说明它可跑通、批量不回归）。
- **2026-10-08 依赖边已落地（OpenSpec change `f2-dependency-edge`）**：
  - 改动 = 上面那两行（`script/node/fcall.lua` 的 `f:addRef(self)` + `script/node/function.lua` 的
    `addReturnList → flushCache()`），零其他改动。
  - 数字：目标工程 **154 → 149（移除 5 / 新增 0）**，移除的正是**同一族**：
    `compile.lua:3365(x2) / 3375 / 3411 / 3417`（`child` / `exp` 的 `need-check-nil` / `undefined-field`，
    与面板的 `3043/3044` 同形 —— 都来自「早期空返回集合被缓存」）。全量 `--test` 绿、本仓库面板 0。
  - **踩坑（重要）**：落地前必须在 `canCast` 护栏里去掉「失效点清 `castDepth`」那行 ——
    依赖边让失效在递归中途频繁发生，一清护栏就形同不存在（实测复现 `intersection.lua:151` 栈溢出）；
    详见 `casts.md` F3 的「坑」。
  - 面板侧（目标工程长会话）：`compile.lua:3043/3044` 一族应在用户编辑器里消失（**待用户确认**）；
    两行改动，若出现新问题直接回退本 change。
  - 状态：**已满足（2026-10-08）** —— 用户确认目标工程面板 `compile.lua:3043/3044` 一族**不再报**；
    批量侧同时移除同族 5 条（`compile.lua:3365(x2)/3375/3411/3417`）。

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
- **目标侧落地（2026-09-29，已采用，218 → 216）**：两处一起改 ——
  1. `vm/function.lua:291`：`---@param list parser.object | parser.object[] | nil`
     （与 7 个调用点里 6 个传单节点的事实对齐）；
  2. `vm/function.lua:300`：`local lastArg = list[#list]--[[@as parser.object?]]`
     （元素读在参数变宽后是并集，出调用点前断言回节点；`if not lastArg` 的判空仍在，`?` 保住 nil）。
  实测 **218 → 216（移除 2 / 新增 0）**：`missing-return-value.lua:30/31` 消失，
  且不再冒出 `function.lua:319`。全量 `--test` 绿（本仓库无改动）、面板 0。
- 余下的**引擎侧**候选（本轮用目标侧 cast 绕过了，仍值得单独量）：
  1. 「字段判等收窄」作用在**索引读出来的值**上不生效（`list[#list]` 后 `lastArg.type == 'call'`
     没能把并集收窄回节点）——注意其中「字段不存在（读值 = `never`）」的成员被判成
     「可能相等」（`NEVER:canCast(任意)` = true）也是原因之一；
  2. 「参数反推写回变量」是否该只作用于该次读取（整段停是净变差，见上）
- 状态：目标工程侧已收敛（218 → 216）；引擎侧两个候选仍 open



