# Proposal

## Why

目标工程（上游 master）大量用 `---@field [integer] parser.object|any` 这类**带 `any` 成员的联合**声明
（`parser.object` 的索引签名、`vm.object` 的字段等）。分诊 `param-type-mismatch` 88 条时发现：

- **赋值**检查早就把「实参含 `any` 成员」当宽松放行（`assign-type-mismatch.lua` 里的
  `hasAnyMember`，注释写明「`X | any` 等价于 any」）；
- **传参**与**返回值**检查没有这条放宽 ⇒ **同一声明出现「赋值不报、传参报」的不一致**
  （最小复现：`---@field [integer] Node|any` 的 `o[1]` 赋给 `string` 不报，传给 `string` 参数却报）。

这是引擎内部不一致（不是目标侧注解问题），且成片误报。判定只基于本仓库自己的语义：
`any` 是赋值的顶类型，`X | any` 语义上就是 `any`；仓库自己在 assign 检查里已经这么定了。

## What Changes

- `script/feature/diagnostic/define.lua`：新增共享判定 `define.hasAnyMember(node)`
  （含 `any` 成员的联合 / 裸 `any`），三条类型检查共用，避免再次走偏。
- `script/feature/diagnostic/providers/param-type-mismatch.lua`：`canAssign` 先判
  `hasAnyMember(actual) or hasAnyMember(actual:simplify())` ⇒ 直接通过。
- `script/feature/diagnostic/providers/return-type-mismatch.lua`：同样放宽（跳过该返回值）。
- `script/feature/diagnostic/providers/assign-type-mismatch.lua`：改用共享 helper（行为不变）。
- 测试：`test/feature/diagnostic/param-type-mismatch.lua` 与 `return-type-mismatch.lua`
  各加「带 any 不报 + 不带 any 必报（对照）」两例。

## Capabilities

### New Capabilities

- `any-member-cast`：`X | any` 等价于 any —— 赋给/传给/返回给任何已标注类型都不报，
  三条类型检查（assign / param / return）必须同规则。

### Modified Capabilities

无。

## Impact

- 代码：`define.lua`（+17）、`param-type-mismatch.lua`（+3）、`return-type-mismatch.lua`（+4）、
  `assign-type-mismatch.lua`（改用共享 helper）。
- 诊断基线：目标工程 `D:\github\vscode-lua\server` **154 → 130（移除 24 / 新增 0）**
  （其中 5 条来自上一轮已落地的 F2 依赖边，19 条来自本轮：参数 16、返回值 3）。
- 分诊结论（本轮）：`param-type-mismatch` 88 条里 **16 条**属本条规则（含 `any` 成员）；
  其余以 `parser.object` 一族为主（目标侧注解偏松/不一致，见 `facts/type-check.md` T2）。
- 本仓库问题面板：0（error / warning / information；hint 不管）；全量 `--test` 绿。

## 试过但未采用

- **把 `Runtime` 的 `ANY.truthy` preset 从 `TRUTHY` 改成 `ANY`**（想让 `any` 经真值收窄后仍宽松）：
  实测能把报错消息里的 `truthy` 去掉（`parser.object | truthy` → `parser.object | any`），
  但**不能消除误报**（拦路的成员是具体的 `Node`/`parser.object`，不是 `truthy`）；
  且这是全局语义改动（影响所有真值收窄的显示与判定），风险大 ⇒ 已回退。
- **在 `Union.__getter.truthy/falsy` 里让 `any`/`unknown` 成员保持自身**（想连「守卫之后」的读取一起修）：
  实测 **154 → 129（移除 32 / 新增 7）**，新增的 7 条全是目标工程 `script/json-edit.lua` 的
  `t.v[k]` 一族 `need-check-nil` —— 保留 `any` 会让它含 nil，破坏「守卫已排除 nil」这条收窄 ⇒ 回退。
  该场景（联合里的 `any` 被真值收窄换成 `truthy` 标记）列入已知未覆盖，见 `facts/type-check.md` T1。
- **让 union 在生成时吸收 `any`**（`T | any` 直接变 `any`）：语义上等价、能统一全部路径，
  但影响面覆盖 narrowing/展示/缓存，未实测 ⇒ 本轮不改。
- **只给 `param-type-mismatch` 放宽**（不碰 `return-type-mismatch`）：会留下同样的不一致，未采用。
