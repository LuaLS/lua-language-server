# 设计备忘与未决记录

## 设计结论备忘

- LuaCats 的 `...X` 与 Lua 5.5 的 `...name` 是**两层**含义，保持现状、不做统一：
  - LuaCats（注解层）：`... X` = 不定长元素类型；`...X` = 隐式泛型 pack 绑定（`cats/param.lua`）；
    `---@return ...R` = 解包多值。X 是**类型名**（泛型），描述的是"值"，本身不产生表。
  - Lua 5.5（语法层）：`function f(...args)` 里 `args` 是**变量**，绑定一张 pack 表（整数键 + `n`），
    由 coder 自动补 `{ n: integer }`（`script/vm/coder/function.lua`）。
- "返回一张带 `n` 的表"（如 `table.pack`）用表类型表达即可：`T & { n: integer }`
  （`test/node/pack.lua` 已钉住 `intersection{tuple, {n}}` 的行为）。因此 `table.pack` 的元声明无需改动。
- **内联 `fun` 的返回值边界**（`parser/ast/cats/function.lua`）：默认把 `,` 让给上一层，**自己要多返回值就加括号**。
  1. **spread 只能是最后一项**：裸 `...`（原先会退化成名为 `...` 的普通返回值）与 `:...R` 都让返回值列表就地结束，
     其后的 `,` 归外层。语义上 `return ...` 之后不可能再有返回值，这条不需要上下文判断。
  2. **列表项的类型值里，无括号返回值列表只取一项**：形参/返回值/表字段的类型值走 `parseCatListValue`
     （`Ast.catInListValue`）→ `parseCatReturnList(noComma)`；`fun(): (a, b)` 这类**带括号**的仍然是贪婪的
     （括号即显式终点，这就是「要多返回值就加括号」）。
  3. **逗号还给外层**：`, ` 之后解析不出返回值时恢复 `lexer.ci`，不静默吞掉分隔符。
  不受影响的既有写法：`---@type fun(): boolean, number` 保持贪婪（`---@type` 的项不走 `parseCatListValue`，
  由 `test/coder/metatable.lua` 钉住）；多行续行 `---@type fun<...>(a: T1, ...: T2)` + `---, desc: string`
  也不受影响（顶层 fun 不在列表项位置，由 `test/parser/ast/cat.lua` 钉住；具名返回值在 `fun` 返回列表里合法）。

## 已知未决

- **泛型 for 的循环变量在部分时机退回「列表值」**（`facts/returns.md` F3，2026-09-28 新记）：
  `for _, ret in ipairs(returns)` 里，若循环**前**用形参注解比实参宽的调用过同一个表
  （`countList(returns)`，形参 `Obj[] | nil`），循环体内**嵌套 if** 里的 `ret` 会解析成列表值本身
  ⇒ `ret.start` 误报未定义字段。复现：`test/project/repro/ipairs-narrow-field.lua`；
  同族 = 目标工程 `missing-return-value.lua:30/31`、`parser/compile.lua:3451`。
  入口在编码器的循环变量建模（`for` 的 `select(fcall(iterator, {state, ctrl}), i)`）：
  元素类型靠「`ipairs` 调用时泛型 V 的绑定」，泛型绑定一退化（参数是 `truthy` 之类标记）就
  部分路径退回 state。与 `narrowing.md` F19 的「读到未收窄值」重叠，但成因在循环变量本身。
- **`setmetatable` 的 `MT['__index']` 泛型未绑定**（`facts/classes.md` F2，2026-09-28 新记）：
  `setmetatable(t, { __index = X })` 的值恒为 `T & (any | nil)`（`MT` 拿到的是约束 `table|nil`），
  `__index` 的类完全没进返回值。后果：目标工程测试期望报错的
  `---@class B` + `setmetatable({}, {__index = A})`（A 与 B 无继承）在默认配置下不报。
  要先解决「返回位置上按已绑定泛型取字段」。

