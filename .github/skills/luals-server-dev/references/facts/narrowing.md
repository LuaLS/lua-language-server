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
- 状态：未满足（open）
