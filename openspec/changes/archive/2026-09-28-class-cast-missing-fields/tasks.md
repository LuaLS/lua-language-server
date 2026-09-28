# Tasks

- [x] 查证上游机制：跨诊断同位置**无**优先级；`Lua.type.checkTableShape` 默认 false +
      `vm.isSubType` 门控（`script/vm/type.lua:572-581`）⇒ 形状问题只由 `missing-fields` 报
- [x] 落复现：`test/project/repro/class-literal-shape.lua`（完整 / 缺字段 / 已出现字段类型错 三态）
- [x] 落地：`script/node/type.lua` `M:onCanBeCast` 类分支的「有交集 + 有缺失」宽限
- [x] 试① 无限制宽限（259 → 194，联合/数组也放行 ⇒ 丢真检查）⇒ 收窄
- [x] 试② 拼「已出现字段」表再 canCast ⇒ 爆栈 ⇒ 改就地比较 + 深度兜底
- [x] 试③ 只要求「有缺失」⇒ 破 `return-type-mismatch` 钉子 ⇒ 加「有交集」条件
- [x] 更新 `test/node/cast_type.lua`、新增 `test/node/cast_table.lua` 断言
- [x] 目标工程基线比对（`--baseline`）：259 → 220，移除 23 / 新增 0
- [x] `bin\lua-language-server.exe --test` 全量绿
- [x] 本仓库问题面板（`vscodeOperator_readProblems`，`minSeverity=information`）= 0
- [x] 复现目录自检 = 0 诊断
- [x] 结论上提成 fact（`facts/narrowing.md` F25，并在 F24 补记）并跑 `--test tools.facts`
- [x] 本轮纪要写进 `项目实践.md`（第十六轮）