- **`for` 控制变量的非 nil 收窄带来 1 处新报**（目标工程 `script/library.lua:323`）：
  `local f, err = load(...)` + `if not f then return nil end` + `xpcall(f, ...)` 报
  「Cannot assign `function | nil` to parameter `async fun()`」——`f` 的守卫收窄在这个文件里失效了，
  而该函数里唯一的 `for` 在**后面**（`for k, v in pairs(env)`）。探针（单独复刻这个函数、`tmp/probe-for3`）
  不复现，怀疑是**执行顺序/缓存**层面的敏感（walker 在同一次 flow 里对同一 stack 的写入顺序变化，
  使某处取值退化成 PROVISIONAL → 回退到注解值）。下轮：在目标文件上下文里定位（先看 param-type-mismatch
  provider 对实参取值的来源：是读节点快照还是 `Variable.value` 的实时兜底）。
- **开放表读任意键仍不产生「不可判定」值（已试过，本轮回滚）**：把 `Table:get` 的 miss 在
  `self.dynamic` 时改成 `ANY, true`，目标工程能从 449 直接降到 397（p-t-m −21、assign −18、need-check-nil −8），
  但会**压过更精确的来源**：`t = setmetatable({}, {__index = function() return 42 end})` 的 `t.anything`
  本来由 `T & {[any]: V}` 推出 `42`，加了 ANY 后变成 ANY（`test/feature/diagnostic/undefined-field.lua`
  的假绿断言立刻挂）。根因是 `Union:get` 的 `v | ANY = ANY`、`Intersection:get` 的 `result & partValue`
  都让 ANY 支配。要拿这 −52 得先定「开放表的不可判定值如何参与组合」（不能支配、只能在整条链都取不到值时兜底），
  或是只在表达式键（`unknownkey`）路径上兜底——后者试过（`typeName == 'unknownkey' and self.dynamic`），
  目标 446 但 `script/pub/pub.lua:149` 多 1 条，且 `Chunk[#Chunk]` 一族只修掉一部分（值不是从 `Table:get` 取的）。
  参考：`queue[i].x`、`m.taskMap[id].name`、`Chunk[#Chunk].type` 都属这一族。
- **闭包里守卫收窄外层变量（upvalue）不生效**（目标工程 429 → 428，need-check-nil 57 → 56）：
  ```lua
  ---@type timer?
  local delayTimer
  local function f()
      if delayTimer then delayTimer:restart() end   -- 曾误报 need-check-nil
  end
  ```
  机制：闭包里的 tracer 是新的一层，`getValue(id)` → `getUpvalue(id)` 只在「外层创建点快照值已排除 nil」时才采纳
  （带 nil 的 flow 值被故意拒，含糊值用在闭包里会引入误报）→ 收窄没有基值 → `traceByValue` 直接 return；
  读值退回注解 `timer?` → 报 need-check-nil。
  修法（`script/node/tracer.lua`，落在新的收窄路径上）：`traceByValue` 在基值为空时退回**节点注解值**
  （`getExpectValue()`）作为收窄基值；注解值本身不会比读值更含糊，所以写进分支收窄栈是净收益。
  **`any`/`unknown` 必须排除**：对 `any` 收窄得到的是 `truthy`/`falsy` 标记，写进栈会盖住读值——实测不排除时
  目标从 429 涨到 456（修 2 处、新增 29 处，典型表现 `source.declare`「字段突然不存在」、实参变成 `false | nil`）。
  回归测试：`test/feature/diagnostic/need-check-nil.lua`（`if x then x:m()` / `if not x then return end; x:m()` /
  无注解变量不做收窄三条）。复现探针：`tmp/probe-upval`（3 处 → 0）、`tmp/probe-upval4`（各类守卫形状 0 报）。
