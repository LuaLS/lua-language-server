# 事实台账：type-check 类诊断（assign / param / return 的宽松规则）

格式同 `narrowing.md`：断言 / 证据 / 代码 / 状态。

## T1 `X | any` 等价于 any（三条类型检查必须同规则）

- 断言：实参 / 返回值 / 被赋值表达式的类型里**含 `any` 成员**（或本身是 `any`）时，
  assign / param / return 三条检查 SHALL 一律宽松放行；判定 SHALL 是同一份实现。
- 依据（本仓库自己的语义）：`any` 是赋值的顶类型，`X | any` 语义上就是 `any`；
  仓库在 assign 检查里早已这么定（见下「代码」的既有注释）。
- 证据：
  - `test/feature/diagnostic/param-type-mismatch.lua` 末两例（`---@field [integer] Node|any` 的
    `o[1]` 传给 `string` 参数不报 / 对照组 `Node` 不含 `any` 必报）
  - `test/feature/diagnostic/return-type-mismatch.lua` 末两例（同形状的返回值方向 + 对照）
  - 最小复现（发现时的对照实验）：同一 `Node|any` 字段 —— **赋给** `string` 不报、
    **传给** `string` 参数报 ⇒ 引擎内部不一致
- 代码：`script/feature/diagnostic/define.lua` 的 `hasAnyMember`（唯一实现）；
  `assign-type-mismatch.lua`（原规则，现改用共享实现）、`param-type-mismatch.lua` 的 `canAssign`、
  `return-type-mismatch.lua` 的返回值循环各调用一次
- 数字：目标工程 **154 → 130（移除 24 / 新增 0）**；其中分步为
  **仅 param 放宽 154 → 133（移除 21）**、再加 **return 154 → 130（移除 24）**
  （24 里含上一轮 F2 依赖边的 5 条：`compile.lua:3365(x2)/3375/3411/3417`）
- 试过但未采用：
  - 把 `Runtime` 的 `ANY.truthy` preset 从 `TRUTHY` 改成 `ANY`：只改消息文字
    （`parser.object | truthy` → `parser.object | any`），**误报仍在**（拦路成员是具体类），
    且属全局语义改动 ⇒ 回退
  - union 生成时吸收 `any`（`T|any` → `any`）：语义等价但影响 narrowing / 展示 / 缓存，未实测
  - 在 `Union.__getter.truthy/falsy` 里让 `any`/`unknown` 成员保持自身（想连「守卫后」的读取一起修）：
    实测 **154 → 129（移除 32 / 新增 7）**，新增的 7 条全是目标工程 `script/json-edit.lua` 的
    `t.v[k]` 一族 `need-check-nil` —— 保留 `any` 会让它**含 nil**，破坏「守卫已排除 nil」这条收窄，
    净变差 ⇒ 回退
- 已知未覆盖（下一步入口）：**联合里的 `any` 成员经过真值/假值收窄后**会被换成 `truthy`/`falsy` 标记
  （`X | any` → `X | truthy`），此时 `hasAnyMember` 判不出来、检查照旧报。
  要覆盖它得让「收窄保留宽松成员」且**不把 nil 放回来**（例如收窄结果取 `truthy` 的成员集合、
  但把 `any` 换成一个"非 nil 的未知"类型），目前没有这样的类型 ⇒ 留给后续轮次。
- 状态：成立（2026-10-08，change `any-member-relaxation`；未覆盖场景见上）

## T2 目标工程 `param-type-mismatch` 88 条的家族分诊

分诊时点：`tmp/scan-154.txt`（改前基线）。按消息形状分组：

| 家族（实参类型） | 条数 | 判定 |
| --- | --- | --- |
| 含 `any` 成员（`any \| nil`、`parser.object \| any`、`parser.object \| truthy` 等） | 16 | **引擎不一致** ⇒ 本轮按 T1 放宽后消失 |
| `parser.object[] \| parser.object` | 19 | 目标侧注解**不一致**：字段声明 `parser.object[]\|parser.object`（`---@field extends`），被传给只收单节点的参数（`vm.object`）⇒ 属目标侧写法/注解问题（`vm.getGeneric(set.extends)` 一族） |
| 裸 `parser.object` / `parser.object \| nil` / `parser.object[]` | 约 20 | 目标侧注解偏松：`parser.object` 声明了 `---@field node parser.object`、`---@field [integer] parser.object\|any` 这类「一把抓」类型，调用点直接当具体类型用；按目标自己的注解判定**成立**，不硬改引擎迎合 |
| `uri \| nil` / `false \| uri \| nil` | 约 9 | 目标侧：`furi.decode(scp.uri)` 前未判空（`files.lua:948` 一族） |
| 其它（`{ [string]: vm.node } \| nil`、`op.*` 怪物类型等） | 约 24 | 逐条看；多数是目标侧注解与实际推断不一致（含 operator 类型参与推断） |

- 状态：本轮只落 T1 那一族；其余家族的判定与「不硬改引擎迎合目标侧注解」的结论记在此处（2026-10-08）。
- 后续入口（若继续清）：`vm/compiler.lua` 的 `set.extends` 一族（`vm.getGeneric` / `containsGenericName`
  参数只收单节点）优先——目标侧把参数放宽成 `vm.object|vm.object[]` 即可一次性消掉约 20 条。
