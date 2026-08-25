# Agent Working Notes (Single Entry)

This file is the single project-facing summary exported from previous AI progress.
It is intended for both human collaborators and coding agents.

## 0) 强制流程（每次会话必读，最高优先级）

本仓库是 **4.0.0 完全重构分支**，架构与上游 master 不同（LuaParser.Ast + node 系统 + coder/middle code）。
在本仓库做任何 parser / node / vm / feature / completion 改动前，必须：

1. **先读 skill**：`.github/skills/luals-server-dev/SKILL.md` 及其 references
   （`architecture.md`、`module-map.md`、`workflow-and-style.md`），再动手。
   各子系统的具体实现约束以 references 为准（例如 completion 应复用 VM/Node 语义、不要文本扫描）。
   不要凭通用 Lua 经验直接改代码。
2. **上游 master 只作为"期望行为"参考，不作为"实现方式"参考**：实现必须基于本仓库自己的
   node / runtime / coder 机制，不要照搬 master 的 special / vm.compiler 等旧架构概念。
3. 若无法确定某能力应落在哪个子系统，先读 skill 的 references，不要自行猜测。

## 1) Run and Test Rules

- Run tests from the `server` root with:
  - `bin\\lua-language-server.exe --test <suite-or-file>`
- Do not run tasks `PreCompile` or `Compile` for feature work in this repo context.
- Keep changes focused. Avoid unrelated refactors and broad formatting-only edits.
- Put temporary debug outputs in `tmp/` only.

## 2) Where Changes Belong

- Parser / syntax:
  - `script/parser/ast/`
  - LuaCats: `script/parser/ast/cats/`
- Type node system:
  - `script/node/`
  - Register new nodes in `script/node/init.lua`
- VM / middle code:
  - `script/vm/coder/`
- Diagnostics（LSP 静态分析）:
  - `script/feature/diagnostic/`
  - `---@diagnostic` 注解解析: `script/parser/ast/cats/diagnostic.lua`
- Tests:
  - parser: `test/parser/`
  - node/tracer: `test/node/`
  - feature: `test/feature/`
  - config: `test/config/`（功能性断言，不要硬编码配置键数量，避免追加键时改旧测试）

## 3) Tracer and Narrowing Constraints

- Prefer the new narrowing path in `script/node/tracer.lua`.
- Do not add new narrowing features into legacy flow/branch code in:
  - `script/vm/coder/flow.lua`
  - `script/vm/coder/branch.lua`
- `self.map` in tracer is strict by design.
  - If you see `No such key`, do not bypass with `pcall` or `rawget`.
  - Check generated middle code and flow data first (`LAST_CODE`, `LAST_FLOW`).
  - If needed, inspect failed coder logs and verify read-before-write ordering of keys.

## 4) Worker/Thread Boundary Rules

Data crossing worker channels must be serializable plain data only:

- Allowed: string, number, boolean, and nested plain tables.
- Not allowed: functions, userdata, thread objects, complex objects with metamethod behavior.

## 5) Completion Feature Snapshot

Key files:

- `script/feature/completion.lua`
- `script/feature/text-scanner.lua`
- `test/feature/completion/`

Implemented providers:

- keyword
- local variable
- field access (`.` / `:`)
- global variable (with local shadow handling)

Known open points:

- ~~One known word-scan offset issue around `myfunc(fa<??>)` in completion tests~~ 已修复（`util.getCompletionWord` 的"空格后回退取左词"逻辑删除，空 word 由 provider 位置守卫处理）
- Remaining skipped cases are marked `[SKIPPED]` in each completion test file:
  - `[config-dependent]`：依赖 config.set（config 系统已接入）；`_G['z.b.c']` version、中文字段名（unicodeName）、GGG<?>（callSnippet）已迁移，剩余 require '<?>' count=9（跨文件/文件系统）
  - `[stdlib-dependent]`：跨文件全局字段推断已修复（`Node.Runtime.generation` + `VM.Vfile.rtGeneration`：`rt:reset()` 后 vfile 不再被版本短路跳过，coder 会重跑、全局绑定重建）。TEST_COMPLETION harness 已加载 meta 标准库，`io.<?>` 等跨文件补全可用（field.lua 已有一例 EXISTS）。注意：stdlib 全局参与 word 模糊匹配（`stringSimilar` 字符集近似，master 同款语义），相关用例需用 include/函数断言。剩余 SKIPPED 项可分批迁移
  - `[legacy-*-context]` / `[description]`：旧上下文行为或 description 断言，行为未定

本仓库相对 master 的匹配语义修正：

- `stringSimilar` 对含高位字节的 word 走前缀匹配（位掩码对 >127 字节溢出为 0 会匹配一切）
- 空 word 位置守卫：word 后空格（表构造器键后等）不出局部/全局补全；`local x = ` 空 word rhs 不出全局（对齐 master）

## 6) Migration Workflow for Completion Tests

