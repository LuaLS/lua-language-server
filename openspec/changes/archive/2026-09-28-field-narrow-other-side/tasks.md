# Tasks

- [x] 逐条诊 `completion.lua:1365`：探针确认 `src` 在第 4 个 `elseif` 里 = `never`，
      而第 2 个 `or` 操作数处 = `vm.global | vm.variable`（丢掉了 `vm.object`）
- [x] 落最小复现：`test/project/repro/or-falsy-drop-member.lua`（修前报 `src.onlyA` 未定义字段）
- [x] 定位取值链：`test/node/narrow.lua` 的 pin 显示 `narrowByField` 的另一侧用的是补集
- [x] 试「按 `TRUTHY`/`FALSY` 标记 gate」—— 探针证明真值测试传进来的是字段自己的类型，gate 不生效
      （260 → 260，移除 1 / 新增 1），回退
- [x] 落地：另一侧只在「比较值是单值」时才允许排除「字段恰是该值」的成员
- [x] 更新 `test/node/narrow.lua` 两条记录旧补集行为的断言
- [x] 目标工程基线比对（`--baseline`）：260 → 259，移除 1 / 新增 0
- [x] `bin\lua-language-server.exe --test` 全量绿
- [x] 本仓库问题面板（`vscodeOperator_readProblems`，`minSeverity=information`）= 0
- [x] 复现目录自检（`--test project.external-diagnostic --test-project=<本仓库>/test/project/repro`）
- [x] 结论上提成 fact（`facts/narrowing.md` F23 成立 / F24 未满足）并跑 `--test tools.facts`
- [x] 本轮纪要写进 `项目实践.md`（第十五轮）
