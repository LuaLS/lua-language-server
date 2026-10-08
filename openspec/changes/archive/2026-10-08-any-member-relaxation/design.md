# Design

## Context

- 动机见 `proposal.md`；事实见 `facts/type-check.md`（T1 规则 / T2 分诊）、`facts/returns.md` F2。
- 仓库既有规则：`assign-type-mismatch.lua` 里 `hasAnyMember(actual)`（注释「`X | any` 等价于 any」）。
- 分诊路径（本轮）：`param-type-mismatch` 88 条 → 按消息形状分组 → 取代表点做最小复现与对照实验。
  实验中确认了「赋值不报、传参报」的不一致（`Node|any` 字段的两种用法），并排除
  「`any.truthy` preset」这一诱因（改它只改消息文字，不消误报）。

## Goals / Non-Goals

**Goals**：三条类型检查对「含 `any` 成员的联合」取同一宽松规则；把判定收敛成一份实现。

**Non-Goals**：不改类型系统本身（不做 union 吸收 `any`、不动 `ANY.truthy` preset）；
不处理分诊里判为「目标侧注解偏松/不一致」的其它家族（另记台账）。

## Decisions

### D1 放宽放在「检查侧」，不动类型系统

三个候选：
1. **检查侧放宽**（采用）：改动局部、与既有 assign 规则一致、批量数字可验证（130 / 0 新增）。
2. `ANY.truthy` preset 改 `ANY`（试过）：只改消息文字，不消误报（拦路成员是具体类），
   且属全局语义改动 ⇒ 回退。
3. `Union.__getter.truthy/falsy` 里让 `any`/`unknown` 保持自身（试过）：
   能连「守卫之后」的读取一起修，但实测 **154 → 129（移除 32 / 新增 7）** —— 保留 `any` 会让它含 nil，
   破坏「守卫已排除 nil」的收窄（新增 7 条 `json-edit.lua` 的 `t.v[k]` `need-check-nil`）⇒ 回退。
4. union 生成时吸收 `any`（`T|any` → `any`）：语义等价但影响 narrowing/展示/缓存，未实测 ⇒ 不做。

### D2 判定收敛到 `define.hasAnyMember`

同一规则出现在三条检查里，若各写一份会再次走偏（本轮就是「assign 有、param 没有」）。
放进 `script/feature/diagnostic/define.lua`（诊断侧的配置/工具模块）最贴近使用者。

### D3 对照用例必须同时进测试

「带 any 不报」与「不带 any 必报」成对写，避免放宽过头（把真错也吞掉）。

## Risks / Trade-offs

- [放宽过头，吞掉真实不匹配] → 只对「含 `any` 成员」放宽；对照用例保证不含 `any` 时照旧报；
  目标工程批量 **0 新增**。
- [目标侧本意是「这个位置必须具体类型」] → 与既有 assign 规则冲突时会先暴露为「赋值报」，
  两条检查语义一致后不会互相掩盖。
- [三处共享 helper 的加载顺序] → `define` 已是 `ls.feature.diagnostic` 的既有模块
  （`init.lua` / `unknown-diag-code.lua` 已在 require），无循环依赖。
