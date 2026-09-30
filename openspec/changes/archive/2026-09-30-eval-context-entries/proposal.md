# Proposal

## Why

`eval-context-unify`（已归档）确立了「一次求值期间不生效缓存失效」的机制，但落地范围只包住了
三个入口：按文件诊断的 task body、hover、completion。跳转类入口
（`textDocument/definition` / `references` / `implementation`）里的 feature 求值**没有**被包住，
它们的求值期内仍可插入失效 —— 而失效与求值交错会让同一逻辑节点换身份，基于身份的环保护随之失效
（先例：`facts/classes.md` F25、`facts/returns.md` F2 的 147k 层递归）。

这是机制落地范围的收口，不是新机制：不补齐时，「求值期不失效」这条 SHALL 在跳转类请求上不成立。

## What Changes

- `script/language-server/capability/language-features/go-to-definition.lua`：
  `ls.feature.definition(...)` 调用外包一层 `scope.rt:withEval(...)`。
- `script/language-server/capability/language-features/go-to-references.lua`：
  `ls.feature.references(...)` 调用外包一层 `scope.rt:withEval(...)`。
- `script/language-server/capability/language-features/go-to-implementation.lua`：
  `ls.feature.implementation(...)` 调用外包一层 `scope.rt:withEval(...)`。
- 包法沿用已落地三处的写法：`---@async` 贴在**调用**上、闭包写在同一行不换行，
  求值结果经闭包外的 `local` 变量带出（不重排既有缩进）。

不涉及：`ls.feature.hover` / `ls.feature.completion` 的调用点（已包）、
按文件诊断（已在 `script/feature/diagnostic/file.lua` 包住 task body）。

## Capabilities

### New Capabilities

无。

### Modified Capabilities

- `eval-context`：给「求值期间不做缓存失效」补一条落地范围要求 ——
  产出 feature 求值的 LSP 入口 SHALL 把整段求值包在同一次求值期内；
  并列出当前已包的入口集合（hover / completion / 按文件诊断 / definition / references / implementation）。

## Impact

- 代码：3 个 capability 文件，各 +4/-1 行左右（仅调用点包装）。
- 语义依据（本仓库自己的语义）：`script/node/runtime.lua` 的 `enterEval/exitEval/evalContext/withEval`
  —— 外层 `enterEval` 顺手 `lockCache()`，`exitEval` 在锁归零时批量 `unlockCache()`
  （即失效延迟到请求求值结束）；ctx 栈按协程隔离，故这些入口用 `scope.rt`（与 hover / completion 一致）。
- 诊断基线：目标工程 `D:\github\vscode-lua\server` **154 → 154（移除 0 / 新增 0）**。
  依据：批量扫描跑的是诊断 provider，不经过这三个跳转入口；本变更只影响 LSP 请求期间的失效时机。
- 本仓库问题面板：0（error / warning / information；hint 不管）。
- 全量 `--test`：绿（含 `test/node/eval-context.lua` 的三条既有断言）。

## 试过但未采用

- **把 `withEval` 下沉到 `ls.feature.definition` 等 feature 函数内部**（而非 capability 调用点）：
  会让 `ls.feature.*` 在测试与内部调用路径上也隐含「求值期」语义，且与已落地的三处写法不一致
  （那三处都在 capability 调用点、结果经闭包带出）。未实测，仅因一致性否决。
- **只在出现爆栈的入口补**（不补齐全部跳转入口）：会导致同一条 SHALL 在不同入口上有不同成立范围，
  后续排查要先确认「这个入口包了没」，成本高于一次补齐。
