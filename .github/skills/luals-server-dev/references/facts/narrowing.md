# 事实台账：flow 收窄（script/node/tracer.lua）

格式：断言（可判定的一句话）/ 证据（测试或目标工程坐标）/ 代码 / 状态。
状态取值：成立 / 未满足(open) / 已废弃。

## F1 跳转结尾的分支不参与 fall-through 合并
- 断言：`if not x then goto L end`（`break`、`continue` 同理）之后，x 的收窄保留，读值不含 nil
- 证据：test/coder/goto-narrow.lua（5 例）；test/feature/diagnostic/param-type-mismatch.lua 末 2 例
- 代码：parser `block.exits` → coder if 分支 `'exit'` 标记 → `W:traceIfChild` 认作 terminated
- 状态：成立（2026-09-22，4c47fb0ff）

## F2 反推（返回值相等 / 谓词真值）不得比实参自己的类型更宽
- 断言：`traceCallEqual` 写入实参的值必须能 cast 到实参自己的类型（`getExpectValue`）；
  实参确定非 nil 时按同名去掉反推结果里的 nil
- 证据：test/coder/narrow-branch.lua（2 例）；目标工程 provider/diagnostic.lua:257/267 等 8 处误报消失
- 代码：`script/node/tracer.lua` `W:traceCallEqual`
- 状态：成立（2026-09-21，3054c26b0）
- **补充（2026-09-23）**：实参**没有声明类型**时（for-in 循环变量、未注解局部）原过滤器没有基准，
  反推会把实参放宽（目标工程 `plugins/ffi/cdefRerence.lua:24` 的 `uri` 被写成 `string | number`、
  `tools/lua51.lua:201-203` 的 `mod` 被写成 `... | nil`）。已落地：`expectValue` 缺失/为 any/unknown 时
  退回用**实参自己的当前读值**（`getFieldNarrowValue(id)`）当基准 → 目标工程 282 → **281**
  （移除 `utility.lua:667` 的 `text:sub(offset, nl)` 那一族，新增 0）
- **补充 2（2026-09-23）**：同一条过滤原来只有 `W:traceCallEqual` 有，`W:traceCallTruthy`（调用真值反推）
  只有 nil 处理 → `if find(uri, …) and …` 一族的反推照样放宽。已抽成 `limitByOwnValue` 并接到两处 →
  目标工程 281 → **278**（移除 110 / 新增 12），`cdefRerence.lua:24` 消失。
  定位方式：instrument `W:setNarrowResult`（过滤 id）+ 打调用栈，直接看到
  `uri@22:9` 先被写成 `uri`（正确）又被 `traceCallTruthy` 覆写成 `string | number`
- 状态：成立（2026-09-23；两处过滤都带「实参自身值」兜底）

## F3 收窄结果必须与变量自己声明的类型相容
- 断言：任何写进收窄栈的读值都要能 cast 到该变量自己的类型，不相容就丢弃（不写）
- 证据：目标工程误报 auto-require.lua:123、duplicate-set-field.lua:68/88/89、luadoc.lua:1973
  （`def == src` 两变量比较把 `def` 反推成 `{ uri: uri }`；字段比较 `a.t ~= 'x'` 反推成 `never`）
- 试过：按 canCast 过滤 exit 分支的 otherSide 三方向 —— value→outer：rm28+add25；
  outer→value：rm18+add233；只滤字面量表：rm28+add25。都会连带丢掉大量正常收窄，均不可行
- 试过（2026-09-22 第二轮，定位到具体那一处）：`Node:narrowByField`（`script/node/node.lua`）
  对**类/实例**基值走的是 `myValue = self:get(key)` + `if myValue:canCast(value)` 二选一：
  字段声明类型比比较值宽时（`parser.object` 的 `type: string` 对 `type == 'getlocal'`）
  `myValue:canCast(value)` 为假 → 返回 `(NEVER, self)` → 基变量被写成 `never`
  （目标工程 `auto-require.lua:88` 的 `targetSource` 就是这样，随后 `vm.getDeprecated(targetSource.node)` 的实参报 `parser.object | nil`）。
  探针实测：`PROP2 targetSource@83:23 key=type pvalue=parser.object narrowed=never`，
  且此时传进来的 `value` 本身已经是 `never`（上一级就已经判成不可能）。
- **落地形式（决策，2026-09-22）**：不改宽 `narrowByField` 的整体判据
  （试过「两个方向任一能 cast 就算可能」：目标工程 377 → 371（移除 12 / 新增 6），
  但会打破全局变量的真值收窄——`test/feature/hover/manually.lua:56`
  `if GB then print(GB) end` 里 GB 从 `string` 变回 `string | nil`，因为 `_ENV` 那一级被写成 `_G` 而不是 `never`），
  改为加一条**前置守卫**：传入的 `value` 已经是 `never` 时不做任何收窄，直接返回 `(self, NEVER)`
  （`script/node/node.lua` 的 `M:narrowByField`）。
  效果：目标工程 377 → **376**（移除 7 / 新增 6），全量 `--test` 绿；`test/node/narrow.lua` 钉住该语义。
- **新增 6 处（待分诊，都是先前靠 `never` 侥幸压住的老问题被暴露）**：
  `vm/operator.lua:157/158/163`（`c.node`/`c.signs`，那里 `c` 只推成 `vm.global` 一个类）、
  `hover/description.lua:263/264`（`enum.default`），另有 `plugins/ffi/c-parser/c99.lua:66`、
  `vm/compiler.lua:2320`、`vm/function.lua:444`、`vm/node.lua:272/307-309`、`vm/type.lua:886`。
  下一步是逐条判断「我们推得太窄」还是「目标工程注解该补」。
- 状态：**部分满足**（撤 `never` 污染这一支已落地；「收窄结果必须与变量自身类型相容」的完整约束仍未立）

