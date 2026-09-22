# Agent Working Notes (Single Entry)

This file is the single project-facing summary exported from previous AI progress.
It is intended for both human collaborators and coding agents.

## 0) 强制流程（每次会话必读，最高优先级）

本仓库是 **4.0.0 完全重构分支**，架构与上游 master 不同（LuaParser.Ast + node 系统 + coder/middle code）。
在本仓库做任何 parser / node / vm / feature / completion 改动前，必须：

0. **先读 `项目实践.md`**：当前阶段（2026-09 起）正在用本仓库 LS 清理目标工程
   `D:\github\vscode-lua\server` 的诊断。遇到诊断先做**语义判断**（写法/注解本身是否有误），
   确认是我们自己实现的误报再进入实现排查。该文件还记录了常用命令、约定与已知未决项。
1. **再读 skill**：`.github/skills/luals-server-dev/SKILL.md` 及其 references
   （`architecture.md`、`module-map.md`、`workflow-and-style.md`），再动手。
   各子系统的具体实现约束以 references 为准（例如 completion 应复用 VM/Node 语义、不要文本扫描）。
   不要凭通用 Lua 经验直接改代码。
2. **改收窄 / 诊断前先读事实台账**：`.github/skills/luals-server-dev/references/facts/<能力>.md`
   （如 `narrowing.md`）。每条 = 断言 / 证据 / 代码 / 状态；`状态: 未满足(open)` 是下一轮入口，
   `试过:` 是被否决的方案与实测数字，**不要重走**。改完把结论上提成一条 fact（`--test tools.facts` 校验引用）。
   台账只记实测事实与反例，不记需求。
3. **不要用上游 master 做对照**（不要跑 master 的二进制 `--check`，也不要拿 master 的输出当"应该报/不该报"的判据）：
   判断只基于本仓库自己的语义、现有测试与目标工程代码本身。实现必须基于本仓库自己的
   node / runtime / coder 机制，不要照搬 master 的 special / vm.compiler 等旧架构概念。
4. 若无法确定某能力应落在哪个子系统，先读 skill 的 references，不要自行猜测。

## 1) Run and Test Rules

- 环境前提（**新机器**）：`bin/` 被 `.gitignore` 忽略、不随仓库走，需要先
  `git submodule update --init --recursive` 再跑 `make.bat`（= `3rd\luamake\luamake.exe rebuild`）拿到宿主二进制。
  `script/` 与 `test/` 都是**脚本**，改完立即生效、不需要重编译；`bin` 只在改 C/VM 层时才需要重建。
- Run tests from the `server` root with:
  - `bin\\lua-language-server.exe --test <suite-or-file>`
- 批量项目扫描（`--test project.external[-diagnostic] --test-project=<path>`）必须带 `--mem-limit=2`
  （默认 10GB 太高），且**不要并发跑多个扫描进程**（会耗光机器内存）；细节见
  `.github/skills/luals-server-dev/references/workflow-and-style.md` 的「批量扫描与内存护栏」。
  - `<path>` 是**目标工程的实际路径**（示例 `D:\github\vscode-lua\server`，换机器可能不同），
    不要假设它固定；台账里的测试路径都是仓库内相对路径，基线文件的 key 也相对目标工程，跨机器可比。
- 诊断基线与探针（跨会话、跨机器通用，都在仓库内，随 git 走）：
  - 存基线 `… --save=tmp\scan-a.txt`，改完 `… --baseline=tmp\scan-a.txt` → 直接打印
    `基线 N 条 → 当前 M 条：移除 x / 新增 y` 与逐条 `- ` / `+ `；**改前必存、改后必比**。
  - 探针 `--test project.probe --test-project=<path> --mem-limit=2 --probe-file=<文件名片段> [--probe-filter=<key 片段>]`
    看某个变量读出来的类型；`--probe-flow=<片段>` 看对应函数的收窄 flow（探针同样会加载整个工程，别漏 `--mem-limit`）。
  - 台账引用校验 `--test tools.facts`（已随 `--test` 全量跑）。
