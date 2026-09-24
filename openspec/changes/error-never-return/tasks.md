# Tasks

- [ ] 存目标工程基线：`--test project.external-diagnostic --test-project=D:\github\vscode-lua\server --mem-limit=2 --save=tmp/scan-before-error-never.txt`
- [ ] 做法 A：`meta/whimsical/basic.lua` 与各版本 `meta/*/basic.lua` 的 `error` 加 `---@return never`
- [ ] 跑全量 `--test` 与目标工程比对（`--baseline=`），记录移除/新增
- [ ] 回退 A，做法 B：在分支终止判定里加「永不返回」清单（`error`）
- [ ] 跑同样的两组数字
- [ ] 二选一落地：胜出的做法 + 需要时补 `test/` 回归钉
- [ ] 把结论写进事实台账（`.github/skills/luals-server-dev/references/facts/narrowing.md` 的 F15）并跑 `--test tools.facts`
- [ ] 同步 `项目实践.md` 对应轮次；`openspec archive error-never-return`