## F4 `and` / `or` 的值位置（`x = a and b`）目前不做真值收窄
- 断言：值位置只遍历操作数条目取 currentValue；右操作数拿不到左侧收窄（`x = s and #s` 里 `#s` 是 `op.len<string | nil>`）
- 证据：无测试（调研数据见 项目实践.md「2026-09-21（第二轮）」）
- 代码：`W:traceUnit` 的 `and`/`or` 分支；`traceAnd`/`traceOr` 只在 condition 位置被调用
- 状态：未满足（open，2026-09-21 调研：操作数边界要 coder 插标记，落 6 处新误报后暂缓）

## F5 真假标记 `truthy` 会作为读值出现（无成员集）
- 断言：`any` 上的真值收窄得到 `type truthy`，它没有字段 → 作为读值会引发「未定义字段」/形参不匹配
- 证据：目标工程 vm/global.lua:602、vm/type.lua:605、completion.lua:1861/1884 仍是 `truthy` 相关误报；
  2026-09-23 第六轮后新增的 `cli/doc/export.lua:75/79`（`if a.name and b.name and a.name ~= b.name` 里
  `a.name` 被收成 truthy，随后 `truthy:get('name')`/`truthy ~= …` 报未定义字段 / Need check nil）、
  `plugins/ffi/c-parser/c99.lua:66` 同类
- 代码：`rt.TRUTHY`（`script/node/runtime.lua`）；`W:traceByValue` / `W:traceCallTruthy`
- 试过（2026-09-23，未采用）：在 `W:traceByValue` 里对 `any`/`unknown` 的真值收窄直接跳过 ——
  会挂 `test/coder/narrow-branch.lua:47`：`if not args or not other then return end` 之后的
  `args` 靠这个 truthy 标记提供「确定非 nil」证据，反推时才会去掉结果里的 nil（F2 的边界）
- 状态：未满足（open；当前结论：标记要留在 flow 里，不能作为读值暴露给消费方，修点在消费侧）
  - 已做（2026-09-23）：`undefined-field` 不再对 `truthy` 目标报未定义字段（与 nil/never 同等对待）；
    目标工程数字未变，剩余 `cli/doc/export.lua:75/79` 那 4 条的读值不是纯 `truthy`，需要继续查
  - 已做（2026-09-24，openspec change `truthy-marker-field-read`）：`Node.Type:get` 把 `truthy` 并入
    `any` / `unknown` 那一支（读它的字段恒为 `any`）。目标工程 278 → 278（移除 0 / 新增 0）——
    探针确认 `c-parser/c99.lua:66` 的 `decl.ids[1].decl` 已从「未定义」变成 `any`，
    但那条 FP 的外层成因是 `decl.ids[1]` 被写成 `false | nil`（真值收窄的 **falsy 降解**）：
    `if A and B and C` 链里后面的操作数继承了前面的 falsy
  - 已做（2026-09-24，openspec change `falsy-degradation-leak`）：falsy 降解经由
    `and` 的「另一侧事实」漏键泄漏给后续操作数，已在 F16 修掉 → `c-parser/c99.lua:66` 消失
  - 遗留（候选，未验证）：`or` 的 `current` 合并只并「两侧都有的键」（`W:traceOr`），
    在「追踪 `or` 为假」的合取方向同样会漏键，形状是 `if not (A or B or C)`
    （`(A or B) or C` 的嵌套左侧）——需要先构造目标工程实例再决定动不动

## F6 `type(x) == 'string'` 一族的收窄依赖 F2 的反推，不能一刀切
- 断言：实参自己**没有**类型（`any`/`unknown`）时，反推是该族收窄的唯一来源，必须保留
- 证据：test/coder/flow.lua（`--!include type` 的两组用例：未注解 `local x`、`string|number|boolean`）
- 状态：成立（作为 F2 的边界条件；2026-09-21 实测：全局弃用反推会挂测试）

## F7 判等收窄只在单值比较上成立（多值比较不产生 `never`）
- 断言：比较值是单值类型（字面量、`nil`、`never`）时判等才收窄；比较值是**多值**类型
  （`any`、`unknown`、同类型变量、类/表/基础类型）时，两个分支都保持原类型
- 证据：test/node/narrow.lua（4 例：`any == any`、`string == any`、`string == unknown`、`string == string`、
  `value(1) == number`、联合体）；test/coder/flow.lua（`字段 == any` 的 auto-require 形状 + 6 例多值比较）；
  目标工程 `script/core/completion/auto-require.lua:106` 的 `Undefined field 'match'` 消失
- 代码：`Node:isMultiValue`（`script/node/node.lua`）；`script/node/{type,value,union}.lua` 的 `narrowEqual`；
  `script/node/tracer.lua` `W:traceByValue` 入口守卫（比较值为多值时连向上反推都跳过）
  - `type.lua` 的身份短路（`self == other → (self, NEVER)`）必须排在多值守卫与 `any`/`unknown` 反推分支**之后**，
    否则 `any == any` 先命中短路，另一侧又被写成 `never`
  - `narrowByField` **不加**同样的守卫：会打断 `if x.a then x is A else x is B` 的字段筛选（test/coder/flow.lua:234 挂）
- 参照：TS 实测（`tmp/ts-narrow.ts`、`tmp/ts-narrow2.ts`）——`string === any`、`'x' === string`、`{a} === {a}`
  都不收窄，`'x' === 'y'` 才收窄（true 支 `never` / else 支 `"x"`）
- 数字：目标工程诊断基线 376 → 372（移除 7 / 新增 3）
- 新增 3 处（待分诊，先前靠 `never` 压住）：`core/diagnostics/missing-return-value.lua:30/31`
  （`ret` 推成 `parser.object[] | nil`，循环变量元素类型精度问题）、`vm/node.lua:309`
  （`c.name` 为 `'' | parser.object | string | nil`，与 `vm.isSubType` 形参不兼容）
