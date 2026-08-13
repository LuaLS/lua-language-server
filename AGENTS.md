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
- Tests:
  - parser: `test/parser/`
  - node/tracer: `test/node/`
  - feature: `test/feature/`

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

- `test/feature/completion/luadoc.lua` not implemented
- `test/feature/completion/string.lua` not implemented
- One known word-scan offset issue around `myfunc(fa<??>)` in completion tests

## 6) Migration Workflow for Completion Tests

- Migrate in small batches (up to 5 tests per step).
- After migration, remove moved tests from legacy common test file and leave an "already migrated" marker comment at the old location.
- Run completion tests after each migration batch before moving to the next batch.
- `TEST_COMPLETION` uses a bare environment. If a test needs stdlib symbols, define them inside the test snippet.
- If behavior is ambiguous, stop and confirm expected behavior before proceeding.

## 7) Completion Migration Scope Snapshot

- Already migrated:
  - keyword cases (`keyword.lua`)
  - word/local-global cases (`word.lua`)
  - field access cases (`field.lua`)
  - part of special cases (`special.lua`)
- Not implemented yet:
  - LuaDoc completion (`luadoc.lua`)
  - string enum completion (`string.lua`)
  - workspaceWord text completion, metatable `__index`, global stdlib table fields,
    special dotted field names, Chinese field names, function snippet insertText

## 8) Style Note

For multi-condition `if` blocks using `and/or`, keep project-consistent aligned layout.

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
- **例外**：`script/tools/` 目录下不允许使用可选链（保持该目录语法兼容性）。

## 12) PowerShell 文件编码

- Windows PowerShell 默认编码为 GBK/UTF-16 LE，**严禁**写入项目文件时不指定编码（会导致 UTF8 文件乱码）。
- `Set-Content`、`Out-File`、`echo >`、`Write-Output >` 等写入操作必须加 `-Encoding UTF8`。
- 正确示例：`Set-Content -Path file.ts -Value "..." -Encoding UTF8`。
- 项目所有源码文件统一 UTF-8（无 BOM），由 `.editorconfig` 和 ESLint 兜底。

---

Maintainer note:
If this file and runtime reality diverge, update this file first so the next agent run starts from accurate constraints.
