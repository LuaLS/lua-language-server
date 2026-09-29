# narrowing Specification

## Purpose

流收窄（flow narrowing）的系统行为：判等 / 真值 / 动态键判定的收窄结果，
以及收窄标记（`truthy` / `falsy`）作为读值暴露时的语义。
事实台账（`.github/skills/luals-server-dev/references/facts/<能力>.md`）是证据层，
本目录逐步承接其「已成立」的结论（迁移中，2026-09-24 起）。

## Requirements

### Requirement: 真假标记 `truthy` 作为读值时不产生字段存在性误报

`truthy` 是收窄标记（不携带成员集）。当读值恰为 `truthy` 时，其字段读取 SHALL 按 `any` 处理，
SHALL NOT 报「未定义字段」。

#### Scenario: 对 `truthy` 读值取字段

- **WHEN** 某表达式被真值收窄成 `truthy` 后立即读它的字段（`if x then x.field end` 一类）
- **THEN** 该字段读取 SHALL 得到 `any`，且不报 `undefined-field`

#### Scenario: 真值收窄本身不受影响

- **WHEN** `if not args or not other then return end` 之后用 `args` 做实参反推（F2）
- **THEN** `args` 的 `truthy` 标记 SHALL 保留，反推结果里的 nil SHALL 仍被去掉

### Requirement: 复合条件向外暴露的「另一分支」事实不漏键

`and` / `or` 节点向外交出的另一分支事实（`otherSide`）SHALL 覆盖两侧操作数各自贡献的键：
两侧都有则取并集，仅一侧有则取该侧。嵌套操作数（`(A and B) and C`）作为左侧时，
其内部已成立的真值事实 SHALL 继续向外传达。

#### Scenario: 嵌套 and 链里后续操作数不继承左侧的假值降解

- **WHEN** 追踪 `if not (A and B and C) then` 的假分支（`revert = true`），
  其中 `A`、`B` 是 `any` 上的字段读取
- **THEN** 求值 `C` 时读 `B` SHALL 得到真值事实（`truthy`），SHALL NOT 得到 `A` 的假值降解
  （`false | nil`）；对 `B` 取字段 SHALL NOT 报 `undefined-field`

#### Scenario: and 为真时不丢左侧的真值事实

- **WHEN** 追踪 `if A and B then`（`revert = false`）
- **THEN** `B` SHALL 继承「`A` 为真」的事实，`A` 被排除的假值 SHALL NOT 出现在 `B` 的读值里

### Requirement: 多值类型与单值比较的判等收窄

多值类型（`string` 一类，或含多值成员的联合体）与**单值**比较值判等时，
相等侧 SHALL 是该单值本身（交集），SHALL NOT 是 `never`——除非该单值与本类型不相容。
不等侧 SHALL 保留仍能取到其它取值的成员（多值成员只去掉一个字面量仍要保留）。

#### Scenario: `string` 与字面量判等

- **WHEN** `---@type string` 的 `x` 与 `'a'` 判等（`x == 'a'`）
- **THEN** 相等侧 SHALL 是 `'a'`，不等侧 SHALL 是 `string`
- **AND** 该收窄结果写入流后，后续读值 SHALL NOT 出现 `never`

#### Scenario: 联合体里的多值成员

- **WHEN** `'generic' | string` 与 `'doc.field'` 判等
- **THEN** 相等侧 SHALL 是 `'doc.field'`（不收留整个 `string`）
- **AND** 不等侧 SHALL 保留 `'generic'` 与 `string`

#### Scenario: 不相容时相等侧仍为不可能

- **WHEN** `number` 与 `'a'` 判等
- **THEN** 相等侧 SHALL 是 `never`

### Requirement: 字段反推在「不等于」方向不得收窄缺字段的基值成员

`x` 的成员里有缺 `key` 字段的成员时，`x.key ~= 值` 的**不等于**方向 SHALL NOT 按字段
把 `x` 收窄成「不满足」的那批成员；相等方向不受此限。

#### Scenario: 成员缺字段时的 `~=` 反推

- **WHEN** `x: { base: { type: string } } | { other: 1 }`，条件为 `x.base.type ~= 'local'`
- **THEN** `x` 的读值 SHALL 保持原联合体（不得变成缺 `base` 的那个成员或 `never`）
- **AND** 随后对 `x.base` 的访问 SHALL NOT 报未定义字段

#### Scenario: 相等方向的反推照旧

- **WHEN** `node.type == 'global'`（字段类型是多值）
- **THEN** 该反推 SHALL 照常把基值收窄到满足条件的成员

### Requirement: 动态键标记作为读值时的字段读取

`unknownkey` 是动态键写入（`t[expr] = v`，键不可解析）的标记类型，它不携带成员集。
当读值恰为 `unknownkey` 时（典型来源：`for k in pairs(t)` 的键），
其字段读取 SHALL 按 `any` 处理，SHALL NOT 报「未定义字段」——
与 `any` / `unknown` / `truthy` / `provisional` 一致。

#### Scenario: 遍历含动态键写入的表

- **WHEN** 某表被动态键写过值（`t[k] = v`），随后 `for k in pairs(t) do k.field end`
- **THEN** `k` 的读值 SHALL 是 `unknownkey`，`k.field` SHALL 得到 `any`
- **AND** SHALL NOT 报 `undefined-field`

