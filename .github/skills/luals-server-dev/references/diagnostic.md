# Diagnostic Feature 详情

> 本文档是 `AGENTS.md` 第 13 节的展开。诊断改动的完整实现约束在这里；AGENTS.md 只保留入口摘要。

## 里程碑

- 里程碑 1 已完成：诊断引擎 + push/pull 管道 + 配置过滤 + `---@diagnostic` 禁用注释 + 语法诊断 provider。
- 里程碑 2 进行中：已迁移语义规则（主线程计算）：
  - parser-only：`empty-block`、`unused-local`、`unused-function`、`unused-label`、`unused-vararg`、`redefined-local`、`trailing-space`、`redundant-return`、`code-after-break`、`duplicate-index`、`duplicate-doc-param`、`unbalanced-assignments`、`unknown-diag-code`、`lowercase-global`、`redundant-value`、`count-down-loop`、`undefined-doc-param`、`close-non-object`、`newline-call`、`newfield-call`
  - VM 语义：`undefined-field`、`undefined-global`、`deprecated`、`need-check-nil`、`redundant-parameter`、`missing-parameter`、`assign-type-mismatch`、`param-type-mismatch`、`return-type-mismatch`、`global-in-nil-env`

## 关键文件

- `script/feature/diagnostic/init.lua` — 引擎 `ls.feature.diagnostic(uri)`（async）、provider 注册、过滤
- `script/feature/diagnostic/parser-diagnostics.lua` — parser-only 规则共用纯函数（`push`、`hasStatements`、`isExcludedLocal`、`isInStringOrComment`）
- `script/feature/diagnostic/providers/syntax.lua` — 语法错误 provider（读 `vfile.coder.errors`），末尾 `return { messages = messages }` 导出错误码→文案表，供 `unknown-diag-code` 复用合法码集合
- `script/feature/diagnostic/define.lua` — 规则默认 severity/neededFileStatus/group 解析 + `M.register` 注册表
- `script/feature/diagnostic/disable.lua` — `---@diagnostic` 行区间 + 计数判定
- `script/feature/diagnostic/file.lua` — `Feature.Diagnostic.File` 类（挂 `vfile.diagnostic`），贡献者模型：`contribute(items)→dispose`、`refresh()`、`schedulePush()`（防抖）、`push()`（合并/对比/发布）、`dispose()`
- `script/feature/diagnostic/merge.lua` — 诊断排序 + 同位置去重（保留最高等级），引擎与 File 合并共用
- `script/feature/diagnostic/scope.lua` — `Feature.Diagnostic.Scope` 类（挂 `scope.diagnostic`），`fetchAll()` 批量诊断汇总
- `script/feature/diagnostic/converter.lua` — `Feature.Diagnostic[]` → `LSP.Diagnostic[]`
- `script/feature/diagnostic/push.lua` — `publishDiagnostics`（监听 file 事件），仅 server 模式经 `main.lua` 挂载
- `script/language-server/capability/language-features/diagnostic.lua` — pull `textDocument/diagnostic`
- `script/parser/ast/cats/diagnostic.lua` — `---@diagnostic` cat 节点与解析

## 各规则实现要点

| 规则 | 实现要点 |
|---|---|
| `duplicate-index` | 带 `related` 信息 + `Unnecessary` tag 区分覆盖项 |
| `unknown-diag-code` | 合法码集合 = `define.diagnosticDatas` 键 + `syntax.messages` 键 lowercase-hyphen 化 |
| `lowercase-global` | 检测 `assign.exps` 中 `var.loc==nil` 且 `var.global~=true` 的小写隐式全局赋值，读 `Lua.diagnostics.globals`/`globalsRegex` 豁免 |
| `duplicate-doc-param` | block.cats 行邻接分组关联 function |
| `undefined-doc-param` | 从 function 出发反向收集 `func.startRow-1` 起连续 cat |
| `code-after-break` | 同时处理 `break`/`continue`（continue 需 `Lua.runtime.nonstandardSymbol` 启用，测试环境默认不启用故无用例） |
| `close-non-object` | 仅做 `local x <close>` 无 value 部分，value 类型判断需 `vm.getInfer` 待补 |
| `newline-call` | 5.2+ 换行调用：`call.next` 有链 + node/argPos 不同行 + 单参数 |
| `newfield-call` | 表构造器数组元素里的换行调用：`field.subtype=='exp'` 且 value 是 call + node/argPos 不同行 |

