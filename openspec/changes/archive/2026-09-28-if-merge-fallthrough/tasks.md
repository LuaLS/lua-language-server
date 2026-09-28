# Tasks

- [x] 定位入口：目标工程 `script/vm/operator.lua:157`（诊断期打印基值 = 类 `vm.global`）
- [x] 落最小复现：`test/project/repro/branch-assign-merge.lua`
      （去掉 disable 即见 `return c.a | Undefined field a`）
- [x] 候选择 1：合并补「条件不成立」那条路，值取 `otherSide` / 外层值 ——
      目标 270 → 291（移除 0 / 新增 21）⇒ 回退
- [x] 候选择 2：该路值优先取外层旧值 —— 270 → 309（移除 1 / 新增 40）⇒ 回退
- [x] 候选择 3：只放宽「分支里被赋值」的 id（`Stack.assigned`）—— 270 → 289（移除 0 / 新增 19）⇒ 回退
- [x] `git checkout -- script/node/tracer.lua` 回到基线，复现文件加 disable 标记（面板 0）
- [x] 目标工程基线比对：`--baseline` = 270 条 → 270 条（移除 0 / 新增 0）
- [x] `bin\lua-language-server.exe --test` 全量绿
- [x] 复现目录自检：`--test project.external-diagnostic --test-project=<本仓库>/test/project/repro` = 0 诊断
- [x] 结论上提成 fact（`facts/narrowing.md` F21）并跑 `--test tools.facts`
- [x] 本轮纪要写进 `项目实践.md`（第十三轮）
