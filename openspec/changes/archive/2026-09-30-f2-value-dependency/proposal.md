# Proposal

## Why

`facts/returns.md` F2 的核心症状仍在：`local child = parseExp()`（无 `---@return` 的递归局部函数）
的 `rt.select(call, 1)` 在「函数返回集合还没齐」时算出 `nil` 并**缓存在 `Select.value`** 上，
之后没有任何机制作废它 ⇒ `if child then` 判死 ⇒ 分支内读值退化（`never`；被 flush 冲掉后读值变 `nil`
⇒ panel 报 `compile.lua:3043/3044`）。

上一轮（change #24）试过补依赖边（`f:addRef(call)` + `addReturnList` 清缓存）—— **147k 层爆栈**
（`intersection.lua:19`），当时的机制是：**清缓存 ⇒ 节点被重建 ⇒ 按身份记录的环保护认不出环 ⇒ 发散**。

**本轮的新前提**（change #25 `eval-context-unify` 已落地）：①求值期不再发生失效（入口锁 + 静默点批量）；
②`intersection` 的环保护已换成**结构签名键**（`Node.Intersection.EvalState`，节点重建后依然有效）；
③只缓存完成态。⇒ 当时炸掉的那个组合，现在**可能不炸了**，值得重试。

## What Changes

- 重试 F2 的依赖边方案：`FCall.matchedFuncs` 登记 `f:addRef(self)`（函数 → 调用），
  `Function:addReturnList`/`addReturnDef` 在返回值集合变化时作废依赖（沿用 ctx 的批量失效，
  不再与求值交错）。
- 若仍不收敛：退一步做「值节点只缓存完成态」——`Select.value` / `FCall.returns` 在
  「被调函数的返回集合尚未齐（`returnList`/`returnsDef` 都为空但函数体已存在）」时**不缓存**该结果
  （不是「nil 就不缓存」——那会让真·void 调用每次都重算，上一轮实测 154 → 移除 9 / 新增 34 ✗）。
- 验收：目标工程 154 → ≤154（若 F2 族消失要记数字）+ 面板复验（用户重启 LS 后看 `compile.lua:3043/3044`）。

## 基线（改前 → 改后）

- 目标工程：**154**（基线 `tmp/scan-154.txt`）→ 期望 ≤154；新增必须为 0
- 全量 `--test` 绿；本仓库面板 0
- 面板侧：`compile.lua:3043/3044` 应消失（需用户重启 LS 复验）

## 语义依据

- F2（`returns.md`）：无注解递归局部函数调用的第 1 个返回值应当是推断出的 `{...} | nil`；
  现在第一次算就缓存了 `nil`，且无失效路径。
- E1–E3（`facts/eval-context.md`）：求值期不失效、per-eval 与 per-traversal 分开、只缓存完成态
  —— 这三条正是本轮敢重试的**新前提**；若仍爆栈，说明还有第四条约束（在 tasks 里量出来并记录）。

## 试过但未采用（有实测，别重走）

（均在 change #24，见 `returns.md` F2）
1. `f:addRef(call)` + `addReturnList → flushCache()`：**147k 层爆栈**（`intersection.lua:19`）
2. 只 `addReturnList → flushCache()`（无依赖边）：批量 0/0（不炸但无效）
3. `Select.value` 取到 nil 时按函数返回集合重算：批量不回归但面板无效（那个 nil 已缓存，getter 不再跑）
4. 「nil 结果不缓存」：154 → **移除 9 / 新增 34** ✗（`postfix.lua` 一片新误报）
5. 无注解递归函数补 `---@return`（目标侧 C 方案）：未实测（会引入新的返回值不匹配诊断风险）

## Capabilities

### Modified Capabilities

无（本轮**无代码改动**：重放实验仍爆栈、已回退；归因与栈已写进 `facts/returns.md` F2 与 design D2）。
`skip_specs: true`。

## Impact

- `script/node/fcall.lua`（`matchedFuncs` 登记依赖、`returns` 的缓存条件）、
  `script/node/function.lua`（`addReturnList`/`addReturnDef` 的失效）、
  `script/node/select.lua`（值节点的完成态判定）。
- 验收：目标工程 154 → ≤154 + 全量 `--test` + 面板（含用户重启 LS 后的复验）。
