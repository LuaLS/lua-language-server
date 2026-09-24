# Tasks

- [x] 定位：`script/vm/value.lua:176/200/223` 的 `false |` 来自 `W:traceIf` 合并终止分支的 `otherSide`
- [x] 存参照基线（`tmp/scan-before-falsy.txt`，278；本轮起点为上一轮落地后的 277）
- [x] 实现：`script/node/tracer.lua` `W:traceIf` 先收集存活分支、再按 `not assigned` 补 guard 事实
- [x] 跑全量 `bin\lua-language-server.exe --test`（绿）
- [x] 目标工程比对：**278 → 279（移除 1 / 新增 2）**，即本轮净 +2、零移除
- [x] 探针复核被引入的回归（`vm/type.lua` 的 `mark` = `table | nil`，另有一簇 `never`）
- [x] 结论：不采用 → 回退 `script/node/tracer.lua`（目标工程回到 277）
- [x] 记为「试过但未采用」（proposal 的实测结论表 + 下一步方向）
- [x] `openspec archive ifguard-assigned-skip`（`skip_specs: true`，无 spec 增量）
