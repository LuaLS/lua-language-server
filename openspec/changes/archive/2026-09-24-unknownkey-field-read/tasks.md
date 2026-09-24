# Tasks

- [x] 分组目标工程 276 条，挑出 `undefined-field`（10 条）逐条探针
- [x] 定位：`service.lua:104` 的循环变量 `cache` 读值是 `unknownkey`，字段读取返回 `never`
- [x] 落地：`script/node/runtime.lua` 给 `UNKNOWNKEY` 挂 `anykv`（与 PROVISIONAL/ANY/UNKNOWN/TRUTHY 一致）
- [x] 跑全量 `bin\lua-language-server.exe --test`（绿）
- [x] 目标工程基线比对（`--baseline=tmp/scan-round8.txt`）：276 → **274**（移除 2 / 新增 0）
- [x] 钉语义：`test/node/get.lua` 新增「`unknownkey` 自己作为基 → 字段恒 `any`」
      （去掉修复该钉立刻退回 `never`）
- [x] 本仓库面板复核（`readProblems`）：**0**
- [x] 把结论上提成一条 fact（`facts/narrowing.md` **F20**）+ `--test tools.facts`（绿）
- [x] 同步 `项目实践.md`（第十一轮纪要）
- [x] `openspec validate` + `openspec archive unknownkey-field-read`