- 新增/修改能力时，`.github/skills/luals-server-dev/references/facts/` 下的台账是**唯一的"当前事实"入口**：
  结论写进台账，过程与时间线写 `项目实践.md`（只留摘要）。
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
- Field reads go through `parentMap` (`{last}:getChild({field})`):
  - `Variable:getExpect` derives a field value from the base's *annotation* path, which folds in the
    spurious nil of a `---@type T?` base. The walker therefore derives field values from the base's
    **flow** value (`W:deriveFieldValue`, used by `W:traceRef` and `W:getFieldNarrowValue`).
  - Adopt a derived value only when it has no nil; derived values are never written back to the
    narrowing stack (a remembered field value would hide later reassignments of the base).
- `---@cast` narrows through the flow (`{'cast', varId, op, typeKey, opt}`):
  - The type value is compiled into the file prelude (`Coder:compileToPrelude`): a cast inside a branch
    must still be readable when the walker walks the whole flow.
  - `op`: nil = assert (use the annotated type), `+` = union, `-` = drop members **by name**
    (not by `canCast`: a subclass of the removed type must survive).
  - Annotation ownership: `parseIfChildElse` starts the block **before** skipping space, otherwise a cat
    right after `else` is recorded on the outer block and such a cast never reaches its branch.

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
- **判空链用可选链**：支持 `?.` `?:` `?(` `?[`，可任意链式——写 `a?.b?.c`、`p?.childs?[i]`、`f?.g()`、`o?:m()`，
  不要写 `a and a.b and a.b.c`。仅 `script/tools/` 例外（该目录不允许可选链）。
  `?.` 之后的类型收窄目前不可靠（上游 master 亦然），因此链上**每一级都带 `?`**（`a?.b?.c`、`a?.b?.c == 1`），
  不要写成依赖收窄的 `a?.b and a.b.c`。
- **字符串格式化用 `%` 形式**：`'{} = {}' % { var, value }`（位置 `{}`、命名 `{name}`、带格式 `{name%q}` / `{%d}`），
  不要用 `('%s = %s'):format(var, value)` 或 `string.format(...)`；多行模板直接用 `[[...{}...]]`。
- 禁止写任何注释；确有必要写注释时，必须先询问用户并得到同意。即便用户同意，注释也只写意图、保持简练，不暴露内部实现细节。
- **语句不要以 `(` 开头**：Lua 的 newline-call 规则会把「上一行以函数调用结尾、下一行以 `(` 开头」连成一条链式调用（如 `print(...)` 后跟 `(g)(nil)` 会解析为 `print(...)(g)(nil)`，对 print 的返回值 nil 调用）。必要时在上一行末尾加 `;` 断句。测试用例同样遵守（`tmp/` 下诊断被屏蔽，此类问题不会被静态诊断提示）。
- 清理诊断：**只关心 info（Information）及以上**（error / warning / information），**hint 一概不管**
  （hint 级存量为项目常态，不主动清理，避免无关重构）。读问题面板用 `minSeverity=information`
  （不要用 hint），批扫报告同样只看这三档。

## 9) Debugging Workflow Rule

- When needed, prefer VSCode-Operator tools to inspect LSP information and drive debugger-based flow tracing.
- Before starting a new debugger run, always stop/disconnect any existing debugger session first.
- Always stop/disconnect debugger sessions after use to avoid stale sessions affecting later tests and diagnosis.
- 设置断点：给函数调用设断点要设在**函数内部的语句**上（如 `self.currentValue = value`），不要设在函数定义行（`function M:xxx()`）。可优先用函数断点功能（VSCode-Operator `debugFunctionBreakpoints`）。

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

## 11.1) `_ENV` flow 追踪

文件开头隐含 `local _ENV = _G`，全局变量读写应使用当前可见的 `_ENV` 作为 parent（flow-sensitive）：