- 状态：成立（2026-09-23）

## F8 `narrowByField` 的「字段能否等于比较值」判据：单值比较不排除基值
- 断言：`x.key == 字面量/nil` 时，若字段的取值域只是**包含**该值（`字段: string` 对 `'x'`）
  或字段值**不可知**（`字段: any`），则两侧都保持原样；只有字段域被该值覆盖（`字段: 'x'` 对 `'x'`）
  或字段域与该值不相交时才做二选一
- 证据：test/node/narrow.lua（宽字段 → 两侧 self；`any` 字段 → 两侧 self；同值 → `(self, NEVER)`；
  不相交 → `(NEVER, self)`；联合体成员拆分）；test/coder/flow.lua（`{ type: string }` 基值在相等一侧保持）；
  目标工程 `vm/compiler.lua:174/181/945/956`、`vm/node.lua:309/351`、`vm/compiler.lua:1687` 的误报消失
- 代码：`script/node/node.lua` `M:narrowByField`（新增「单值域内」「字段为多值」两条判据）；
  `script/node/union.lua` `M:narrowByField`（同样判据；`Node.Key` 允许字面量，入口先规范化成节点）
- 与 F3 的关系：F3 试的「两向 canCast 任一成立就都算可能」被否掉（全局真值收窄回归）；
  本条的判据多了「比较值是单值」这一层限制，因此不影响真值过滤（真值路径传进来的 `value` 是类型，走原逻辑）
- 数字：目标工程 372 → 367（移除 7 / 新增 2）；对最初基线 376 → 367（移除 13 / 新增 4）
- 新增 2 处（待分诊）：`core/hover/label.lua:36`（`doc.extends` 注解为 `parser.object[] | parser.object`）、
  `vm/function.lua:444`（F3 已记）
- 试过（2026-09-23，未采用）：把 `type.lua:narrowEqual` 的单值比较也收窄到字面量
  （`string == 'x'` → true 支 `'x'`，对齐 TS）。372 → 370（移除 8 / 新增 6），
  新增的 4 条是宽字段成员进入 narrowed 后的 `Undefined field`（`vm/node.lua:190/228`、`vm/function.lua:37`、
  `vm/tracer.lua:103`），净收益反而更小；且该方向与 F8 的联合体判据耦合，先不落地
- 试过（2026-09-23，未采用）：联合体里让「字段可能相等」的成员**同时**留在其它侧
  （语义上更保守：既不排除 narrowed 也不排除 else）。367 → 372，新增 5 条
  （`core/semantic-tokens.lua:195/212/222` 的 `Undefined field` / `Need check nil`：
  宽字段成员留在 else 侧后被继续读字段）。故联合体只把成员放进 narrowed
- 状态：成立（2026-09-23）

## F9 动态键读取（`t[expr]`）按基值求值，不读共用槽位
- 断言：`t[expr]`（键解析不出字面量）的读值按**基值**求未知键：Array → 元素、List → rest 元素、
  其它 → `get(unknownkey)`；不再采用共用槽位（`t[unknown]`）上被别的动态键读写/真值收窄污染过的流值。
  槽位上有本文件的动态键写入（`t[expr] = v` / `t[expr].f = v`）时仍以写入为准（`test/coder/common.lua` 钉着）
- 证据：test/coder/flow.lua（`arr[i]` → `integer`、`arr[1]` → `integer`、`optArr[i]` → `integer | nil`、
  类字段链 `lines[i]` → `integer`）；目标工程 376 → 359（移除 29 / 新增 12），
  `parser/compile.lua:712/715/718/2556/2863/2886/2921/3960/3961/4113/4583/4703/4785/4820`
  的 `getPosition(Tokens[Index], 'left'/'right')` 一族误报消失
- 代码：`Node.Variable:getDynamicKeyValue`（`script/node/variable.lua`），接入 `getStaticValue` 与 `value` getter
- 未满足（open）：目标工程 `core/completion/completion.lua:270` 仍是 `integer | nil`。
  该链的 parent 落在 master 变量上（注解链 `state: parser.state?` → `state.lines` = `integer[] | nil`），
  收窄后的值只在 read-site shadow 上，`getDynamicKeyValue` 取不到；
  下一步：找出 `getChild`/`childs` 解析到 master 的原因，或让读值优先取 read-site 值
- 新增 12 处（待分诊）：`parser/luadoc.lua:753/754/755(x2)/756/757`（`content:sub` 一族 Need check nil，
  该处 `---@return string` 但动态读值现在推成 `string | nil`）、`vm/function.lua:326`、`vm/sign.lua:274`，
  以及 F3/F7/F8 已记的 `vm/function.lua:444`、`hover/label.lua:36`、`missing-return-value.lua:30/31`
- 状态：部分满足（动态键读取这一半已落地；「用收窄后的基值而非注解基值」这一半仍未立）

## F10 动态键写入只标记「开放结构」，不用写入值做读取推断
- 断言：`Table:get(unknownkey)` 返回 `any`（不做值推断）；写入记录仍保留 →
  `hasDynamicKey` 为真、具名字段读取仍不报未定义字段；`T[XXX] = 1` 不再让 `T[YYY]` 读到 `1`
- 证据：test/coder/flow.lua（`T[x] = 1; T[y]` → `any`）；test/node/get.lua、test/coder/common.lua
  （结构视图 `{ [unknownkey]: ... }` 与变量链读取不受影响）；目标工程 376 → **342**（移除 44 / 新增 10）
