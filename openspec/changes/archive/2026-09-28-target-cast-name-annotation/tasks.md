# Tasks

- [x] 判断归属：`[integer]: parser.object|any`（`guide.lua:80`）太宽 + luadoc 构造节点 `[1]` 是字符串
      （`luadoc.lua:232-238`）⇒ 目标工程侧加内联 cast
- [x] 探针定位真正出问题的实参（`--probe-filter=@1861` → `(string, parser.object | truthy)` ⇒ 第 2 个 `name`）
- [x] 目标工程 1861 / 1884：`matchKey(source[1], name--[[@as string]])`
- [x] 目标工程基线比对（`--baseline`）：220 → 218，移除 2 / 新增 0
- [x] 落对照组 `test/project/repro/inline-cast-index.lua`（`return` / `if` / 无 cast 三态，0 诊断）
- [x] `bin\lua-language-server.exe --test` 全量绿
- [x] 本仓库问题面板（`vscodeOperator_readProblems`，`minSeverity=information`）= 0
- [x] 复现目录自检 = 0 诊断
- [x] 台账 `facts/casts.md` 新增 F2 并跑 `--test tools.facts`
- [x] 本轮纪要写进 `项目实践.md`（第十七轮）