- **`parentMap` 收窄回传链把垃圾值写回含糊基变量**（目标工程 428 → 418，undefined-field 59 → 53、
  need-check-nil 56 → 52，无新增）：
  `if src.type == 'getfield' and src.field then ... elseif src.type == 'getmethod' ...` 这类**字段条件**收窄后，
  `traceByValue` 会沿 `parentMap` 一路把结果回传给基变量（`narrowByField`）。基值为 `any`/`unknown`（或
  含 any 的 union / `select` 这类含糊值）时，回传的只是垃圾值（成员被全部过滤成 `never`/`false | nil`），
  而**下一个 `elseif` 分支的基线就是上一分支的 `otherSide`**，于是 `src` 被这个垃圾值盖住 →
  `src.type`「未定义字段」+ `src` need-check-nil（`core/diagnostics/undefined-field.lua:47`、
  `inject-field.lua:103`、`document-symbol.lua:72/75`、`jump-source.lua:42`、`provider/diagnostic.lua:349` 共 10 处）。
  修法：回传前看 `pvalue:finalValue()`，`any`/`unknown` 就不回传（也不继续往上回传）。
  与上一条的关系：入口的 `any` 拦截（不对含糊值做收窄）+ 这里的回传拦截，缺一条都会让目标涨 18~28 处。
  回归测试：`test/feature/diagnostic/undefined-field.lua`（含糊基值的 `if/elseif` 链不报 + 有类型支撑的
  union 仍按字段收窄、`x.bv` 仍报 undefined-field 两条）。
- **守卫收窄后字段读取仍按注解算 nil**（本轮勘查，未落地；目标工程里是大簇）：
  ```lua
  ---@return table?, string?, boolean?, string?
  local function query(a, b) end

  local function f(a, b)
      local t, k, isarray, lastpath = query(a, b)
      if not t then error(k) return end
      if isarray then
          return t.v[k]        -- 误报 need-check-nil
      end
  end
  ```
  复现：`tmp/probe-guard3`（3 处）；`tmp/probe-guard2`（同形状、少两个局部、无中间 if）0 处。
  定位手段（临时插桩，已移除）：① `Coder:finishTracer` 里按 id dump flow；② need-check-nil provider 里打印
  `vfile:getNode(var)` 的 kind/view 与 tracer/cv/sv 标志；③ `W:traceTruthy`/`W:traceByValue`/`W:traceVar` 打印收窄过程。
  结论：**收窄本身是对的**——flow 里守卫是 `{'return', {'condition', {'not', {'ref','t@7:11',...}}}, ...}`，
  `traceByValue` 算出 `narrowed=table / otherSide=nil`（revert 后 otherSide 即非 nil 部分），
  `traceIf` 把 terminated 分支的 otherSide 写回外层 stack（`W:getValue('t@7:11')` 确实是 `table`）。
  问题在**读值路径**：`t.v[k]` 的基变量 `t` 在 flow 里没有独立 ref（只有字段 id `t@7:11.v[unknown]`），
  于是基变量读值只能落到 `Variable.value` → `getExpectValue()` = 注解 `table | nil`；
  字段 `t.v` 同理走 `parentExpectValue` → `(table | nil):get('v')` = `any | nil`。
  provider 取的是 `vfile:getNode(var)`（= `map[key].value`，不触发 walker）→ 拿到注解值 → `mayBeNil` 命中 → 报。
  下轮修法（二选一）：① 让「基变量/字段的节点值」在基变量已被 flow 收窄时按 flow 值派生
  （把 `tracer.deriveFieldValue` 的规则用到 provider 走的 `Variable:getExpect`/`getChild`/`childsValue` 这条路上）；
  ② 让 coder 为「字段链的基变量」也发一个 ref，使 `VirtualFile:getNode` 能拿到收窄后的 currentValue。
  补充观测（下一轮少走弯路）：`W:traceRef` 里打印 `getValue('t@7:11')` 的结果显示，**读点所在 stack 链上拿到的仍是注解值
  `table | nil`**（不是在分支内被盖掉，而是守卫合并写入的值没在链上），而 `if isarray` 的 else 分支读到的是 `never`
  （`traceIf` 合并时把「某分支没记这个 id」当成 nil 参与 union，`rt.union` 退化）。曾试过在 `traceIf` 合并里用
  「合并前的值」补齐缺失分支 → 这条 probe 仍不复位，且 `test.feature.diagnostic` 多出 1 条 `return-type-mismatch`，已回滚。
  目标工程里这一族：`json-edit.lua` 的 `t.v[k]`（10 处）。
  另：`parser/compile.lua` 的 `child.*`（~20 处）除本族外还叠加了**无 `---@return` 的函数返回值推断成 `nil`**的问题：
  `parseExp()` 的返回值推断出来 view = `nil`（只有 `return nil` 那条被算进去），于是 `if child then` 的收窄结果是 `never`，
  后续 `child.start` / `child.parent = rtn` 全部命中 `mayBeNil` 的注解值。这条要单独查返回值推断（`select` + 多 return）。
