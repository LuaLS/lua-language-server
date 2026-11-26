## 1. 删除旧实现

- [x] 移除 coder 和节点 tracer、传输与探针，删除专用值槽和直接单测。
- [x] 跑普通节点、多返回及模块加载专项，保留端到端收窄断言。
- [x] 将已删除单测标为历史证据，并跑 `--test tools.facts`。

## 2. 未通过的验收

- [ ] `bin\lua-language-server.exe --test` 全量通过；当前停在 `test.coder.flow`，分支读取预期 `5`、实际 `10`。
- [ ] 目标工程基线比对：`--test project.external-diagnostic --test-project=... --mem-limit=2`；本轮没有实测改前或改后数字。
