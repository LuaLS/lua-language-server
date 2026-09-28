# Tasks

- [x] 逐条诊 `completion.lua:270`：探针（`--probe-file=core/completion/completion.lua --probe-filter=@270`）
      确认 `lines` = `integer[]`、键 `firstRow` = `integer`，但读值 = `integer | nil`
- [x] 落最小复现：`test/project/repro/array-index-nil.lua`（去掉无 disable 即报，已验证）
- [x] 定位取值链：动态键路径的基值来自槽位（`getCurrentValue` 被 flush ⇒ `getStaticValue` = 未收窄旧值）
- [x] 试方案 1（`traceRef` 喂基值 flow 值 + `nodeID`）—— 0/0（`parent` 是值链上的转发变量），回退
- [x] 落地：`getDynamicKeyValue` 循环里过滤基值的恒假成员（`dropFalsyMembers`）
- [x] 目标工程基线比对（`--baseline`）：270 → 260，移除 10 / 新增 0
- [x] `bin\lua-language-server.exe --test` 全量绿
- [x] 本仓库问题面板（`vscodeOperator_readProblems`，`minSeverity=information`）= 0
- [x] 复现目录自检：`--test project.external-diagnostic --test-project=<本仓库>/test/project/repro` = 0 诊断
- [x] 结论上提成 fact（`facts/narrowing.md` F22，含「无 harness 回归钉」说明）并跑 `--test tools.facts`
- [x] 本轮纪要写进 `项目实践.md`（第十四轮）
