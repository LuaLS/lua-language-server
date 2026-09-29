# Proposal

## Why

接第十八轮：目标工程 `missing-return-value.lua:30/31`（`ret.start` 报 `undefined field`）
的成因有两个候选。本轮做**受控二分**（基线 218），确认元凶并量出代价。

## What Changes

无引擎/目标工程改动（二分补丁与一次目标侧试探均已回退）。产出为**实测结论**：

- 候选 ②（`W:traceLink` 的间接窄化 → `W:traceCallEqual`：对结果做比较时按**形参注解**反推实参）
  **就是元凶**：整段停掉 ⇒ 30/31 消失，但整体 **移除 6 / 新增 7**（净 +1）⇒ **不可整段停**：
  它同时修掉 `compile.lua:2789`、`vm/operator.lua:199/205/223`，并挡住
  `cli/doc/export.lua:122`、`newline-call.lua:46/49` —— 是**承重**机制。
- 候选 ①（`ipairs(<未收窄表>)` 的元素解析）**不是**成因：停掉 ② 后复现文件里
  `ret` 各位置都回到 `repro.Obj`。
- 目标侧候选（`vm/function.lua:291` 的 `---@param list parser.object[]?` 太窄；
  7 个调用点里 6 个传单节点）放宽成 `parser.object | parser.object[] | nil` ⇒
  218 → 217（移除 2 / 新增 1 ⇒ 未采用）：本体 `local lastArg = list[#list]` 读值变宽、
  `lastArg.type == 'call'` 的收窄没生效 ⇒ `function.lua:319` 新增一条。**要两处一起改**。

## Capabilities

### New Capabilities

（无）

### Modified Capabilities

（无 —— 行为未变，`.openspec.yaml` 用 `skip_specs: true`）

## Impact

- 代码：无（二分补丁已 `git checkout` 回退；目标工程改动已手工回退）。
- 目标工程基线：218（0/0 未变）；本仓库 `--test` 全绿；面板 0。
- 台账 `facts/returns.md` F3 追加二分结论；归因更新为「目标工程形参注解太窄 +
  参数反推按形参注解写回变量」两者叠加（反推本身是承重机制）。
