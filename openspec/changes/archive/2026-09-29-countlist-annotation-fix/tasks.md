# Tasks

- [x] 目标工程 `vm/function.lua:291` 参数注解放宽为 `parser.object | parser.object[] | nil`
- [x] 目标工程 `vm/function.lua:300` 元素读加 `--[[@as parser.object?]]`
- [x] 目标工程基线比对（`--baseline=tmp/17-base2.txt`）：218 → 216，移除 2 / 新增 0
- [x] 新基线存 `tmp/20-base-final.txt`（216）
- [x] `bin\lua-language-server.exe --test` 全量绿（本仓库零改动）
- [x] 本仓库问题面板（`vscodeOperator_readProblems`，`minSeverity=information`）= 0
- [x] 台账 `facts/returns.md` F3 记录落地与两个引擎侧候选，并跑 `--test tools.facts`
- [x] 纪要写进 `项目实践.md`（第二十轮）
