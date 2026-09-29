# Tasks

> 每步先量后改：`--baseline=tmp\scan-199.txt`（199）比对，并用 `walkDebug` 对比 walk 次数 / maxDepth
> （基线：walks 3212、nested 668、maxDepth 10）。命令模板（根目录，`--mem-limit=2` 必带，不并发）：
> `bin\lua-language-server.exe --test project.external-diagnostic --test-project=d:\github\vscode-lua\server --mem-limit=2 --baseline=tmp\scan-199.txt`

## 1. 机制改造（护栏先行，避免上次的爆栈）

- [x] 1.1 `Node.Tracer:restart()` + `hasWalker` 标记（`walker` getter 里置位）：`--test node.tracer` 绿
- [x] 1.2 `W:start` 护栏（`walking` 不重入）+ `xpcall` 异常清理；`W:restart()`（走的过程中不动）：`--test node.tracer` 绿
- [x] 1.3 量：`walkDebug` 显示 walks=1000 / nested=125 / **maxDepth=10** ⇒ 护栏有效
  （前三次数千层的 walk 深链没有复现）

## 2. 触发点：pass 边界（求值链之外）

- [x] 2.1 在 `value` getter 里按需 `retrace`（惰性嗅探版）：**实测仍爆栈**（求值环被重新喂活，
  `table.lua:97` / `skipping 1981 levels`）⇒ 放弃该触发点
- [x] 2.2 改到 `ls.feature.diagnostic(uri)`：拿到 vfile 后遍历 `coder.map` 的 tracer 节点逐个 `restart()`
- [x] 2.3 目标工程比对：**199 → 156（移除 36 / 新增 0）**（`tmp/cmp-final3.txt`）；
  比预估的 15 条多 21 条 —— **F19 的 `child.*` 一族也被带掉**；扫描耗时 10.3s → 10.56s（无回归）
- [x] 2.4 回归测试：`test/node/tracer.lua` 两组用例（flush 后 `restart` 能恢复收窄 / 不 `restart` 则退化）
- [x] 2.5 收尾：去掉 `walkDebug` 与 `tracedValue` 等临时插桩

## 3. 连带验证（F19）

- [x] 3.1 F19 的 `child.start/finish/parent` 一族（`compile.lua:3043/3044/3048/3051/3052/3053/3112/3113/…`）
  在移除清单里 ⇒ 同一根因确认，F19 随之关闭

## 4. 收尾

- [x] 4.1 全量测试绿：`bin\lua-language-server.exe --test`（`tmp/full-final2.txt`）
- [x] 4.2 本仓库问题面板 0（自己引入的 `need-check-nil` 已按 `?.` 收窄不可靠的约定改成显式判空）
- [x] 4.3 `facts/narrowing.md`：F27 → 成立（带 199 → 156 与两次爆栈实测）、F19 → 关闭；
  `--test tools.facts` 绿
- [ ] 4.4 归档：`openspec archive narrow-flush-rewalk`，更新 `项目实践.md` 第二十二轮结论