- 代码：`script/node/table.lua` `M:get` 的 `unknownkey` 分支
- 试过（未采用）：
  - **写入端不记录**（`state.lua` `compileAssign` 键解析不出时 `return`）：376 → 355，但 `hasDynamicKey` 随之失效，
    回来 8 条 `Undefined field`（`await.lua:60`、`completion.lua:1065/1068`、`provider.lua:1663/1664`、
    `pub.lua:149`、`string-merger.lua:67-72`、`doctor.lua:572`）
  - **写入端记录 `[unknownkey] = ANY`**：376 → 358，那批 `Undefined field` 依旧在
  - **coder 端给基值打开放结构标记**（`Variable:setTableLike` + 写侧 `{base}:setTableLike()`）：
    写入目标的基值 key 在 `coder.map` 里查不到（`No such key: var:self@...`），显式 `coder:compile(base)`
    又会 `Source already compiled: var` —— 要先摸清 coder 的注册/prelude 时序，性价比不如读侧改法
- 新增 4 处（待分诊）：`parser/luadoc.lua:2223`（`old = docs[param1]` 动态读，`old.virtual` 报
  Need check nil / Undefined field）、`utility.lua:857`、`vm/global.lua:74`（返回类型注解不符）
- 状态：成立（2026-09-23）

## F11 动态键/字段链读值仍在用「注解基值」而不是「收窄后的基值」（评估：暂缓）
- 断言（未满足）：`local lines = state.lines` 这类链，`state` 已被 `if not state then ... end` 收窄，
  但字段读的静态链仍取注解的 `parser.state?` → `state.lines` = `integer[] | nil` → 元素/动态键读带上 nil
  （目标工程 `core/completion/completion.lua:270` 的 `Cannot assign 'integer | nil' to 'integer'` 即此）
- 机制（探针实测）：动态键子变量（`t[unknownkey]`）的 parent 解析到 **master 变量**（`getChild` 走
  master 的 `childs`），所以收窄后的值（只在 read-site shadow 上）在这一层取不到；
  `getStaticValue` → `getExpectValue`/`getGuessValue` → `parentFieldValue` 于是给出注解链的 `| nil`
- 试过（2026-09-23，均未采用，测试全绿但那条无效/卡住）：
  - `var.lua` 给非字面量 index 登记 `parentMap = { base, rt.UNKNOWNKEY }`，想让 tracer 的
    `deriveFieldValue` 按基值当前值求：这条对我写的 `t[expr]` 形状有效（F9 已覆盖），但对
    `completion.lua:270` 无效 —— `deriveFieldValue` 里 `self:getValue(基值 id)` 为空（基值只写了节点
    `currentValue`，没进 tracer 的 id 值表）
  - coder 端 `{base}:setTableLike()` 标记：写入目标的基值 key 不在 `coder.map`
    （`No such key: var:self@...`），补 `coder:compile(base)` 又 `Source already compiled: var`
- 评估（2026-09-23）：单独为这条深入**不值** —— 收益 1 条，而可行修点都指向
  「变量身份/master-shadow 解析」或「tracer 派生顺序」这类核心路径，回归面覆盖所有字段读；
  建议等下次因别的原因必须动 tracer 派生时一并处理
- 状态：未满足（open，已记评估结论，不要重走上述两条）

## F12 动态键读取的 tracer 值也按基值求（不取共用槽位的流值）
- 断言：`t[expr]` 读取在 tracer 里的值 = `Node.Variable:getDynamicKeyValue()` 的结果
  （Array → 元素、List → rest 元素、其它 → `get(unknownkey)`），不再采用共用槽位上的流值
- 证据：test/coder/flow.lua（`if arr[i] then X = arr[i] end` → `integer`，此前是 `integer | truthy`；
  `arr[i]` → `integer`；`op.*` 仍可 cast 到 integer/number）
- 代码：`script/node/tracer.lua` `W:traceRef` 的 `isDynamicKeyRef` 分支
- 数字：目标工程 342 不变（收益体现在读值不再被其它动态键的真值收窄污染）
- 状态：成立（2026-09-23）

## F13 目标工程 `parser/compile.lua` 的 `Chunk[i]` 一族（约 35 条，下一步高价值目标）
- 现象：`local chunk = Chunk[i]` 之后 `chunk.locals` / `chunk.globals` / `chunk.type` 等报未定义字段
  （`compile.lua:761/820/848/864/898/919/2522/2525/3761-3764/4145-4159/4252-4288/4863-4883`）
- 探针（2026-09-23）：读取节点 `field@761:24-761:35` 的 view 已是 `any` ✓，但同处的局部变量
  `var:chunk@761:24-761:28` 的 `rawCurrent`（tracer 写入）仍是**动态键写入记录里的那张表**
  （字段 `breaks/gotos/hasBreak/hasExit/hasGoTo/hasReturn/returns/vararg`，与 `Chunk[#Chunk+1] = {...}`
  写进去的字面量一致）→ 缺 `locals/globals/type` → 报未定义字段
- 已知：F12 的 override 打点里没看到该读取的 id（只看到 `locals@761:15[unknown]`、`Tokens@238:44[unknown]` 等），
  即要么它不是 UNKNOWNKEY 槽位（键来自 `#Chunk+1` 这类表达式节点），要么 `getDynamicKeyValue` 返回 nil；
  局部变量的值走静态合并链（`equivalentValue`），绕过了 F9/F12 的读侧修正
- 下一步：查 `local chunk = Chunk[i]` 的值为何取到「表达式键写入记录」的字段值
- **定位（2026-09-23 补充）**：就是 `Node.Variable:getDynamicKeyValue` 里那条前置守卫
  （「槽位上有本文件的动态键写入（`assignValue`/`childsValue`/`fields`）时以写入为准，不派生」）。
  去掉守卫后 `Chunk[i]` 走派生值（`Table:get(unknownkey)` → `any`，F10）✓，`compile.lua` 那簇 48 条消失
