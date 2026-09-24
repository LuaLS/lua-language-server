# Tasks

- [x] 把上一轮的观察压成最小复现（`tmp/repro1/` 里逐项二分：循环、循环内重赋值、无循环）
- [x] 复现与对照落库：`test/project/repro/guard-loop-reassign.lua`（复现）、
      `guard-loop-noreassign.lua` / `guard-noloop.lua`（对照，均不报）
- [x] 复现文件里的误报位置加 `---@diagnostic disable-next-line: need-check-nil` 并写明说明
- [x] 修掉上一轮新引入的面板条目：`exp.lua` 的 `---@cast exp LuaParser.Node.Base` →
      `---@diagnostic disable-next-line: inject-field`
- [x] 面板复核（`readProblems`，本仓库、`server/**`、information）：8 → **0**
- [x] 全量 `bin\lua-language-server.exe --test`（绿）+ 本仓库自扫对照（502，未劣化）
- [x] 台账 `facts/narrowing.md` 新增 F19（复现路径 / 机制 / 三次实测候选 / 下一步）+ `--test tools.facts`（绿）
- [x] 同步 `项目实践.md`（第九轮纪要）
- [x] `openspec archive guard-loop-reassign`