- `coder/block.lua`：`_ENV` 用 `setStaticValue(rt.VAR_G)` 初始化（替代原 `setMasterVariable(rt.VAR_G)` 固定转发）。
- `Variable:getChild`/`getChilds`：`masterVariable` 转发之外，增加「`currentValue`/`staticValue` 是 Variable 时转发」（动态转发），使 `_ENV = {...}` 后全局查找切到新表。
- `coder/state.lua`：`compileAssign` 对 `_ENV`（var/local）即使 table 赋值也 `setStaticValue`（isEnv 判断）。
- `coder/var.lua`：全局 var（`source.env`）生成 `parentMap[name] = { envName, id, true }`（第三元素标记 env 子字段）。
- `tracer.lua`：`traceVar` 记录赋值版本号（`assignVersion`/`versionMap`）；`traceRef` 对 env 子字段，仅当 parent（`_ENV`）版本号 > 自身版本号时从 parent `get` 取字段值（field→value→variable→value 解包），实现「`_ENV` 重赋值使全局失效、全局自身重赋值不失效」。

## 11.2) 未注解表字面量赋值的 flow 值

- `t = {}`（无 `---@type` 注解、值是表字面量）**不**落 `staticValue`（会短路 `equivalentValue` 的 childs 合并语义），改落 `Variable.assignValue`（`coder/state.lua` `compileAssign` 发射 `setAssignValue`）。
- Walker 的 `traceVar` 经 `Variable:getStaticValue()` 优先消费 `assignValue`，并与 master 的 `childsValue` 一起走 `mergeValueResults`（`rt.mergeTables` + union，自 `equivalentValue` 尾部提取的公共逻辑）。
- 修复背景：「`if not t then t = {} end` 后读 `t` 仍为 `table | nil`」导致 need-check-nil 误报（如旧工程 `cli/doc/export.lua` 的 `has_seen`）。
- 注解过的赋值（有 catKey）依旧走 `setStaticValue(catKey)`，注解语义优先。

## 12) PowerShell 文件编码

- Windows PowerShell 默认编码为 GBK/UTF-16 LE，**严禁**写入项目文件时不指定编码（会导致 UTF8 文件乱码）。
- `Set-Content`、`Out-File`、`echo >`、`Write-Output >` 等写入操作必须加 `-Encoding UTF8`。
- 正确示例：`Set-Content -Path file.ts -Value "..." -Encoding UTF8`。
- 项目所有源码文件统一 UTF-8（无 BOM），由 `.editorconfig` 和 ESLint 兜底。

## 13) Diagnostic Feature Snapshot

诊断功能完整实现约束见 `.github/skills/luals-server-dev/references/diagnostic.md`。

- 里程碑 1 已完成：诊断引擎 + push/pull 管道 + 配置过滤 + `---@diagnostic` 禁用注释 + 语法诊断 provider。
- 里程碑 2 进行中：已迁移 31 条规则（parser-only + VM 语义：`undefined-field`/`undefined-global`/`deprecated`/`need-check-nil`/`redundant-parameter`/`missing-parameter`/`assign-type-mismatch`/`param-type-mismatch`/`return-type-mismatch`/`global-in-nil-env`/`await-in-sync`）。
- 核心链路：主线程 `ls.feature.diagnostic(uri)` 遍历 provider；语法错误读 `vfile.coder.errors`；VM 语义规则复用 `vfile:getNode`/`getVariable` + Node 查询（`get`→exists、`globalGet`→isDefined、`hasAnnotation`）。
- 扩展点：`ls.feature.provider.diagnostic(callback)`，回调 `async fun(param)` 返回 `Feature.Diagnostic[]`；`param` 含 `uri/scope/document/ast/errors/vfile`。
- 测试：`--test feature.diagnostic`；codes 语义 `'code'`=必须有、`'-code'`=必须没有、`{}`=0 诊断；诊断 harness 已加载 stdlib meta。

---

Maintainer note:
If this file and runtime reality diverge, update this file first so the next agent run starts from accurate constraints.