- 只在目标工程上下文里出现、单独复刻不复现的候选（本轮试过、无果，需要进程内调试）：
  `main.lua:41`（`if key then _G[key:upper()...]`）、`cpp.lua:247`（`if not transition then break end` 之后）、
  `completion.lua:270`（`lines[firstRow]` 得 `integer | nil`）、`provider/diagnostic.lua:349`（`diag.code`）。
  探针：`tmp/probe-args`、`tmp/probe-break`、`tmp/probe-goto`、`tmp/probe-break2` 均无复现。
- **`need-check-nil` 68 处（目标工程）的分类与已定位根因**：按被报变量的初值形态统计
  （临时在 provider 里打印 `var.loc.id` / 初值 kind / 收窄后 view）：
  `select`（`local a, b = f()` 这类多返回值）**36** / 无初值 **20** / `field`（`x = t.k`）11 / `binary` 1。
  这轮定位到的两条，② 已修（见上），① 仍待做：
  ① **「不返回」的分支没被当成终止**（对应「无初值」那一大桶）：
  ```lua
  local f, err
  if name then f, err = loadfile(name) else f, err = loadfile() end
  if not f then error(err, 2) end
  return f()          -- 这里被报 need-check-nil
  ```
  （目标工程 `tools/lua51.lua:161-167`）。我们只认「以 `return` 结尾的分支」是终止的，
  `error()` 不算，于是 `f` 合并出 `nil`。目标工程里 `if not x then` + 换行 `error(` 的写法有 **12** 处。
  修法：支持 `---@noreturn` —— parser 不用动（未知 subtype 的 cat 只是没有 value）；
  coder 给函数发 `setNoReturn()`（`cat.subtype == 'noreturn'`，参考 `async` 的处理，
  但要放在 `#source.childs > 0` 之外，meta 里的 `function error(message) end` 是空体）；
  `Node.Function` 存标记；tracer 在 `traceCallNarrow` 拿到 callee 后把**当前 stack** 标成 terminated，
  并让 `traceIfChild` 里的 `stack.terminated` 与 AST 判定取或（否则会被覆盖）。
  **坑**：这条要靠 meta 给 `error` 打注解才吃得到目标工程那 12 处，而运行期读的是
  `meta/Lua 5.x auto utf-8/*.lua` 这些**生成产物**（源在 `meta/template/basic.lua`），
  改模板不即时生效（要维护者跑 meta 生成）——所以先在测试里用自定义 `---@noreturn` 函数验证功能。
  ② **`---@type T?` + 多返回值初值的局部，guard 收窄在某个读点没生效**（已修，见上一条「字段读取的
  收窄值要跟基变量的 flow 值走」）：`main.lua:41` 的 `---@type string? local key, tail = v:match '...'`，
  后面 `if key then _G[key:upper():gsub('-', '_')] = getValue(value) end`，被报时打印出来的收窄值仍是
  `string | nil`。（当时排除过的复现路径：换 `---@param v string`、去掉/保留 `ipairs` 循环与分支赋值、
  换普通表达式、去掉 `---@type`——都不复现；根因在字段读取的取值来源，不在这些写法。）