- **试过（2026-09-23，未落地，待决策）**：去掉守卫，并把字段链基值从
  `parent:getCurrentValue()/getStaticValue()` 扩到 `parent.value` → 目标工程 334 → **307**
  （移除 93 / 新增 24）。代价：
  - 新增 11 条在 `files.lua:232-244`：`local file = m.fileMap[uri]` 之后 `file` 被推成 `false | nil` ——
    真值收窄的 falsy 标记（`any.falsy = false | nil`，F5）泄漏成读值；
    加上共享槽位，让「写入后同键读取」不再可见（`if not m.fileMap[uri] then ...写入... end` 之后读不到那张表）
  - 新增 3 条 `tools/lua51.lua:201-203`；`test/coder/common.lua:42-44` 的旧钉
    （`{ [unknownkey]: { C: 1 } }` / `A[unknownkey].C` = 1）要改
- **决策点（留给用户）**：A. 保留守卫（334：`write → 同键 read` 可见，但共享槽位污染 compile.lua 那簇）；
  B. 去掉守卫（307：与 F10「动态键只标记结构、不做值传播」一致，但 falsy 标记泄漏的 11 条要配 F5 一起修）
- **落地（2026-09-23 第七轮，用户选 B）**：去掉守卫 + 字段链基值补 `parent.value`；并把 `Variable:get`
  也接到派生值（视图与字段读一致）。目标工程 307（移除 93 / 新增 24）
- 状态：成立（2026-09-23）

## F14 `and`/`or`/`==`/`~=` 的操作数边界由 coder 标记（基值不再被当操作数收窄）
- 断言：这些复合节点的子节点是「左组…, '|', 右组…」，每组最后一个子节点才是操作数
  （前面是它自己的路径 ref）；tracer 按标记切分，只把操作数当条件/比较值、其余按 ref 追踪