#### Scenario: 动态键的写入/读取结构语义不受影响

- **WHEN** 以同一变量节点为键对表做写入与读取（F9/F10/F12 的往返）
- **THEN** 字面量键读取 SHALL 不命中动态键写入的字段（保持原有语义）
- **AND** `unknown` 键读取 SHALL 能命中

### Requirement: 字段判等收窄的「另一侧」不按补集整块排除

`x.field == 值` 的另一侧（`x.field ≠ 值`）SHALL NOT 用「字段可能相等」那批成员
（narrowed）的补集作为成员集合：①「没有该字段」的成员 SHALL 保留（F18 已定），
②「字段是多值（`string` / `any` 一类）、去掉这一个字面量后还有别的取值」的成员 SHALL 保留；
只有「字段恰是该值」（单值且互相可转）的成员 SHALL 在这一侧被排除。
真值测试（`if x.field then` 一类，传进来的「比较值」是字段自己的类型）SHALL 维持
「按字段能否取到该值」互补的判定。

#### Scenario: 多值字段的成员在另一侧保留

- **WHEN** `src : A | B`，`A.type: string`（多值）、`B.type: 'b'`（字面量），条件为 `src.type == 'x'`
- **THEN** 假分支里 `src` SHALL 仍含 `A`（`A.type` 可以 ≠ `'x'`）
- **AND** 读 `A` 独有的字段 SHALL NOT 报 `undefined-field`

#### Scenario: 恰是该值的单值成员在另一侧排除

- **WHEN** 某成员的字段类型恰是 `'x'`（单值），条件为 `x.field == 'x'`
- **THEN** 该成员 SHALL NOT 出现在另一侧（它的字段不可能 ≠ `'x'`）

#### Scenario: 真值测试的行为不变

- **WHEN** 条件为真值测试（`if x.field then`），且字段类型恒真（如 `string`）
- **THEN** 假分支的成员集合 SHALL 仍是「字段能取到假值」的那批（本例为空）

### Requirement: 以 noreturn 调用结尾的 `if` 分支不参与后续收窄合并

`if` 的某个分支以「永不正常返回的调用」结尾时（`---@noreturn` 函数，或推断为 `noreturn` 的函数），
该分支的流 SHALL NOT 参与 `if` 之后的收窄合并；合并时 SHALL 只取该分支守护后的另一侧，
与以 `return` / `goto` / `break` / `continue` 结尾的分支同待遇。

#### Scenario: 守卫后的非 nil 收窄

- **WHEN** `i` 为 `integer | nil`，代码为 `if not i then decode_error("bad") end`（`decode_error` 永不正常返回）
- **THEN** `if` 之后 `i` SHALL 是 `integer`（不并入 `nil`）

#### Scenario: 返回值注解不因守卫合并而误报

- **WHEN** 函数体把守卫后的整数写入表字段并 `---@return {f: integer}` 返回该表
- **THEN** SHALL NOT 报 `return-type-mismatch`（实参字段不再含 `nil` 成员）

#### Scenario: 普通分支照常合并

- **WHEN** 分支以普通调用结尾（该函数可以正常返回）
- **THEN** 两支的流 SHALL 照常合并，`if` 之后的收窄结果与改动前一致

### Requirement: 收窄值被 flush 清掉后按需重算

`Node.Variable` 上由 walker 写入的收窄值属于**临时缓存**，`rt:flushCacheNow()` 清掉它之后，
该读取处 SHALL 能在**非嵌套时刻**（当前没有任何 walk 正在进行）触发一次重走，
使读值重新得到收窄结果；SHALL NOT 因 flush 永久退化为 `getStaticValue()` / `getGuessValue()` 兜底值。

#### Scenario: 守卫后的读值不再退化成未收窄值

- **WHEN** 同一文件的分析过程中发生过 flush（收窄值被清），随后消费者读一个此前已被收窄的局部变量
- **THEN** 该读值 SHALL 是收窄后的类型（例：`if x and x < n then ... f(x)` 里 `x` 是 `integer`），
  SHALL NOT 是静态兜底值（`integer | nil`）

#### Scenario: 嵌套 walk 中不重走

- **WHEN** 重算请求发生在另一次 walk 内部（`walkingDepth > 0`）
- **THEN** SHALL NOT 重走（维持旧行为）；读值允许暂时是兜底值，但 SHALL NOT 触发栈溢出或无限递归

#### Scenario: 同一次读取只重走一次

- **WHEN** 一个读取处在一次取值中检测到收窄值丢失
- **THEN** SHALL 至多触发一次重走；重走完成后该读值 SHALL 是收窄结果
  （SHALL NOT 形成「走完→flush→再走」的往复）

### Requirement: 收窄值失效的既有语义不改变

`rt:flushCacheNow()` SHALL 继续清除收窄值（它依赖 flow 与其它节点的值，清掉是正确行为）。
本要求只改变「清掉之后不再重算」这一点，SHALL NOT 把收窄值移出 flush 范围或改变 `class.flush` 语义。

#### Scenario: 依赖变化后收窄值仍会失效

- **WHEN** 收窄值所依赖的节点发生变化并触发 flush
- **THEN** 旧收窄值 SHALL 被清除，随后按本 spec 的第一条要求重算，而不是沿用旧值
