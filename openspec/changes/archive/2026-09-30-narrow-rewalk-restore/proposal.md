# Proposal

## Why

面板（扩展自带 LS）仍报 `script/parser/compile.lua:3043/3044`
（`if child then … child.start`），即 `narrowing.md` F27 的残留。本轮定位结论：
**它不是「重走写不回」单点问题，而是 F2（错值掩盖）+ flush（暴露）两个缺陷叠加**：

1. `local child = parseExp()`（无 `---@return` 注解的递归局部函数）的**第 1 个返回值在 walk 时机解析成 `nil`**
   （`facts/returns.md` **F2**，未满足）：插桩显示每次 walk 里 `child` 的静态值都是 `nil`
   ⇒ `if child then` 把分支判死 ⇒ 分支内读点被写成 **`never`**（`[child3043] write value=never`）。
2. `never` 不含 nil，所以 `need-check-nil` **不报** —— 这就是批量 harness「看起来已修好」的原因。
3. 一旦发生**真实 flush**（长会话里随时发生），那些 `never` 被清掉 ⇒ 读值退回静态兜底
   （`parser.object | nil`）⇒ 报 `need-check-nil`（实测 `cv=nil value=nil`）。

复现手段（本轮产出）：在 pass 边界把「本次 walk 写过的收窄节点」也 flush 掉
⇒ 批量 harness **精确复现面板那批**：156 → 193（移除 3 / 新增 32）。

## What Changes

- 本轮**不做代码改动**：把根因、证据、两条被否的改法写进台账，把「修什么」收敛到
  **`facts/returns.md` F2**（返回值推断时机），而不是继续在 flush / 重走上打补丁。
- 保留验收手段：F2 修好后，强制 flush 场景应回到 156（现在 193），
  面板的 `compile.lua:3043/3044` 一族应消失。

## 基线（改前 → 改后）

- 普通过程：154（无变化，本轮无代码改动）
- 强制 flush 过程（复现面板状态）：193 —— 本轮把它从「未知」变成「可复现」，
  这是下一步修 F2 的验收指标（目标 193 → 154）
- 面板侧：待 F2 修好后由用户重启 LS 复验

## 语义依据

- F2（`facts/returns.md`）：无注解递归局部函数调用的第 1 个返回值应当是推断出的
  `{...} | nil`；现在拿到 `nil` ⇒ 守卫分支判死 ⇒ 读值变 `never`（错值）⇒ flush 后暴露成误报。
- F27（`narrowing.md`）：收窄值随 `class.flush` 失效是**对的**；问题在于失效/错值之后的读值
  不能退回「含 nil 的兜底」而不自知。

## 试过但未采用（有实测，别重走）

1. `W:restart()` 里顺手 flush「本次 walk 写过的收窄节点」：强制 flush 场景 156 → **193**
   （精确复现面板那批），普通过程 154 → **174**（净变差）——**已回退**（复现手段留用）
2. walk 内的收窄写入跳过 `setCurrentValue` 的 flush（`skipFlush`）：普通过程 154 → **174**
   （移除 10 / 新增 25），且**把 #21/#22 修好的族带回来**（`json-edit.lua:249/257/265/322/405`、
   `json.lua:427/435`）⇒ `setCurrentValue` 的 flush 是**承重**的（依赖节点要按位置重算）——**已回退**
3. change #22 之前的四次尝试（`narrowing.md` F27）：无条件重走 / flush 钩子作废 /
   挪出 flush 集合 / 在 `value` getter 里重走 —— 全部爆栈或破坏 mechanism
4. F2 自己的两条历史尝试（`facts/returns.md` F2）：按 flush 代数重跑（276 → 276）、
   `addReturnDef` 里 `flushCache()`（276 → 276）——**已回退**
5. 目标侧绕行（给这些读点加 `--[[@as ...]]`）：治标、拿 cast 迎合实现，不采用

## Capabilities

### Modified Capabilities

- `narrowing`: 要求不变（被 flush 清掉的收窄值必须能重算且留在节点上）；
  本轮确认**它依赖 F2 先修**，否则重算出来的是 `never` 这类错值。

## Impact

- 无代码改动（实验全部回退）。
- 下一步（新轮）：`facts/returns.md` F2 —— 查 `getStaticValue()` 为什么对
  「赋值来自调用」的局部返回**真 nil**（链上某条 getter 直接给 nil），
  修好后用强制 flush 场景（193 → 154）验收。
