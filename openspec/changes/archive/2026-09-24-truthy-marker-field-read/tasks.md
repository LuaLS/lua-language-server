# Tasks

- [x] 存目标工程基线 → 278 条（`tmp/scan-before-truthy.txt`）
- [x] `script/node/type.lua` 的 `M:get`：`truthy` 并入 `any` / `unknown` 那一支
- [x] 跑全量 `--test`（绿）+ 目标工程比对 → 278 → 278（移除 0 / 新增 0）
- [x] 钉语义：`test/node/truthy.lua` 新增「`truthy` 读字段 → `any`」
- [x] 探针复核 `c99.lua:66`：`decl.ids[1].decl` 已是 `any`；外层 FP 来自 `decl.ids[1]` 的
      `false | nil`（falsy 降解）→ 另开一轮（新 change）
- [x] 结论写进事实台账 F5；`--test tools.facts`
- [x] 同步 `项目实践.md`；`openspec archive truthy-marker-field-read`（增量并入 `specs/narrowing/`）