- Migrate in small batches (up to 5 tests per step).
- After migration, remove moved tests from legacy common test file and leave an "already migrated" marker comment at the old location.
- Run completion tests after each migration batch before moving to the next batch.
- `TEST_COMPLETION` uses a bare environment. If a test needs stdlib symbols, define them inside the test snippet.
- If behavior is ambiguous, stop and confirm expected behavior before proceeding.
- 实现老测试的期望行为不是强制义务：若测试期望不合理、或与本分支新设计冲突，可以不实现，保留 `[SKIPPED]` 标记并说明分歧，留待讨论后再定。

## 7) Completion Migration Scope Snapshot

- Already migrated and implemented:
  - keyword cases (`keyword.lua`)
  - word/local-global cases (`word.lua`)
  - field access cases (`field.lua`)
  - part of special cases (`special.lua`)
  - LuaDoc completion (`luadoc.lua`)
  - string enum completion (`string.lua`)
  - workspaceWord text completion, metatable `__index`, function snippet insertText
- Remaining skipped cases are marked `[SKIPPED]` per file（config-dependent 项可借已接入的 config 系统解锁）

## 8) Style Note

- For multi-condition `if` blocks using `and/or`, keep project-consistent aligned layout.
- 禁止写任何注释；确有必要写注释时，必须先询问用户并得到同意。即便用户同意，注释也只写意图、保持简练，不暴露内部实现细节。
- **语句不要以 `(` 开头**：Lua 的 newline-call 规则会把「上一行以函数调用结尾、下一行以 `(` 开头」连成一条链式调用（如 `print(...)` 后跟 `(g)(nil)` 会解析为 `print(...)(g)(nil)`，对 print 的返回值 nil 调用）。必要时在上一行末尾加 `;` 断句。测试用例同样遵守（`tmp/` 下诊断被屏蔽，此类问题不会被静态诊断提示）。

## 9) Debugging Workflow Rule

- When needed, prefer VSCode-Operator tools to inspect LSP information and drive debugger-based flow tracing.
- Before starting a new debugger run, always stop/disconnect any existing debugger session first.
- Always stop/disconnect debugger sessions after use to avoid stale sessions affecting later tests and diagnosis.

## 10) tree-sitter 预研状态（已暂停）

- 2026-08-10 决定暂时搁置"用 tree-sitter 替代 lexer + parser"的预研。
- 完整调研结论（架构盘点、社区 grammar 差距、关键障碍、动态规则方案 A/B/C、spike plan）沉淀在 `.github/skills/luals-server-dev/references/tree-sitter-pre-research.md`。
- 若重启此方向，先读该文档，特别是第 5 节（关键障碍）与第 8 节（spike plan）。
- 结论摘要：替换性价比低；tree-sitter 更适合前端侧（高亮/折叠/结构搜索）或给现有 parser 做定点增量。

## 11) 可选链语法

- 本工程（含 bee.lua 解释器，由 `BEE_OPTCHAIN` 宏启用）支持 `?.` `?:` `?[` `?(` 可选链写法，可以省略判空。
- LS 的 parser / coder / node 类型系统也已支持这 4 个符号：
  - 由 `Lua.runtime.nonstandardSymbol` 配置（`scope:makeCompileOptions` 读取）开启，未开启时解析报 `ERR_NONSTANDARD_SYMBOL`。
  - parser 在 `parseField`/`parseCall` 通过 `?` 后紧跟 `.`/`:`/`[`/`(` 识别，AST 的 `Field`/`Call` 节点带 `safe` 标记，并在 `parseTerm` 链循环中沿链传播。
  - coder 对 safe 字段/调用生成 `:setOptional()`；`Node.Variable`/`Node.FCall` 的 `value` 在 optional 时并入 `nil`。
- **例外**：`script/tools/` 目录下不允许使用可选链（保持该目录语法兼容性）。
## 12) PowerShell 文件编码

- Windows PowerShell 默认编码为 GBK/UTF-16 LE，**严禁**写入项目文件时不指定编码（会导致 UTF8 文件乱码）。
- `Set-Content`、`Out-File`、`echo >`、`Write-Output >` 等写入操作必须加 `-Encoding UTF8`。
- 正确示例：`Set-Content -Path file.ts -Value "..." -Encoding UTF8`。
- 项目所有源码文件统一 UTF-8（无 BOM），由 `.editorconfig` 和 ESLint 兜底。

## 13) Diagnostic Feature Snapshot

里程碑 1 已完成：诊断引擎 + push/pull 管道 + 配置过滤 + `---@diagnostic` 禁用注释 + 语法诊断 provider。
里程碑 2 进行中：已迁移语义规则 `empty-block`、`unused-local`（provider + define 注册 + `Opened` status）。

关键文件：