- 证据：test/coder/*、test/feature/diagnostic/*（全量绿）；test/node/tracer.lua 的手工 flow（无标记）
  走回退读法且仍保留中间 ref；目标工程 `files.lua:222` 的基值不再被收成 `false | nil`、
  `cli/doc/export.lua:75/79` 的 `a.name ~= b.name` 不再把 `b` 当比较值收窄
- 代码：`script/vm/coder/tracer.lua` `T:markOperand`；`script/vm/coder/exp.lua` 的 binary provider
  （`and`/`or`/`==`/`~=`）；`script/node/tracer.lua` 的 `splitLogicOperands`（无标记时回退到
  「最后两个子节点 + 其余为副作用 ref」的旧读法）+ `W:traceAnd`/`W:traceOr`/`traceConditionUnit` 的 `==`/`~=` 分支
- 试过（2026-09-23，未采用）：在 tracer 里靠「前两个子节点是否都是 ref」猜操作数边界 ——
  335→295 但新增 26 条（`cli/doc/export.lua`、`vm/compiler.lua:272` 等），不如标记法（282 / 新增 13）
- 数字：目标工程 334（B 之前）→ 307（B）→ 286（and/or 标记）→ **282**（比较运算也标记）
- 状态：成立（2026-09-23）

## F15 以 `error(...)` 结尾的分支不算终止（`error` 没有 `never` 返回标注）
- 断言（未满足）：`if not x then error('…') end` 之后 `x` 应当非 nil；当前 `error` 在我们的
  meta 与目标工程的 meta 里都只写着 `function error(message, level) end`（无 `never`），
  该分支不计终止 → 合并后仍带 nil
- 证据：目标工程 `tools/lua51.lua:201/202/203`（`mod._M = mod` 等三条 `Need check nil`，
  `mod` = `table | nil`；`findTable` 补注解后从 `... | nil` 收敛到 `table | nil`）
- 代码：`meta/whimsical/basic.lua` 与 `meta/<版本>/basic.lua` 的 `error`（数据层）；
  tracer 侧终止判定见 F1（goto/break/return 一族）
- 未落地原因：改 meta 会影响所有 `error(...)` 守卫的收窄（量级大，需单独一轮基线比对）；
  引擎侧维护「永不返回」内建清单更 hack。先记录取舍
- **实测（2026-09-24，不采用，见 openspec change `error-never-return`）**：
  - 做法 A（`meta/template/basic.lua` + `meta/whimsical/basic.lua` 给 `error` 加 `---@return never`）：
    目标工程 278 → 278（移除 0 / 新增 0）——**惰性**：分支终止只看 `block.exits`（goto/break/continue）这类语法信息
  - 做法 A + B′（`script/node/tracer.lua` 新增 `traceCallStatement`：语句级调用返回 `never` ⇒ 该分支不落地；
    `traceIfChild` 的 `terminated` 改成 `terminated or stack.terminated` 保留它）：278 → **281**
    （移除 1 / 新增 4），净变差；新增的 4 条都在 `parser/compile.lua`（本该非 nil 的值变回 `... | nil`）。
    而且目标工程自己的 meta 里 `error` 没有 `never`，会盖住我们的注解，`tools/lua51.lua:201-203` 并未修掉
  - 已全部回退（`git checkout -- meta script/node/tracer.lua`），目标工程回到 278
  - 结论：先不做；将来要做需同时解决「目标工程 meta 覆盖」，并先在 `test/` 里钉出「`never` 调用终止」的回归
- 状态：未满足（open，含两次实测结论，不要重走）

## F16 `and` 的「另一侧事实」必须覆盖单侧独有的键（合取方向）
- 断言：`and` 节点向外暴露的 `otherSide`（另一分支的事实）在**另一侧是合取**时 —— 即追踪
  `and` 为假、另一侧 = 「A 且 B 为真」—— 必须把两侧操作数各自贡献的键都带上；
  只有「另一侧是析取」（追踪 `and` 为真，另一侧 = 「A 假 或 A 真且 B 假」）时才只并共有键
  （单侧键在另一分支未必成立，采纳会过度收窄：`if x and y` 的 else 里 x 会从 `string | nil` 变成 `nil`）
- 证据：test/node/tracer.lua（新增「`(A and B) and C` 里 C 读 B 为真」一例：`x.a.b3` 必须是
  `truthy`，撤掉修复即为 `false | nil`；同文件既有的 `if x and y` / `if x or y` 一族的 else 读值钉住析取方向）；
  目标工程 `script/plugins/ffi/c-parser/c99.lua:66` 的 `Undefined field 'decl'` 消失
- 代码：`script/node/tracer.lua` `W:traceAnd` 末尾的 `otherSide` 合并（`seedValue == stack1.otherSide`
  即种子取自 stack1 的另一侧 ⇒ 合取方向；析取方向保持原来的「共有键 `|` 并集」）
- 机制：嵌套左侧（`(A and B)` 是外层 `and` 的左操作数）的 `B` 的真值事实只出现在**内层** `stack2.otherSide`，
  原来的「只并两侧都有的键」把它丢掉 → 外层 seed 没有 `B` → 右操作数 `C` 读 `B` 时穿透到
  `stack1.current` 的假值降解（`any.falsy` = `false | nil`）→ 对 `B` 取字段报未定义字段
- 数字：目标工程 278 → **277**（移除 1 / 新增 0），全量 `--test` 绿
- 状态：成立（2026-09-24）

## F17 终止分支的 guard 事实会盖掉存活分支的赋值（未满足）
- 断言（未满足）：`W:traceIf` 把终止分支（`return` / `goto` / `break` / `continue`）的 `otherSide`
  当作 fall-through 事实合并（F1 的 guard 收窄机制所需），但该 `otherSide` 是在**分支体跑完之后**
  读的，会带上分支体内嵌套收窄写入的键；存活分支已给同一键赋值时，两值并在一起就把**标记**混成读值
- 证据（目标工程）：`script/vm/value.lua:176/200/223` 的 `return-type-mismatch` 读值是
  `false | parser.object | any | nil`——`if result then return nil else result = n[1] end` 里
  `result` 的假值事实（`any.falsy` = `false | nil`）与 else 分支的赋值合并（`vm/getString` 一族）
- 代码：`script/node/tracer.lua` `W:traceIf` 的合并循环；相关 `W:traceIfChild`（分支栈的 `current`/`otherSide`）
- 试过（2026-09-24，见 openspec change `ifguard-assigned-skip`，**不采用已回退**）：
  先收集存活分支（含 `changed`），再把终止分支的 `otherSide` 按「未被存活分支赋值的键」补进来 ——
  目标工程 278 → **279**（移除 1 / 新增 2，净 +2 且零移除）：
  - 收益：`vm/value.lua:176/200/223` 的读值里 `false` 消失（诊断本身没消失，`parser.object` 仍不可 cast 到 `string`）
  - 代价：`vm/type.lua:529/562` 新增 `Cannot assign 'table | nil' to parameter 'table'`——
    `mark = mark or {}` 的收窄丢失（读值退回注解 `table?`），且 `var:uri@396`、`var:errs@394/397/398/399`、
    `var:n@493`、`var:child@498`、`field@399`、`unary@397/398/399` 一簇变成 **`never`**（读值污染）
  - 机制未查清：`W:traceIf` 末尾 `union[#union+1] = stack.current[id]` 在值为 `nil` 时留下数组空洞，
    `rt.union` 见此走 `#nodes == 0 ⇒ NEVER`（`script/node/runtime.lua:243`）
- 状态：未满足（open；重走前置条件：先查清 `never` 簇，或改从**标记的生产侧**
  `narrowEqual` / `narrowByField` 入手，让标记不进读值）- 同族线索（未修）：`parser/compile.lua:2263` 一族的 `assign-type-mismatch` 里出现
  `type: never`、`args: { [1]: never }`、`finish: … | truthy | …`；`vm/compiler.lua:346` 的
  `return { … type: never … }`；`vm/function.lua:444`、`vm/global.lua:74`、`utility.lua:857`

## F18 多值类型与单值比较：相等侧是那个单值（不是 `never`），不等侧保留多值成员
- 断言：`---@type string` 的 `x` 与 `'a'` 判等，相等侧是 `'a'`（交集），不相容才是不可能；
  联合体 `'generic' | string` 与 `'doc.field'` 判等，相等侧是 `'doc.field'`、不等侧保留
  `'generic' | string`（多值成员去掉一个字面量后还有别的取值，不能整块排除）。
  另外 `x.key ~= 值` 的**不等于**方向不得按字段把 `x` 收窄成「缺 `key` 的成员」
- 证据：test/node/narrow.lua（多值类型与单值比较 3 组：`string` 对字面量、不相容、
  联合体不等侧）；test/node/tracer.lua（成员缺字段时 `~=` 反推不写回：去掉判断即退回 `never`）；
  目标工程 `vm/vm.lua:75:41` 的 `parser.object | nil` 实参误报消失，
  `vm/compiler.lua:346` 返回表里的 `type: never` 变成 `type: string`
- 代码：`script/node/type.lua` `M:narrowEqual`（尾部相容判定）、`script/node/union.lua`
  `M:narrowEqual`（相等侧取成员收窄结果、不等侧按 `isMultiValue` 保留）、
  `script/node/tracer.lua` `W:traceByValue`（`isFieldReadable`）
- 机制：原来多值类型与单值比较一律 `return rt.NEVER, self`，`never` 随即作为读值
  写进流并向上反推（`if field.type ~= 'doc.field' … return nil end` 之后 `field.type` 是 `never`）
- 数字：目标工程 278 → **276**（移除 2 / 新增 0；本轮净 −1，诊断消息里的 `type: never` 9 → 8 处）
- 状态：成立（2026-09-24）
- 试过但未采用（见 openspec change `narrow-multi-value-equality`）：
  只改联合体成员分类（`never` 仍在）／相等侧整块留下多值成员（新增 `vm/compiler.lua:945/956`、
  `vm/type.lua:886`）／`isFieldReadable` 对两个方向都生效（多移除 4 条但新增 3 条值质量回归）

## F19 守卫收窄 + 循环内重赋值：循环体里的读值退回未收窄的 guess（未满足）
- 断言（未满足）：`if not exp then return nil end` 之类的守卫之后，`exp` 在**循环体**里的读值
  应当只含非 nil 的取值；现在会退化回 `guess`（含 nil）⇒ 误报 `need-check-nil`
- 证据（仓库内最小复现）：
  - `test/project/repro/guard-loop-reassign.lua` —— 复现（去掉文件里的
    `---@diagnostic disable-next-line: need-check-nil` 即见误报）：
    守卫 + `while true do …… exp = bin end`（循环内重赋值）+ 循环体内读 `exp.start`
  - `test/project/repro/guard-loop-noreassign.lua`（循环内不重赋值）与
    `test/project/repro/guard-noloop.lua`（无循环）都是**对照组：不报**
    ⇒ 诱因是「循环内重赋值 + 循环体内的读」这一步
  - 目标工程同族：`script/parser/compile.lua` 的 29 条 `need-check-nil`
    （`local child = parseExp()` + `if child then … child.start`，`parseExp` 是无 `---@return` 注解的递归局部函数）
- 机制（诊断 pass 里的临时打印，已回退）：
  - 诊断侧读到的是 `guess`（推断值，union 里带 nil 成员）；`Variable.tracer` 非空、`walker.started=true`、
    但 `currentValue = nil` ⇒ 收窄值没写进来（或写进来后被清掉）
  - 同一文件在 **probe 方式**下（不跑诊断 provider）读值是正确的、已收窄的
    ⇒ 与「walk 在哪个时机跑过、之后没有再跑」有关（`Walker.started` 会一直挡住重跑）
  - `Node.Tracer.Walker` 是 `__getter.walker` 缓存字段：一次 flush 会把它整个丢掉、下次读时**新建**
    ⇒ 「flush 之后不重算」只在没新建 walker 的路径上成立，这解释了为什么两种时机结果不同
- 代码：`script/node/tracer.lua`（`M:trace` / `W:start` / `Variable.__getter.value`）、
  `script/node/variable.lua`（`setCurrentValue` / `currentValue` 随 `class.flush` 失效）、
  `script/node/runtime.lua`（`flushCacheNow` / `cacheLocked`）
- 试过（2026-09-24，见 openspec change `tracer-flush-retrace` 与 `guard-loop-reassign`，**均不采用已回退**）：
  1. `flushCacheNow` 里「清掉 raw currentValue 就 +1 代数」+ `M:trace` 按代数重跑 ——
     目标工程 276 → 276；最小复现仍报（约 0.02s 的小工程，2 条 → 2 条）
  2. ①放宽成「每次 flush 批次都 +1 代数」—— 最小复现**修好了**（2 → 1 条），
     但目标工程扫描 **C 栈溢出**（`variable.lua:1001` ← `fcall` ← `value` 递归 2129 层）：
     walk 会触发 flush、flush 又推进代数 ⇒ 嵌套 walk 链爆炸
  3. `Function:addReturnDef` / `addReturnList` 里 `flushCache()` —— 276 → 276（那一族另有成因）
- 状态：未满足（open）。下一步：把「重跑」的触发条件收敛成**编译结束后的一个信号**
  （节点图在中间码执行期间仍在增长，所以「早期 walk 结果不完整」才是本因），
  并且重跑必须能防住「walk → flush → 代数推进 → 再 walk」的正反馈（例如只在
  「读到的值为空」时重跑、或对 walker 做版本化后按需重建）

## F20 动态键标记（`unknownkey`）作为读值时字段读取恒 `any`
- 断言：读值恰为 `unknownkey` 时，字段读取按 `any` 处理（不报「未定义字段」）。
  典型来源：`for k in pairs(t)` 的键——表被动态键写过（`t[expr] = v`）时，键的类型就是 `unknownkey`
- 证据：test/node/get.lua（`rt.UNKNOWNKEY:get('anyField')` = `any`；去掉修复立刻退回 `never`）；
  目标工程 `service/service.lua:104`（`for cache in pairs(vm.cacheTracker) … cache.dead`）、
  `test/parser_test/perform/init.lua:42`（`path:string()`）两条误报消失
- 代码：`script/node/runtime.lua` 里给 `UNKNOWNKEY` 挂 `anykv`（「任意字段 → any」的类，
  与 ANY / UNKNOWN / PROVISIONAL / TRUTHY 一致）。**不要**改在 `Type:get` 里加特判（重复机制）
- 机制：`unknownkey` 与 `provisional` 的 `onCanCast` / `onCanBeCast` 配置本是一对，
  但只有 `provisional` 挂了 `anykv` ⇒ 前者字段读取走空的继承表返回 `never`
- 数字：目标工程 276 → **274**（移除 2 / 新增 0）
- 状态：成立（2026-09-24）

## F21 `if` 分支里的赋值没有与「条件不成立」那条路的值合并（未满足）

- 断言（未满足）：`if cond then v = X end` 之后读 `v`，值应当是**两条路**的并集
  （`旧值 | X`）；现在只剩 `X`（分支里的赋值把旧值顶掉了）——于是旧值才有的字段读被报
  「未定义字段」
- 证据（仓库内最小复现）：`test/project/repro/branch-assign-merge.lua`
  （去掉文件里的 `---@diagnostic disable-next-line: undefined-field` 即见
  `return c.a | Undefined field a`：`c` 只剩分支里赋的 `reproQ`）；
  `W:traceIf` 的合并循环只并各分支栈的值，没有把「不走本分支」那条路的值算进去
- 目标工程同族：`script/vm/operator.lua:157`（`if c.type == 'string' ... then c = vm.declareGlobal(...) end`
  之后读 `c.node`：`c` 变成类 `vm.global`，丢掉循环变量 `parser.object` 上的 `node` 字段）
- 代码：`script/node/tracer.lua`（`W:traceIf` 的 stacks / otherSide 合并、`W:traceIfChild` 的
  `otherSide` 播种、`W:traceVar` 写 `stack.current`）
- 试过（2026-09-28，**均不采用已回退**，基线 270）：
  1. 合并时把「不走分支」那条路也算上，该路的值取**条件反面的收窄结果**（`otherSide[id]`），
     没有就用变量在外层的值（新增 `W:getOuterValue`：收窄栈 → 变量注解值）——
     目标工程 **270 → 291**（移除 0 / 新增 21）：`operator.lua:157` 没修掉
     （那条路的 `otherSide` 里 `c` 是 `never`，并进并集等于没加），却多出 21 条
     （`need-check-nil` / `param-type-mismatch`，都是「`error` 不是 `never` 时条件不成立那条路
     真的可能走到」⇒ F15 一族被顺带解开）
  2. 同 1，但那条路的值**优先取外层旧值**（不用 `otherSide`）——目标工程 **270 → 309**
     （移除 1 / 新增 40）：`operator.lua:157` 修掉了，但新增里包含
     `cli/doc/export.lua` 的 `has_seen` 一族（`if not has_seen then has_seen = {} end`），
     等于把「条件反面已经排除的东西」又放宽回去
  3. 同 1，并把会被放宽的 id 收紧成**分支里真正被赋值**的 id（给 `Stack` 加 `assigned`）——
     目标工程 **270 → 289**（移除 0 / 新增 19）
  ⇒ 三次都是净变差：这条语义改动本身是对的，但会把 F15（`error` 没有 `never` 返回语义）
  一族一起解开，而那族的收敛方向（2026-09-24 受控测量）当时也是净变差 —— 两件事要一起做
- 观测（下次的入口）：
  - `otherSide` 里可能存着 `never`（`---@field a integer` + `if v.a then` 的反面：`v` = `never`，
    那条路语义上确实不可能；但目标工程 `operator.lua` 那条条件的反面不该是 `never`）
    ⇒ 「按字段判等收窄基值」仍有不健全的分支
  - 同一次调试里 `sval.view()` 抛过 `view.lua:61: table index is nil`（节点 view 崩），
    换个时序又正常 —— 与 F19 / `returns.md` F2 的「同一节点不同时机取值不同」同族
- 状态：未满足（open）

## F22 动态键读取（`t[expr]`）的元素推导不掺基值里的「恒假」成员

- 断言：`t[expr]`（键不可静态解析）的读值按基值求；基值联合体里**恒假**的成员
  （`nil` / `false`，运行期不能被索引）不参与元素推导：
  `integer[] | nil` 的动态键读值应是 `integer`，不是 `integer | nil`。
  基值本身可能为 nil 这件事由读点上基值的 flow 值负责（那里是收窄后的值），不在这里补。
- 证据（仓库内最小复现）：`test/project/repro/array-index-nil.lua`
  （`local state = getState()` + `if not state then return 0 end` + `local lines = state.lines`
  + `lines[firstRow]`：修前 `integer | nil` 报 param-type-mismatch，修后 0 诊断）；
  目标工程 `script/core/completion/completion.lua:270`（`text:sub(lines[firstRow], lastOffset)`）同族
- 代码：`script/node/variable.lua` `Variable:getDynamicKeyValue`（循环里对
  `base:simplify()` 的结果先过 `dropFalsyMembers`：按 `v.truthy ~= NEVER` 过滤，
  全被滤掉或没滤掉就原样返回）
- 数字：目标工程 270 → **260**（移除 10 / 新增 0）
  —— `completion.lua:270`、`parser/guide.lua:817`、`vm/compiler.lua:758 / 873 / 1345 / 1378 / 1447 / 1485`、
  `vm/global.lua:74`、`vm/sign.lua:274`（都是 `数组[i]` 的读值里掺了「基值可选」那层 nil）
- 机制：`getDynamicKeyValue` 的基值来自**槽位**（`parent:getCurrentValue()` 会被 flush 清掉，
  退回 `getStaticValue()` = 未收窄的旧值，如 `T[] | nil`）而非读点的 flow 值；
  `Union:get(unknownkey)` 会把这层 nil 计入结果
- 试过（2026-09-28，**不采用**）：
  1. 在 `traceRef` 的动态键分支里改用**基值的 flow 值**（给 `getDynamicKeyValue` 加
     `baseOverride`，并靠 `nodeID[baseNode]` 找基值 id）—— 拿不到：动态键子变量是在
     `getChild` 里**转发到值链上的变量**（`parent` 是 `currentValue/staticValue` 那个变量，
     不在 flow 里），`nodeID` 查不到 ⇒ baseID = nil，行为不变
  2. 给动态键读也登记 `parentMap`（让 walker 走 `deriveFieldValue` 从基值 flow 值派生）——
     需要 coder 侧配合（键不是字面量、且 `parentMap` 值是纯数据才不破坏 worker 边界），
     未做；1 已经 0/0 说明这条路不是必需
- 边界（别改回去）：
  - 只滤**恒假**成员：元素类型自身若含 nil（`(integer|nil)[]`）不受影响
  - 基值恒假（全被滤掉）时不改原样，走原来的「取不到元素」路径
  - 这条**没有测试 harness 的回归钉**：`TEST_DIAGNOSTIC`（feature 侧）与节点级构造都不复现
    （同一形状在 harness 里 `Union:get` 不掺 nil，在目标工程/复现文件里掺）
    ⇒ 回归以 `test/project/repro/array-index-nil.lua` + 目标基线比对为准
- 状态：成立（2026-09-28；目标 270 → 260，移除 10 / 新增 0）
