# Tasks

- [x] 定位：`script/node/type.lua` `M:narrowEqual` 尾部对「多值类型 vs 单值」返回 `never`
      （`vm/compiler.lua:346` 的 `type: never`、`vm/tracer.lua:103` 的 `variable.base`）
- [x] 存参照基线（`tmp/scan-before-falsy.txt`，278；本轮起点为 change #3 落地后的 277）
- [x] `script/node/type.lua`：多值类型与单值比较、相容时相等侧取该单值
- [x] `script/node/union.lua`：相等侧取成员自己的收窄结果；不等侧保留多值成员
- [x] `script/node/tracer.lua`：`W:traceByValue` 的「不等于」方向加 `isFieldReadable` 前提
- [x] 跑全量 `bin\lua-language-server.exe --test`（绿）
- [x] 目标工程基线比对：`--test project.external-diagnostic --test-project=D:\github\vscode-lua\server --mem-limit=2 --baseline=tmp/scan-before-falsy.txt`
      → 278 → **276**（移除 2 / 新增 0，本轮净 −1）
- [x] 钉语义：`test/node/narrow.lua`（多值类型与单值比较 3 组）+ `test/node/tracer.lua`
      （成员缺字段时 `~=` 反推不写回；去掉判断即退回 `never`）
- [x] 探针复核：`vm/compiler.lua:346` 的返回表 `type: never` → `type: string`
- [x] 把结论上提成一条 fact（**F18**）并跑 `bin\lua-language-server.exe --test tools.facts`
- [x] 同步 `项目实践.md`（2026-09-24 第五轮）与 proposal 的「实测结论」
- [x] `openspec validate` + `openspec archive narrow-multi-value-equality`