> parser 的 `AMBIGUOUS_SYNTAX` 只在 `versionNum <= 51`（Lua 5.1）抛；5.2+ 换行调用合法，故 `newline-call`/`newfield-call` 是 warning 非语法错。

### VM 语义规则

- `undefined-field`（首条 VM 语义规则）：`param.vfile:getNode(field.last)` 得被访问对象推断值 → `node:get(field.key.id)` 返回 `(value, exists)`，`exists==false` 报。skip：`field.value~=nil` 或 `parent==assign`（写目标）、`type` 节点 nil/never、index 访问（`t[expr]` 暂不做 enum 检测）。
- `undefined-global`：`scope.rt:globalGet(name):isDefined()` 判全局是否定义，skip 写目标（var.value）与 local/显式 global。
- `deprecated`：通过**注解绑定**机制——`Node.Variable:addAnnotation(name)/removeAnnotation(name)/hasAnnotation(name)` 存 subtype 集合；coder 的 `tryBindCat`（state.lua）对 `value==nil` 的通用注解（`catParserMap` 未注册）生成 `{var}:addAnnotation({subtype})`；function name 经 `function coder` 末尾 `compileAssign(source.name, ...)` 复用同链路；provider 对 var 读查 `vfile:getVariable(var):hasAnnotation('deprecated')`。
- `need-check-nil`：可能 nil 的 local 在字段/调用/索引访问前未判空。判断"可能 nil"：`vfile:getNode(var)` 返回 `type` 节点 `typeName=='nil'`，或 `union` 节点 `values` 含 nil（union.values getter 已扁平化）。后续链判断：`var.next` 存在（字段）、`parent` 是 call 且 `node==var`（调用）、`parent` 是 field(index) 且 `key==var`（索引）。无注解 local 推断为 any 天然跳过。
- `redundant-parameter`：调用传多余参数。**用 `vfile:getNode(call)` 直接拿 `Node.FCall`（call 节点在 coder.map 里就映射为 FCall）**，`fcall.matchedFuncs` 返回参数最匹配的函数列表（内部 `head:each('function')` + `args:canCast(paramsPack)` + `getBestMatchs` 重载匹配）。对 matched 函数取 `paramsPack.max` 的最大值；任一 max==false（变参）则不报。method 调用（`subtype=='method'`）args 计数 +1（self 占首参）。`paramsPack` 是 `Node.List`（`min`/`max`，max=false 表示无限）。**不要自己递归 union/variable 取 max**——matchedFuncs 已处理重载与参数匹配。
- `missing-parameter`：调用缺参数，镜像规则。**注意本分支 `paramsPack.min` 含可选参数**（`function.lua` paramsPack getter 的 `min = #params` 不排除 `v.optional`），故不能用 `paramsPack.min`，要遍历 matched 函数的 `paramsDef` 数 `not p.optional` 的数量作为必需参数数。method self 偏移 +1。比较 callArgs < 必需数则报整个 call。
- `assign-type-mismatch`：赋值类型不兼容。`variable:getExpectValue()`（`---@type` 注解类型）vs `eachAssign()` 的 `assign.value`（实际值）。**canCast 方向**：`a >> b` 语义是「a 是 b 的子类型」（`Node:canCast` 注释），所以判断「实际值能否赋给期望类型」用 `actual >> expect`（不要写反成 `expect >> actual`）。literal（`Node.Value`）需先转 `actual.nodeType`（其 `typeName` 对应的 `Node.Type`）再 canCast。skip：expect 无/any/unknown、actual nil。设计：integer 可赋给 number（`integer >> number` true，因 integer 的 `fullExtends` 含 number），number 不可赋给 integer。**已覆盖 master 的 `cast-local-type`**（`local x` 声明后 `x = value` 赋值场景，经 `assign` 的 exps 走同一 checkAssign）；`cast-type-mismatch` 不可行——本分支 parser 不支持 `expr as Type` 表达式 cast 语法。
- `param-type-mismatch`：调用实参类型不匹配。`FCall.matchedFuncs` + `f:getParam(i)`（method self 偏移 +1）。对每个 matched 函数，只要任一 `actual >> expect` 即不报；`getParam` 返回 nil（变参）或 any/unknown 跳过。
- `return-type-mismatch`：函数 return 类型不匹配。`ret.parent` 是 function → `vfile:getNode(parent)` 得 `Node.Function` → `f:getReturn(i)` 比较。**注意无注解函数跳过**（`#f.returnsDef == 0` 才不查，否则 `getReturn` 会从 returnList 推断出 literal Value，与转 type 后的 actual canCast 失败导致误报）。
- `global-in-nil-env`：`_ENV` 被赋 nil 后访问全局。遍历 var（`var.loc==nil` 且 `var.env` 存在，跳过 `var.id==var.env.id` 的 `_ENV` 自身访问），`vfile:getNode(var.env)` 得 `_ENV` 推断值，`typeName=='nil'` 则报，带 related 指向 `_ENV` local。

