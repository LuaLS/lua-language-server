# Tasks

- [x] 分组目标工程 276 条：`param-type-mismatch` 144 / `assign-type-mismatch` 74 / `need-check-nil` 36 / …
- [x] 定位最大单文件簇：`script/parser/compile.lua` 的 29 条 `need-check-nil`（`if child then` + `parseExp()`）
- [x] 探针 + 中间码 + 临时打印定位到三段链路（never 收窄 / 调用点 head 返回 `nil` / 收窄值不重算）
- [x] 候选 1：Tracer 按 flush 代数重跑 —— 实测 276 → 276（0/0），不采用，回退
- [x] 候选 2：`addReturnDef`/`addReturnList` 失效 `returnsPack` —— 实测 276 → 276（0/0），不采用，回退
- [x] 每次改动前后跑全量 `bin\lua-language-server.exe --test`（绿）
- [x] 结论落台账 `facts/returns.md` F2（含诊断链、两次实测、下一步）+ `--test tools.facts`（绿）
- [x] 同步 `项目实践.md`（第八轮纪要）
- [x] `openspec archive tracer-flush-retrace`（`skip_specs: true`）