- **`---@cast` 在这个分支里还没有实现**（目标工程 `vm/node.lua:351` 的误报挂在它上面）：
  - `parser/ast/cats/cast.lua` 的 `parseCatStateCastItem` 里 `local exp = self:parseCatExp()` 是**影子变量**，
    外层的 `exp` 永远是 nil，所以 `item.type` 拿不到类型（`---@cast x T` 解析出来没有 `T`）；
  - `vm/coder/cat.lua` 的 `catstatecast` / `catstatecastitem` provider 只编译了类型、**不产生任何收窄**
    （源码里写着 TODO）。
  于是 `---@cast c -vm.global` 这类写法对求值毫无影响，只能靠前后条件的收窄链「碰运气」。
  要做的话：先修上面的影子变量，再给 coder 发一条按位置的收窄指令（`+T` 取交集、`-T` 取 otherSide、
  `?` 并入/去掉 nil，参考 `Narrow:narrowEqual` 的 narrowed/otherSide），tracer 侧对**当时的** flow 值
  应用（不能写死成静态值），最后补 `test/node/tracer.lua` 与 `test/feature/diagnostic/` 用例。
- **`---@cast` 已实现（按位置的收窄）；`vm/node.lua:351` 现在卡在「值被物化成表」**：
  - 已落地：parser 影子变量、coder 的 `compileToPrelude` + `{'cast', ...}` flow 指令、
    tracer 的 `W:traceCast`（断言 / `+T` / `-T` 按同名去掉 / `?`）。
  - 已修：**else 分支里的 `---@cast`** —— `parser/ast/state/if.lua` 的 `parseIfChildElse` 原本
    先 `skipSpace` 再 `blockStart`，`else` 后、首条语句前的注解被算进**外层 block**（编译时 tracer
    节点栈 `nodes=0`，指令落在 if 之外、又被分支收窄覆盖）。改成先 `blockStart` 即可。
    钉住：`test/parser/ast/state.lua`（注解必须挂在 else 分支下）、
    `test/parser/ast/cat.lua`（cast item 的 `type` 不再是 nil）。
  - 仍待做（351 的真正卡点）：else 分支里 `c` 的值是**物化出来的表**（字段里全是 vm.global 的成员），
    不是类/别名联合 —— `removeMemberByName` 取不到名字，回退 `rt.subtract(table, type vm.global)`
    也减不掉（我们的「表 → 类」cast 偏严，见下面「表 cast 偏严」条目）→ `removeObject(c)` 仍报。
    下轮从「分支合并为什么把类联合物化成表」查起（`narrowByField` / `mergeTables` 那条链）。
  - 形参（flow 里没有 `var`）目前只支持不带 op 的断言：试过把变量声明节点也编译到前导区来兜底，
    会 `No such key`（它的值引用在别处、更晚才赋值），已回滚。
- **`and`/`or` 节点的子节点不止两个：操作数自己的 ref 夹在中间**（已修，目标 491 → 470）：
  coder 的 `and`/`or` 节点里，**右操作数**会把自己的 ref 和平铺在同一个节点里
  （`{'or', 左, 右的 ref…, 右}`），而 walker 原本只走 `exp[2]`（左）与 `exp[3]`（右）→
  写在条件里的调用（`if not x or isAlias(x, uri) then`）其参数 ref 落在中间、**永远不被走** →
  参数节点拿不到 `currentValue` → provider 退回注解值 → 报 `Cannot assign string | nil to parameter string`。
  改法（`script/node/tracer.lua` 的 `traceAnd`/`traceOr`）：把 `exp[3..#exp-1]` 的中间 ref 在
  **右操作数自己的 stack**（seed 之后）里 `traceUnit` 走一遍（只读，不做 truthy 收窄）。
  注意**不要**顺手把 `right` 改成 `exp[#exp]`：那样会让 `traceCallTruthy` 作用到真正的调用上，
  目标工程多修 4 处但**新增 16 处**（`workspace.lua` 的 `scp and util.loadFile(...scp.uri...)`
  一族），得不偿失，已回退。
  回归测试：`test/feature/diagnostic/param-type-mismatch.lua`（形状必须带前面那条 `==` 守卫：
  `if childName == 'any' then return true end` 再 `if not childName or isAlias(childName, uri)`；
  只写纯 `not x or f(x)` 不复现）。
  效果：param-type-mismatch −17、need-check-nil −3、return-type-mismatch −1；无新增。
  目标工程命中：`vm/type.lua:466`、`workspace/require-path.lua:190`、`provider.lua:1565` 一族。
  走过的弯路：只在 walker 里给参数节点补 `setCurrentValue` —— 拿不到 id，代码根本走不到，无效。
