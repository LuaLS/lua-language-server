# Tasks

> 每步先量后改：改动前 `--save`，改后 `--baseline` 比对，只保留「移除 ≥ 新增」的组合。
> 基线已存：`tmp\scan-noreturn-base.txt`（目标工程 216 条）。
> 命令模板（在 server 根目录，`--mem-limit=2` 必带，不要并发跑扫描）：
> `bin\lua-language-server.exe --test project.external-diagnostic --test-project=d:\github\vscode-lua\server --mem-limit=2 --baseline=tmp\scan-noreturn-base.txt`

## 1. 回归测试先红（固定复现）

- [x] 1.1 最小复现写进新测试文件 `test/feature/diagnostic/noreturn.lua`（注解函数 / 未注解包装 / 普通调用负例三条；
  测试环境无 stdlib `error`，直接 `error(...)` 那条改由目标工程基线覆盖）；
  验证：`bin\lua-language-server.exe --test feature.diagnostic.noreturn` 当前为红（`unexpected diagnostic return-type-mismatch`）
- [x] 1.2 在 `test/node/tracer.lua` 加收窄层用例（noreturn 调用结尾 → `if` 之后无 `nil`；普通函数调用 → 仍 `integer | nil`）；
  验证：`bin\lua-language-server.exe --test node.tracer` 当前为红（`attempt to call a nil value (method 'setNoReturn')`）

## 2. LuaCats `---@noreturn`

- [x] 2.1 确认 `---@noreturn` **不需要注册 cat parser**：未注册 subtype 的 cat 就是普通
  `LuaParser.Node.Cat`（`cats/cat.lua:176-183`），与 `---@async` 同路，实测不产生未知注解诊断
  （`tmp/repro-rtm-json/cat.lua` 扫描只有预期的 `return-type-mismatch`，无 `undefined-doc-name` 一类）
- [x] 2.2 `script/vm/coder/function.lua` 在 `getCatGroup(source)` 里按 `cat.subtype == 'noreturn'`
  发射 `{func}:setNoReturn()`（与 async 同形）；验证：`test/feature/diagnostic/noreturn.lua` 第 1 条转绿

## 3. Node：标记与推断

- [x] 3.1 `script/node/function.lua`：`setNoReturn()` / `setFlowTracer()` / `isNoReturn()`（带记忆 +
  环保护），推断走 `ls.node.tailCallNoReturn(units, map)`（shared helper，与 walker 同一份判定）；
  flow 由 `coder:finishTracer(funcKey)` 发射 `{func}:setFlowTracer({tracer})` 挂上（`startTracer` 时
  主函数的 `rt.func()` 尚未执行，故不能在那里发射）；验证：`--test node.tracer` / `--test node.fcall` 绿，
  且 `test/feature/diagnostic/noreturn.lua` 第 2 条（未注解包装 `err`）转绿
- [x] 3.2 收严未知/多目标：`funcVar` 取不到、无 function 成员 → false；多目标要求**全部** noreturn。
  验证：`test/feature/diagnostic/noreturn.lua` 后两条（`any` 形参做被调用者、`fun()` 形参绑到
  `fatal`/`ok` 两个实参）都仍报 `return-type-mismatch`

## 4. walker：分支终止判定

- [x] 4.1 `script/node/tracer.lua` 的 `W:traceIfChild`：`traceBlock` 之后，若该分支最后一个 flow unit
  是对 noreturn 函数的调用 → `terminated = true`（guard 的真实 flow 形状用 `--probe-flow` 实测，
  见 design D1）；验证：`--test node.tracer` 绿（noreturn 收窄用例 + 普通调用负例都在）
- [x] 4.2 目标工程第一次比对（meta 未标注解时）：`216 → 216（移除 0 / 新增 0）` —— 符合预期
  （此时 `error` 还不是 noreturn，`decode_error` 推断不出来），记录在案

## 5. meta 与调用值

- [x] 5.1 `meta/template/basic.lua`、`meta/whimsical/basic.lua` 给 `error` 标 `---@noreturn`；
  验证：目标工程比对 **216 → 199（移除 17 / 新增 0）**（`tmp/cmp-01.txt`），
  比 proposal 预估的 12 条还多 5 条（`parser/lines.lua`、`proto/converter.lua`、`text-merger.lua`、
  `parser/compile.lua:3368`、`tools/lua51.lua` 同族）
- [x] 5.2 （量后决定）`Node.FCall:select`/`value` 在目标全为 noreturn 时返回 `rt.NEVER`：
  实测 **216 → 199 不变（移除 0 / 新增 0）**，诊断耗时 9.74s → 10.12s（+3.9%）⇒ 无收益有成本，
  **已回退**（`tmp/cmp-02.txt`），spec 里对应场景已删除，结论写进 design D3

## 6. 验证与收尾

- [x] 6.1 全量测试绿：`bin\lua-language-server.exe --test` ⇒ 无 `测试失败`（`tmp/full-test-01.txt`）；
  与改动前（`git stash` 后复跑，`tmp/full-test-stashed.txt`）对比同一条既存噪声
  `[Intersection] values cycle detected` 各 1 次，非本轮引入
- [x] 6.2 目标工程基线比对：`216 → 199（移除 17 / 新增 0）` ✓（比预估 12 条多 5 条同族）
- [x] 6.3 本仓库问题面板：从 2 条（自己新加的 `---@field` 位置错，`doc-field-no-class`）修到 **0**
- [x] 6.4 结论上提：`facts/narrowing.md` 新增 F26（机制 + 反例 + 三条「试过未采用」）、
  更新 F15（两次失败尝试 → 本轮落地，状态改「成立」）；`bin\lua-language-server.exe --test tools.facts` 绿
- [x] 6.5 另记 open fact：`facts/view.md` V1 —— `checkSkip`（`script/node/table.lua:727-746,811-813`）
  把已存在字段因位置环藏成 `...`，诊断消息误导（本轮只定位，不动实现）
- [x] 6.6 归档：`openspec archive noreturn-narrowing`（spec 增量并入主 spec），
  更新 `项目实践.md` 第二十一轮摘要
