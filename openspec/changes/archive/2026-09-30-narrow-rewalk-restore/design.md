# Design

动机、证据与数字见 `proposal.md`；事实落点见 `facts/returns.md` F2 与 `facts/narrowing.md` F27。

## Context：面板那条是怎么来的

目标工程 `script/parser/compile.lua:3033` 起：

```lua
local child = parseExp()        -- 无 ---@return 注解的递归局部函数
...
if child then                   -- 守卫
    local rtn = {
        start  = child.start,   -- 3043（面板报 need-check-nil）
        finish = child.finish,  -- 3044
        ...
```

插桩结论（本轮）：

1. `W:traceVar`（`var` unit）读 `local:child@3033` 的静态值 = **nil**（每次 walk 都一样）
   ⇒ 栈上 `child = nil` ⇒ `if child then` 判死 ⇒ 分支内读点被 `W:traceRef` 写成 **`never`**。
2. `never` 不含 nil ⇒ `need-check-nil` 的 `mayBeNil` 为假 ⇒ **不报**（批量 harness 因此「看起来已修好」）。
3. 真实 flush（长会话里随时发生）把这些 `never` 清掉 ⇒ 读值退回静态兜底 `parser.object | nil`
   ⇒ 报 `need-check-nil`（实测：强制 flush 场景下 `cv=nil value=nil`）。

所以「重走写不回」是对现象的猜测，真正的两处是：
**(a) walk 拿到的输入值就是错的（F2）**、**(b) flush 会把收窄值清掉（F27，设计使然）**；
(a) 让错值 `never` 顶替了正确的收窄，(b) 又把错值冲掉露出兜底。

## Goals / Non-Goals

**Goals**：把根因与两条被否改法记录成可复用的证据；给出下一步的可操作入口（F2）。

**Non-Goals**：本轮不修代码（试的两条都净变差）；不在 flush 语义上继续打补丁。

## Decisions

### D1 停止在 flush/重走上打补丁

两条实测（`proposal.md` 试过 1/2）都净变差，且第二条还会把 #21/#22 已修好的族带回来
⇒ `setCurrentValue` 的 flush 是承重的（依赖节点要按位置重算），不能动。

### D2 修 F2：从「`getStaticValue()` 为什么给真 nil」入手

`Node.Variable.getStaticValue()` 的兜底是 `rt.ANY`，所以返回 **nil** 说明链上某条 getter
直接给了 nil（`assignValue` / `getDynamicKeyValue` / `getCurrentValue` / `getExpectValue` / `getGuessValue`）。
`parseExp` 是**无注解的递归局部函数**，其调用结果由 `Function.returnsPack` 推断 —— F2 已记：
函数节点自身的 view 是 `fun(…):{...} | nil`，但**同一调用点**的 head 视图是 `fun(…):nil`
（`List:select(1)` 对空 list 返回 `NIL`）⇒ 推断「调用时」的返回集合是空的。

下一步验证顺序（写进 tasks）：
1. 在 `traceVar` 里打出 `child` 的 `assignValue` / `getGuessValue()` / `matchedFuncs` 各自的 view；
2. 判断是「空 list ⇒ nil」（F2 原假设）还是「某条 getter 直接给 nil」（本轮新线索）；
3. 据此改 `returnsPack`/`select` 的兜底（空 list 不该当作 `nil` 值，至少不该让守卫判死）。

### D3 验收手段固定下来

强制 flush（pass 边界 flush「本次 walk 写过的收窄节点」）的 harness：
现状 **193**，F2 修好后应回到 **156**（普通过程 154 不变）。
面板侧由用户重启 LS 复验 `compile.lua:3043/3044` 是否消失。

## Risks / Trade-offs

- [F2 修法可能影响面很大] → 先量：改 `returnsPack`/`select` 的空 list 兜底要在目标工程 + 全量 `--test` 上
  双验证，`facts/returns.md` 里两条历史尝试（0/0）说明**只看这一层可能不够**，需要先确认空 list 是不是真因。
- [强制 flush harness 不是面板的精确等价] → 它只是把「flush 之后读值退化」这条通路放大；
  最终验收仍以面板（用户重启 LS 后）为准。