- **`assign-type-mismatch` 65 处（目标工程）= 表字面量缺「已声明的非可选字段」**：
  `parser/compile.lua:2263` 一族的 `node = getfield` 等，值是分批构造的局部表（`{ dot=..., field=...,
  node=..., type='getfield' }`），而 `parser.object` 声明了一批必填字段。属目标工程注解/写法偏松，
  不是本仓库误报（我们只保留「非可选字段必须齐全」这一条要求），不要为它放宽 cast。
- **`need-check-nil` 里 `compile.lua` 的 `local child = parseExp(); if child then ... child.start` 一族**：
  看着像守卫收窄没生效，但同形状的最小探针（单返回 / 多返回 / `---@type` 三种写法，见 `tmp/q27`）
  都不复现，需要在目标文件上下文里继续缩小（先查 `parseExp` 的返回注解与调用点）。
- **`Table:get` 的 valueMap 分支返回字段记录**（已按「provider 侧展开」修掉，目标 470 → 457，13 处）：
  `valueMap` 存的是 `Node.Field`（字段记录），字面量键读命中它时会**直接返回字段节点**，而其他分支
  返回的是 `field.value`；纯值消费方（读 `xx.field` 的 provider）拿到字段节点就判「字段不存在」
  → 目标工程 `completion.lua:1909`（`func.args`）、`code-action.lua:522`、`duplicate-set-field.lua:88`
  一族（就是 `list[#list+1] = x` 后读 `list[1].field` 的形状）。
  试过直接改 `Table:get` 返回 `field.value`：目标同样到 457，但 `test/feature/definition` 挂 ——
  `t.x` 的**定义**要靠这个字段记录的 location（调用栈：`feature/definition.lua:81` 的
  `findCustomDefinitionAliasFromNode` → `rt:getExpectValue` → `Variable:getExpect` → `Table:get`），
  定义侧与读值侧对 `get` 的期望相反。
  最终做法：在 **`feature/diagnostic/providers/undefined-field.lua`** 里加 `unwrapFieldValue`
  （沿 `field.value` 展开、union 逐成员处理），只影响这一个 provider，0 新增。
  遗留的语义问题：字段读取的 `get` 该返回值还是字段记录要统一定下来（定完 definition 侧改走
  `fieldMap`/`valueMap`，`Table:get` 再统一返回值）。这个形状在测试 harness 里不复现，回归以目标扫描为准。
- **`local child = parseExp(); if child then child.start …` 一族（`need-check-nil`，compile.lua ~5 处）**：
  在目标工程里给 `child@3033:11` 打断点式日志，tracer 走出来的读值是 `never` 和一个 `select`（view `nil`），
  但 provider 仍报 need-check-nil（说明它读到的不是 tracer 的值）。用标注过的返回（`---@return A?`）、
  无注解单返回/多返回（`tmp/q29`、`tmp/q30`）都**不复现** —— 目标工程的 `parseExp` 无返回注解且返回值
  极其庞杂，得在目标文件上下文里继续缩小（下一步：在 need-check-nil provider 里打 `var` 的 alias 与
  `getCurrentValue`/expect/guess 三段来源）。
- **开放表还差「动态/表达式键读取」**：`setDynamic` + provider 出口 + `mergeTables` 传播只覆盖
  「字面量字段读」；`queue[i].x` 这类**表达式键读取**仍被当成 `nil`（`nextTask = queue[i]` 之后
  `nextTask.removed` 报未定义字段、`nextTask.id` 报 need-check-nil）。
  这是我自己的语义结论（开放表 = 任意键都可能存在、值不可判定），不是拿别的实现当判据。
  已试过在 `Table:get` 里给 `self.dynamic` 返回 `ANY, true`（两处：空表提前返回 + 未命中字段），
  结果：① 表达式键读取走的是 `Variable:getChild` 那条路，**根本不经过 `Table:get`**（加打印验证命中 0 次），
  所以对 `queue[i]` 无效；② 反倒把 `---@type string local s = t.anything`（`setmetatable{__index=函数}`）
  这类**故意用 `__index` 函数返回值**的解析压成 ANY，打破 `test/feature/diagnostic/undefined-field.lua`
  里那条「防止退化为 unknown 的假绿」的断言，目标工程还多出 2 条 `any | nil` 的 param-type-mismatch。
  已回滚这两处，只保留 `mergeTables` 传播。下轮要从 `Variable:getChild`/索引读取那条路入手，
  并把 `__index` 的处理排在开放表兜底之前。

