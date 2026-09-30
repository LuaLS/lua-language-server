# Tasks

> 验证口径：全量 `bin\lua-language-server.exe --test` 绿 + 目标工程
> `--test project.external-diagnostic --test-project=d:\github\vscode-lua\server --mem-limit=2 --baseline=tmp\scan-156.txt`
> 仍是 **154（removed 2 / added 0）** + 本仓库面板 0。

- [x] 1.1 `script/utility.lua`：在 `m.visited` 旁新增 `m.simplify(node, visited)`
  （「沿 `.value` 链委派 + visited 防环」的唯一实现；注释标明 per-traversal 语义、不要换成 ctx）
- [x] 1.2 6 处同形覆盖体改为一行 `return ls.util.simplify(self, visited)`：
  `param_of` / `select` / `spread` / `subtract` / `ternary` / `variable`（保留各自注解）
- [x] 1.3 验证：全量 `--test` 绿；目标工程 **154（removed 2 / added 0）**；面板 0；
  `git diff --stat` = `7 files changed, 22 insertions(+), 54 deletions(-)`（净 **-32 行**，零行为变化）
- [x] 1.4 收尾：`项目实践.md` 第二十七轮已记（审计表 + 为什么其余站点不收编）；本 change 已归档
