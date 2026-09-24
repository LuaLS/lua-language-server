# Tasks

- [x] 存目标工程基线 → 278 条（`tmp/scan-before-falsy.txt`）
- [x] `script/node/tracer.lua`：`W:traceAnd` 的 `otherSide` 合并按「合取 / 析取」区分取键
- [x] 跑全量 `bin\lua-language-server.exe --test`（绿）
- [x] 目标工程基线比对：`--test project.external-diagnostic --test-project=D:\github\vscode-lua\server --mem-limit=2 --baseline=tmp/scan-before-falsy.txt`
      → 278 → 277（移除 1 / 新增 0）
- [x] 探针复核 `script/plugins/ffi/c-parser/c99.lua:66`：`decl.ids[1]` 已是 `truthy`，
      `decl.ids[1].decl` 为 `any`（此前是 `false | nil` → 未定义字段）
- [x] 钉语义：`test/node/tracer.lua` 新增「`(A and B) and C` 里 C 读 B 为真」（撤修复即退回 `false | nil`）
- [x] 把结论上提成一条 fact（**F16**，F5 标注遗留）并跑 `bin\lua-language-server.exe --test tools.facts`（绿）
- [x] 同步 `项目实践.md`（2026-09-24 第三轮）与 proposal 的「实测结论」
- [x] `openspec archive falsy-degradation-leak`
