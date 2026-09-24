# Proposal

## Why

上一轮（`self-scan-cleanup-1`）我拿 `--test project.external-diagnostic` 自举扫本仓库当判据，
这违反了既定约定：**本仓库的诊断以问题面板为准**（`vscodeOperator_readProblems`），
自扫只做批量统计/回归对照。用户指出后，规则已改为面板优先。

按面板（`workspacePath = d:\github\vscode-lua-4\server`，`pathGlob = d:/github/vscode-lua-4/server/**`，
`minSeverity = information`）读到的实际存量是 **15 条 warning**（不是自扫的 508 条）：

| 文件 | code | 说明 |
|---|---|---|
| `script/node/node.lua:408` | param-type-mismatch | `rt.value(value)` 实参是 `Node.Key`（含 Node 的联合） |
| `script/node/union.lua:279` | param-type-mismatch | 同上 |
| `script/node/tracer.lua:1176` | undefined-field | `ownNode:getExpectValue()`，参数注解写成 `Node?` |
| `script/node/tracer.lua:18` | assign-type-mismatch | `self.map = map`（`table<string, Node>` → `Node.Variable`） |
| `script/parser/ast/exp.lua:142` | inject-field | `exp.catAs = typeExp`，`catAs` 未声明 |
| `script/tools/mem-guard.lua:51/55` | duplicate-set-field | 故意覆盖 `coroutine.create` / `wrap`（内存护栏） |
| `test/feature/diagnostic/config.lua:7` | missing-fields | 假 root 缺 `uriSet` |
| `test/node/narrow.lua:9` | assign-type-mismatch | 把字段列表当 `rt.class` 的 `extends` 传（实际不生效） |
| `test/parser/ast/exp.lua:637/647` | undefined-field | `nodesMap` 元素是 `Base`，读 `exps` |
| `test/project/external-diagnostic.lua:208/213` | undefined-field | `ls.args.SAVE` / `BASELINE` 未声明 |
| `test/project/probe.lua:103` | param-type-mismatch | `ls.args.PROBE_CODE` 是 `boolean|string` |
| `test/tools/facts.lua:8` | param-type-mismatch | `getChilds` 返回 `Uri[]?` |

## What Changes

逐条清（都是本仓库自己的注解/用例问题，不动引擎语义）：

- `node.lua` / `union.lua`：`rt.value(value)` 前加 `---@cast value boolean|string|number`
- `tracer.lua`：`self.map` 的诚实类型是 `table<string, Node>`（Coder 的 alias 表里既有变量也有字面量值），
  `@field map` / `M:__init` / `W:__init` / `rt.tracer` 四处一起统一，变量语义的使用点按需
  `---@cast node Node.Variable`（`traceVar` / `traceRef` 两处 / `isDynamicKeyRef` / `getFuncVar` /
  `limitByOwnValue` 的两个调用点 / `traceByValue` 的闭包兜底）；`limitByOwnValue` 的参数回到 `Node?`
- `parser/ast/base.lua`：`LuaParser.Node.Base` 补 `@field catAs? LuaParser.Node.CatExp`；
  `parser/ast/exp.lua:142` 处 `---@cast exp LuaParser.Node.Base`（面板 LS 要的是「class 类型」）
- `mem-guard.lua`：两处覆盖加 `---@diagnostic disable-next-line: duplicate-set-field`（刻意覆盖）
- `runtime/make-args.lua`：补 `SAVE` / `BASELINE` 声明（连同上一轮的 `PROBE_*`）
- 测试侧：`config.lua` 假 root 补 `uriSet = {}`；`narrow.lua` 改用 `rt.class('A'):addField(...)`
  （原来的写法把字段塞进 `extends`，运行时并不生效）；`parser/ast/exp.lua` 两处 `---@cast ret
  LuaParser.Node.Node…`；`facts.lua` `---@cast childs Uri[]`；`probe.lua` 把 `PROBE_CODE` 收进局部

## Capabilities

### New Capabilities

### Modified Capabilities

（无 spec 级行为变更：全是注解 / 用例修正）

## Impact

- `script/node/{node,union,tracer,runtime}.lua`、`script/parser/ast/{base,exp}.lua`、
  `script/tools/mem-guard.lua`、`script/runtime/make-args.lua`、`test/**` 若干

## 判据（先量后改）

- **面板**：`readProblems`（本仓库，minSeverity=information）15 条 → 目标 0
- 全量 `bin\lua-language-server.exe --test` 保持绿
- 自扫（`--baseline=tmp/self-scan-baseline.txt`）作为批量回归对照，只要求不劣化

## 实测结论（2026-09-24）

| 项 | 结果 |
|---|---|
| 面板 | **15 → 0**（`readProblems` 返回 `total: 0`） |
| 全量 `--test` | 绿 |
| 自扫对照 | 508 → **502**（移除 25 / 新增 19；有相当部分是行号位移造成的成对条目） |

## 试过但未采用（记录，不要重走）

- `self.map` 直接注解成 `table<string, Node.Variable>`（面板那条 assign 会消失），
  但 `rt.tracer(r, p)` 在 9 个测试文件里的 `r` 实际混装变量与字面量值 → 新增 9 条；
  改回诚实的 `table<string, Node>` + 使用点 cast 才是对的做法
- 给未注册的表类（`---@class ActivePool` + `local M = {}`，不是 `Class()`）加 `@field` 不生效（见上一轮）
- 只改注解不足以清 `mem-guard` 的 `duplicate-set-field`（刻意覆盖）→ 用 `---@diagnostic` 注明意图
