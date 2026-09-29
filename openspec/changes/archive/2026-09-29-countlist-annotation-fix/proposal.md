# Proposal

## Why

目标工程 `core/diagnostics/missing-return-value.lua:30/31` 的 `ret.start` 误报，
第十九轮二分定性为「目标工程形参注解太窄 + 参数反推按形参注解写回变量」。
本轮按用户选择，把目标侧**两处一起改**并量到收敛。

## What Changes

- 目标工程 `script/vm/function.lua`：
  1. `:291` `---@param list parser.object[]?` → `parser.object | parser.object[] | nil`
     （7 个调用点里 6 个传单节点：`source.args`、`return` 节点，按目标工程自己「节点 = 带编号子项」的约定）；
  2. `:300` `local lastArg = list[#list]` → `local lastArg = list[#list]--[[@as parser.object?]]`
     （参数放宽后元素读是并集；断言回节点，`?` 保住原来的 `if not lastArg` 判空）。
- 引擎零改动。

## Capabilities

### New Capabilities

（无）

### Modified Capabilities

（无 —— 引擎行为未变，`.openspec.yaml` 用 `skip_specs: true`）

## Impact

- 目标工程诊断基线：**218 → 216（移除 2 / 新增 0）**；
  只改注解那一步是 218 → 217（移除 2 / 新增 1，新增落在 `function.lua:319`），两处一起改后收敛。
- 本仓库 `--test` 全量绿、问题面板 0；新基线 `tmp/20-base-final.txt`（216）。
- 台账 `facts/returns.md` F3 记录落地与余下的两个引擎侧候选。

### 试过但未采用（实测）

- 只放宽参数注解（不改本体元素读）⇒ 218 → 217（移除 2 / 新增 1）。
- 整段停掉参数反推（`tracer.lua:1053-1062`）⇒ 移除 6 / 新增 7（净 +1，承重机制）。
