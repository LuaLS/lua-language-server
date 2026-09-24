# Proposal

## Why

上一轮把目标工程的 `need-check-nil` 29 条一族定位到「守卫收窄在诊断时机丢失」，但只能在
4000 行的目标文件里观察。本轮把它压到**仓库内的最小复现**，并顺手清掉面板新增的条目。

- 目标工程仍为 **276** 条；`need-check-nil` 36 条里 **29 条在 `script/parser/compile.lua`**
- 最小复现：`test/project/repro/guard-loop-reassign.lua`（守卫 + 循环内重赋值 + 循环体内读字段）
- 对照组（都**不报**）：`guard-loop-noreassign.lua`（循环内不重赋值）、`guard-noloop.lua`（无循环）
  ⇒ 诱因是「循环内重赋值 + 循环体内的读」这一步

## What Changes

1. 仓库内落三份复现文件（`test/project/repro/`）：1 个复现 + 2 个对照，
   复现文件里的误报位置用 `---@diagnostic disable-next-line: need-check-nil` 标注（附说明），
   这样面板保持干净、排查时去掉那行即恢复信号
2. 修掉上一轮面板清理时**新引入**的一条：`script/parser/ast/exp.lua` 的
   `---@cast exp LuaParser.Node.Base` 被面板的 LS 判成 `cast-type-mismatch`
   （`LuaParser.Node.Exp` 这个别名转不成 `LuaParser.Node.Base`）⇒ 改为
   `---@diagnostic disable-next-line: inject-field`（字段已声明在 `Node.Base`，别名挂不了字段）
3. 台账新增 `facts/narrowing.md` **F19**：复现路径、机制（诊断侧读到未收窄的 `guess`、
   probe 侧却是已收窄值、`Walker` 是 flush 会丢的缓存字段）、三次实测候选与结论

## Capabilities

### New Capabilities

### Modified Capabilities

（无 spec 级行为变更：复现资产 + 面板修复）

## Impact

- `test/project/repro/*`（新增 3 个文件）、`script/parser/ast/exp.lua`（1 行改为 disable 指令）
- `.github/skills/luals-server-dev/references/facts/narrowing.md`（F19）

## 判据（先量后改）

- 目标工程 276 条不变（本轮不动引擎语义）
- 本仓库面板（`readProblems`，`server/**`，`minSeverity=information`）回到 **0**
- 全量 `bin\lua-language-server.exe --test` 保持绿

## 实测结论（2026-09-24）

| 项 | 结果 |
|---|---|
| 本仓库面板 | 8 → **0**（1 条 `exp.lua` cast-type-mismatch + 7 条复现文件的 incomplete-signature-doc） |
| 复现可用性 | 复现文件去掉 disable 即报 `Need check nil`（用 `tmp/repro1/annotated.lua` 复核过同一形状） |
| 目标工程 | 276 → 276（本轮无引擎改动） |
| 全量 `--test` | 绿；`--test tools.facts` 绿 |

## 试过但未采用（记录，不要重走）

见台账 F19：①「清掉 raw currentValue 就 +1 代数」②「每次 flush 批次都 +1 代数」
（复现修好但目标工程 C 栈溢出）③ `addReturnDef`/`addReturnList` 加 `flushCache()`。均已回退。

## 下一步

把「重跑」收敛成编译结束后的一个信号，并防住「walk → flush → 代数推进 → 再 walk」的正反馈
（细节见 F19 的下一步）