### coder 相关修复

- `script/vm/coder/state.lua` — assign coder 第四步对尾部 exp（无 valueKey）补 `rt.NIL` 赋值（`coder:compileAssign(exp, i, 'rt.NIL', false)`），使 `t.a, t.b = 1` 的尾部目标 `t.b` 也 `addAssign` 记录字段，对齐 master 的 setfield 语义（否则 unbalanced 尾部目标被当"读"处理，`print(t.b)` 误报 undefined-field）。

## 约束与语义

- 内部诊断结构用 0-based 字节偏移（`start`/`finish`），LSP range 转换统一走 converter。
- **语法错误来源（重要）**：语法错误由 coder 编译产物提供——`coder.makeFromAst` 序列化 `ast.errors`（`errorCode/start/finish/code/extra` plain data）到 `coder.errors`，子线程 `makeCode` 返回后 `makeFromFile` 赋给 `coder.errors`。诊断 `syntax` provider 读 `param.errors`（`vfile.coder.errors`），不再走主线程 `document.ast.errors`。语法错误同样经 `merge.merge` 去重。
- **parser-only 诊断主线程（重要）**：`empty-block`/`unused-*`/`redefined-local`/`trailing-space`/`redundant-return`/`code-after-break`/`duplicate-index` 等由主线程 `ls.feature.diagnostic` 计算——`document.ast`（主线程 parse）→ provider 逐条计算 + `disable.buildRanges`，与语法诊断合并后过滤去重。
- 语法诊断恒为 Error、不走 neededFileStatus，仅受 `Lua.diagnostics.disable` 与行内禁用注释约束。
- `---@diagnostic` 语义对齐 master：`disable`/`enable` 自下一行生效、`disable-line` 当行、`disable-next-line` 下一行；裸 `disable`（无名）不压语法错误；计数支持嵌套。
- `diagnosticProvider`：`interFileDependencies=false`、`workspaceDiagnostics=false`。
- **状态模型（重要）**：每个文件的诊断状态存在 `vfile.diagnostic`（`Feature.Diagnostic.File`，懒创建）。贡献者模型：`contribute(items)` 添加一批诊断并返回 dispose 函数，`refresh()` 跑文件诊断（先 dispose 旧文件贡献，`version == vfile.version` 时跳过重跑）。push 与 pull 都经 `refresh()` 触发，`schedulePush()` 防抖后 `push()` 合并所有贡献 → 排序去重（merge.lua）→ 对比 `self.results` → 变化则更新并 `publishDiagnostics`。不要自维护诊断缓存表。
- **Task 模型（重要）**：push 防抖用 `ls.task`（`File.schedulePush` 里 reject 旧 task）；`Feature.Diagnostic.Scope:fetchAll()` 批量诊断也用 task 维护。不要用 `await.setID`/`await.close`（本分支无此 API）。
- **Task 让出（重要）**：`Task:delay()`（内部 `ls.await.sleep(0)`，非 yieldable 时静默 no-op）+ `ls.task.newThrottledDelayer(factor)`（计数到 factor 才真正让出一次），供耗时诊断 provider 循环内让出。测试模式需加载 `language-server.task`（`test.lua` 已加 `require`）。
- **push 触发时机（重要）**：单文件诊断无延迟，仅 0.1s 防抖（`File` 内 `DELAY`），不读 workspace 延迟配置（工作区诊断未实现）。文件变化 → `onDidChange` → `File:refresh`；文件删除 → `onDidRemove` → `File:dispose`；`ls.scope.onDidLoad` → 对 scope 下所有 vfile 重新 `refresh`。
- **scope 就绪（重要）**：`scope.ready` 在 reload 协程真正完成时才置 true，完成时 `ls.scope.onDidLoad:fire(scope)`。`File.refresh` 与 `scope.watchFiles` 的 `onDidChange` 索引都先 `ls.scope.waitReady(uri)`，避免配置加载前用默认 `Lua.runtime.version` 编译（否则 Lua 5.5 语法被 5.4 规则误报）。
- `unused-local` 豁免：`_`、`_ENV`、`isGlobal`、`<close>`、local function 名（parent=function）、for 循环变量（parent=for）；以 `#loc.gets==0` 判未读。
- 测试用 `<??>`/`<?x?>` catch mark 断言诊断区间。codes 数组语义：`'code'` 表示必须有该诊断（允许其他诊断）、`'-code'` 表示必须没有该诊断、`{}` 空数组表示必须 0 诊断。marks 只要求每个 mark 匹配某个诊断区间。
- push 暂不带 `version` 字段。
- `define.getSeverity`/`getFileStatus` 仅语义规则路径会用到。

