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

Remaining skipped cases are marked `[SKIPPED]` in each completion test file（详见各测试文件注释）：
- `[config-dependent]`：依赖 config.set，剩余 require '<?>' count=9（跨文件/文件系统）
- `[stdlib-dependent]`：TEST_COMPLETION harness 已加载 meta 标准库，跨文件补全可用；剩余 SKIPPED 项可分批迁移
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
- 完整调研结论沉淀在 `.github/skills/luals-server-dev/references/tree-sitter-pre-research.md`。
- 若重启此方向，先读该文档，特别是第 5 节（关键障碍）与第 8 节（spike plan）。
- 结论摘要：替换性价比低；tree-sitter 更适合前端侧（高亮/折叠/结构搜索）或给现有 parser 做定点增量。

## 11) 可选链语法

- 本工程（含 bee.lua 解释器，由 `BEE_OPTCHAIN` 宏启用）支持 `?.` `?:` `?[` `?(` 可选链写法，可以省略判空。
- LS 的 parser / coder / node 类型系统也已支持这 4 个符号：
  - 由 `Lua.runtime.nonstandardSymbol` 配置（`scope:makeCompileOptions` 读取）开启，未开启时解析报 `ERR_NONSTANDARD_SYMBOL`。
  - parser 在 `parseField`/`parseCall` 通过 `?` 后紧跟 `.`/`:`/`[`/`(` 识别，AST 的 `Field`/`Call` 节点带 `safe` 标记，并在 `parseTerm` 链循环中沿链传播。
  - coder 对 safe 字段/调用生成 `:setOptional()`；`Node.Variable`/`Node.FCall` 的 `value` 在 optional 时并入 `nil`。
- **例外**：`script/tools/` 目录下不允许使用可选链（保持该目录语法兼容性）。
- **多返回值场景**：运行时支持可选链；如有必要（尤其是需要保留多返回值时），可用 `Obj?:getManyResults()` 语法——`?:` 安全方法调用会保留方法的多返回值（区别于链式取值只取第一个返回值的场景）。
## 12) PowerShell 文件编码

- Windows PowerShell 默认编码为 GBK/UTF-16 LE，**严禁**写入项目文件时不指定编码（会导致 UTF8 文件乱码）。
- `Set-Content`、`Out-File`、`echo >`、`Write-Output >` 等写入操作必须加 `-Encoding UTF8`。
- 正确示例：`Set-Content -Path file.ts -Value "..." -Encoding UTF8`。
- 项目所有源码文件统一 UTF-8（无 BOM），由 `.editorconfig` 和 ESLint 兜底。

## 13) Diagnostic Feature Snapshot

诊断功能完整实现约束见 `.github/skills/luals-server-dev/references/diagnostic.md`。

- 里程碑 1 已完成：诊断引擎 + push/pull 管道 + 配置过滤 + `---@diagnostic` 禁用注释 + 语法诊断 provider。
- 里程碑 2 进行中：已迁移 24 条规则（parser-only + VM 语义：`undefined-field`/`undefined-global`/`deprecated`/`need-check-nil`）。
- 核心链路：主线程 `ls.feature.diagnostic(uri)` 遍历 provider；语法错误读 `vfile.coder.errors`；VM 语义规则复用 `vfile:getNode`/`getVariable` + Node 查询（`get`→exists、`globalGet`→isDefined、`hasAnnotation`）。
- 扩展点：`ls.feature.provider.diagnostic(callback)`，回调 `async fun(param)` 返回 `Feature.Diagnostic[]`；`param` 含 `uri/scope/document/ast/errors/vfile`。
- 测试：`--test feature.diagnostic`；codes 语义 `'code'`=必须有、`'-code'`=必须没有、`{}`=0 诊断；诊断 harness 已加载 stdlib meta。

---

Maintainer note:
If this file and runtime reality diverge, update this file first so the next agent run starts from accurate constraints.
