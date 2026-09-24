# Tasks

- [x] 按规则改读面板：`readProblems`（本仓库、`server/**`、`minSeverity=information`）→ 15 条 warning
- [x] 逐条清：`rt.value` 处 cast、`Node.Tracer.map` 统一为 `table<string, Node>` + 使用点 cast、
      `catAs` 声明 + `exp` cast、`mem-guard` 两处 `---@diagnostic`、`ls.args` 补 `SAVE`/`BASELINE`
- [x] 测试侧：假 root 补 `uriSet`、`narrow.lua` 改用 `addField`、`facts.lua` cast、`probe.lua` 收局部
- [x] 面板复核：**15 → 0**
- [x] 全量 `bin\lua-language-server.exe --test`（绿）
- [x] 自扫对照（`--baseline=tmp/self-scan-baseline.txt`）：508 → **502**，无劣化
- [x] 记「试过但未采用」（`map` 直接写成 `Node.Variable` 的代价；未注册表类的 `@field` 不生效）
- [x] 同步 `项目实践.md`（第六轮补记 + 自扫一节的存量数字）
- [x] `openspec archive self-scan-cleanup-2`