- `script/feature/diagnostic/init.lua` — 引擎 `ls.feature.diagnostic(uri)`、provider 注册、过滤
- `script/feature/diagnostic/providers/` — 各规则 provider：`syntax`（语法错误，来自 `vfile.coder.errors`）、`empty-block`、`unused-local`
- `script/feature/diagnostic/define.lua` — 规则默认 severity/neededFileStatus/group 解析 + `M.register` 注册表
- `script/feature/diagnostic/disable.lua` — `---@diagnostic` 行区间 + 计数判定
- `script/feature/diagnostic/file.lua` — `Feature.Diagnostic.File` 类（挂 `vfile.diagnostic`），贡献者模型：`contribute(items)→dispose`、`refresh()`（文件诊断）、`schedulePush()`（防抖）、`push()`（合并/对比/发布）、`dispose()`
- `script/feature/diagnostic/merge.lua` — 诊断排序 + 同位置去重（保留最高等级），引擎与 File 合并共用
- `script/feature/diagnostic/scope.lua` — `Feature.Diagnostic.Scope` 类（挂 `scope.diagnostic`），`fetchAll()` 批量诊断汇总（task 维护可 reject）
- `script/feature/diagnostic/converter.lua` — `Feature.Diagnostic[]` → `LSP.Diagnostic[]`
- `script/feature/diagnostic/push.lua` — `publishDiagnostics`（`ls.task` reject 防抖），仅 server 模式经 `main.lua` 挂载
- `script/language-server/capability/language-features/diagnostic.lua` — pull `textDocument/diagnostic`
- `script/parser/ast/cats/diagnostic.lua` — `---@diagnostic` cat 节点与解析

约束与语义：

- 内部诊断结构用 0-based 字节偏移（`start`/`finish`），LSP range 转换统一走 converter。
- **语法错误来源（重要）**：语法错误由 coder 编译产物提供——`coder.makeFromAst` 序列化 `ast.errors`（`errorCode/start/finish/code/extra` plain data）到 `coder.errors`，子线程 `makeCode` 返回后 `makeFromFile` 赋给 `coder.errors`。诊断 `syntax` provider 读 `param.errors`（`vfile.coder.errors`），不再走主线程 `document.ast.errors`。语法错误同样经 `merge.merge` 去重（同位置保留最高等级）。
- **后续目标（已记录）**：主线程只解析当前正在修改的文件；能直接通过语法分析获得的诊断都应改由子线程完成（语义规则仍依赖主线程 `nodesMap`，后续逐步迁移）。
- 语法诊断恒为 Error、不走 neededFileStatus，仅受 `Lua.diagnostics.disable` 与行内禁用注释约束（对齐 master）。
- `---@diagnostic` 语义对齐 master：`disable`/`enable` 自下一行生效、`disable-line` 当行、`disable-next-line` 下一行；裸 `disable`（无名）不压语法错误；计数支持嵌套。
- `diagnosticProvider`：`interFileDependencies=false`、`workspaceDiagnostics=false`。
- **状态模型（重要）**：每个文件的诊断状态存在 `vfile.diagnostic`（`Feature.Diagnostic.File`，懒创建）。贡献者模型：`contribute(items)` 添加一批诊断并返回 dispose 函数，`refresh()` 跑文件诊断（先 dispose 旧文件贡献，`version == vfile.version` 时跳过重跑）。push 与 pull 都经 `refresh()` 触发，`schedulePush()` 防抖后 `push()` 合并所有贡献 → 排序去重（merge.lua）→ 对比 `self.results` → 变化则更新并 `publishDiagnostics`。不要自维护诊断缓存表。
- **Task 模型（重要）**：push 防抖用 `ls.task`（`File.schedulePush` 里 reject 旧 task）；`Feature.Diagnostic.Scope:fetchAll()` 批量诊断也用 task 维护，新诊断进来 reject 旧批量过程。不要用 `await.setID`/`await.close`（本分支无此 API）。
- **push 触发时机（重要）**：单文件诊断无延迟，仅 0.1s 防抖（`File` 内 `DELAY`），不读 workspace 延迟配置（工作区诊断未实现）。文件变化/新增 → `onDidChange` → `File:refresh`（先 dispose 旧贡献再重跑）；文件删除 → `onDidRemove` → `File:dispose`（清贡献 + 推送空 `diagnostics: {}`）；`ls.scope.onDidLoad` → 对 scope 下所有 vfile 重新 `refresh`（初次加载/config 变化后兜底）。
- **scope 就绪（重要）**：`scope.ready` 在 reload 协程真正完成时才置 true，完成时 `ls.scope.onDidLoad:fire(scope)`。`File.refresh` 与 `scope.watchFiles` 的 `onDidChange` 索引都先 `ls.scope.waitReady(uri)`，避免在 `.luarc.json`/客户端配置加载前用默认 `Lua.runtime.version` 编译（否则 Lua 5.5 语法被 5.4 规则误报）。
- `unused-local` 豁免：`_`、`_ENV`、`isGlobal`、`<close>`、local function 名（parent=function）、for 循环变量（parent=for）；以 `#loc.gets==0` 判未读。
- 测试用 `<??>`/`<?x?>` catch mark 断言诊断区间（`TEST_DIAGNOSTIC` 自动比对 `catched['?']` 与 `start/finish`）。
- push 暂不带 `version` 字段。
- `define.getSeverity`/`getFileStatus` 仅语义规则路径会用到。

测试：`--test feature.diagnostic`（syntax / config / disable / converter / push / pull / empty-block / unused-local）。

待定（里程碑 2+）：语义规则分批迁移、workspace 诊断、locale 文案、codeDescription、quickfix。

---

Maintainer note:
If this file and runtime reality diverge, update this file first so the next agent run starts from accurate constraints.