## 测试

`--test feature.diagnostic`：syntax / config / disable / converter / push / pull / empty-block / unused-local / redundant-return / code-after-break / duplicate-index / duplicate-doc-param / unbalanced-assignments / unknown-diag-code / lowercase-global / redundant-value / count-down-loop / undefined-doc-param / close-non-object / newline-call / newfield-call / undefined-field / undefined-global / deprecated / need-check-nil / redundant-parameter / missing-parameter / assign-type-mismatch / param-type-mismatch / return-type-mismatch / global-in-nil-env / semantic

诊断测试 stdlib meta（`test/feature/diagnostic/init.lua` 用 `metaBuilder.compile('Lua 5.4')` 填 `test.metaUris`），故 `print` 等 stdlib 全局 `isDefined=true` 不误报。

## 待定（里程碑 2+）

语义规则分批迁移、workspace 诊断、locale 文案、codeDescription、quickfix。

## 子线程诊断反向请求预研（已暂停）

- 2026-08 预研「子线程向主线程请求节点语义，以在子线程算所有诊断」，结论：机制可行、覆盖大部分需求，但工程量大、不确定性高，暂缓。诊断改回主线程计算。
- **链路可行性**：`bee.channel` 命名通道可建「worker→主线程」反向 request/response；worker 侧 epoll 加反向 response 监听，主线程 `eventLoop.addTask` 轮询反向 request。节点定位用 `source.uniqueKey`（`kind@row:col-row:col` 纯字符串），主线程 `coder.map[key]` 查语义 Node（`vfile:getNode` 已实现）。
- **语义查询真实形态**（以 `undefined-field`/`param-type-mismatch` 为例）：不是简单「查节点值」，而是主线程 VM 语义算法的 RPC 化——`vm.hasDef`、`vm.getInfer(node):eachView(uri)`、`vm.compileNode`、`vm.canCastType(def, ref, errs)`、`vm.getGlobal(cate, name)`、`vm.getClassGenericMap`。
- **关键挑战**：① 语义结果序列化（Node 复杂对象→plain data，`view()` 是展示字符串不可用）；② 查询粒度（逐个节点往返开销大，需批量发 `uniqueKey`）；③ narrowing 的 flow-sensitive 状态查询（需从 tracer flow 按位置取状态）。
- **结论**：能满足所有诊断需求，但本质是把 VM 语义算法 RPC 化。重启前先补完整查询 API 清单 + 序列化格式设计。