- **收窄可以传进闭包了**：外层 block 走到闭包创建点时，把当前收窄快照推给内层 tracer
  （coder 侧在父 flow 插 `seed` 入口 + `setParent`；walker 侧 `getValue` 查不到时查这份快照，
  必要时先触发外层 walk），并让闭包继承外层"已可见变量"集合（upvalue 读取才会挂 tracer）。
  典型修复：`script/config/loader.lua:75` 的 `pcall(function() load(buf, ...) end)`。
  目标工程扫描 792 → 722（param-type-mismatch −18、undefined-field −18、need-check-nil −34）。
- **闭包收窄带来的一族新报**：闭包内读外层变量改成走 flow 后，某些变量的 flow 值
  （分支合并出来的宽 union，常含 `nil`）比原来的注解/赋值推断更宽，于是新报
  （目标工程里 18 条，主要是 `json/jsonc/json-edit` 的 `string_sub(statusBuf, statusPos, ...)`）。
  该族是「闭包收窄可以传进闭包」这次改动引入的（改动前后本仓库自扫对比可见），属我们新增；
  收敛方向：让「外层 flow 值本身带 nil」的变量不挂 tracer（试过两种跳过策略，反而更多，已回滚）。
- **表 cast 偏严（仅剩非可选字段）**：`Table:onCanBeCast` 会遍历期望类型的全部键，
  非可选字段在字面量里缺失时我们报 `assign-type-mismatch`。
  可选字段（`b?`）已按语义放行；剩下的偏严暂不处理，等再遇到同类误报时评估是否放宽
  （放宽需同步更新 `test/node/cast_table.lua` 的严格断言）。
- **`redundant-parameter` 没算末位实参的多返回值展开**：`callArgs = #args`，
  所以 `converter.position(guide.rowColOf(x))`（`rowColOf` 返回 2 值、`position` 收 2 个）
  可能被报「expects a maximum of 1 argument(s)」。`missing-parameter` 已改成按展开计数
  （`#args - 1 + 末位调用的 returns.min`），但 `redundant-parameter` 还没跟；不跟只是漏报（假阴性），
  不会误报，暂不动。
- **`?` 后缀只在部分类型表达式上生效**：目前只有 `catid`（`integer?`）和 `catarray`（`integer[]?`）
  会并入 nil，其余类型表达式仍然丢掉 `?`（探针实测）：`(integer)?` → `integer`、`fun()?` → `fun()`、
  `{ x: integer }?` → `{ x: integer }`、`integer[integer]?` → `nil`（顺带暴露 `catindex` 的值本身也可疑）。
  根因是 `coder/cat.lua` 各 provider 自己拼 `{key} = ...`，没法在 `Coder:compile` 里统一补
  （中间码的 key 只能写一次，二次赋值会报 `Key already exists`）；要修得逐个 provider 处理
  （多语句的 `cattable`/`catfunction` 还得先写临时 key）。目标工程没有用到这些写法，先只修已验证的
  `catarray`，其余等遇到真实误报再说。
- **`redundant-return-value` 取错了返回值**：`local max = funcNode:getReturnCount()` 拿到的是
  `min`（该函数返回 `min, max or nil`）；目标工程现存的 1 处（`script/locale-loader.lua:16`，
  闭包 + `setmetatable` 折叠）还叠加了 `returnsPack` 缓存/空列表的问题，单独改成 `max` 不够，
  需要一起看。
