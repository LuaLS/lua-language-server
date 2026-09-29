# Tasks

- [x] 诊断期打印（provider 侧）：确认基值 = `parser.object[] | nil`、`exists = false`（不是 `any`）
- [x] 逐位置探针 `--probe-filter=ret@`：`@25/@26` = `any`、`@30/@31` = `parser.object[] | nil`、`@39/@40` = `never`
- [x] 归因：按注解（元素 `parser.object | nil` 有 `start`）不该报 ⇒ 我们的缺口，非目标工程注解问题
- [x] 记录两个候选诱因（`ipairs(<未收窄表>)` 的元素解析 / `W:traceLink` → `traceCallEqual` 的形参反推）
- [x] 诊断期打印已回退（`git checkout` 干净）
- [x] 台账 `facts/returns.md` F3 追加证据与归因并跑 `--test tools.facts`
- [x] 纪要写进 `项目实践.md`（第十八轮）
- [x] `bin\lua-language-server.exe --test` 全量绿；面板 0；目标基线 218（未变）
