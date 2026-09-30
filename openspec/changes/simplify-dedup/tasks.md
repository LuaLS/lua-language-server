# Tasks

> 验证口径：全量 `bin\lua-language-server.exe --test` 绿 + 目标工程
> `--test project.external-diagnostic --test-project=d:\github\vscode-lua\server --mem-limit=2 --baseline=tmp\scan-156.txt`
> 仍是 **154（removed 2 / added 0）** + 本仓库面板 0。

- [ ] 1.1 `script/utility.lua`：在 `m.visited` 旁新增 `m.simplify(node, visited)`
  （「沿 `.value` 链委派 + visited 防环」的唯一实现）
- [ ] 1.2 6 处同形覆盖体改为一行 `return ls.util.simplify(self, visited)`：
  `script/node/param_of.lua:47`、`select.lua:61`、`spread.lua:87`、`subtract.lua:85`、
  `ternary.lua:22`、`variable.lua:1251`（保留各自 `---@param visited?` / `---@return Node` 注解）
- [ ] 1.3 验证：全量 `--test` 绿；目标工程 154（0/0）；面板 0；`git diff --stat` 确认净减行数
- [ ] 1.4 收尾：`项目实践.md` 记一句（审计表 + 「其余 visited 站点为什么不收编」）；归档本 change
