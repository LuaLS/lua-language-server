# Tasks

- [x] 存目标工程基线：`bin\lua-language-server.exe --test project.external-diagnostic --test-project=D:\github\vscode-lua\server --mem-limit=2 --save=tmp\n12-base-after.txt`
- [x] 逐条探针定位剩余 8 条 `undefined-field`（`--test project.probe --probe-file=... --probe-filter=...`）：
  确认 `plugins/ffi/init.lua` 88/348 的基值是类 `ffi.builder`（类字段集里没有 `globalAsts`）
- [x] 落最小复现：`test/project/repro/class-table-fields.lua`（同名类两次绑定 + `setmetatable` 装配）
- [x] `Variable.fields`：赋值是 `call`/`fcall`/`select` 时并入其返回的表
- [x] `assign-type-mismatch` provider：`---@class` 目标只按 `---@field` + 继承比对
- [x] 落控制/复现文件：`class-setmetatable.lua`（对齐目标工程测试里的 4 种写法）、
  `setmetatable-fields.lua`、`ipairs-narrow-field.lua`（另一族，disable 标记）
- [x] 加回归钉：`test/feature/diagnostic/undefined-field.lua` 末条、`assign-type-mismatch.lua` 末两条
- [x] 目标工程基线比对（`--baseline`）：274 → 270，移除 4 / 新增 0
- [x] `bin\lua-language-server.exe --test` 全量绿
- [x] 本仓库问题面板（`vscodeOperator_readProblems`，`minSeverity=information`）= 0
- [x] 复现目录自检：`--test project.external-diagnostic --test-project=<本仓库>/test/project/repro` = 0 诊断
- [x] 结论上提成 fact（`facts/classes.md` F1/F2、`facts/returns.md` F3）并跑 `--test tools.facts`
