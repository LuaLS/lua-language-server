# Design

## Context

机制已在 `eval-context-unify` 落地：`script/node/runtime.lua` 的
`enterEval/exitEval/evalContext/withEval`（ctx 栈按协程隔离，最外层 `enterEval` 顺手 `lockCache()`，
`exitEval` 在锁归零时批量 `unlockCache()`）。动机见 `proposal.md`。

现状（本轮改前的落地范围）：

- 已包：`script/feature/diagnostic/file.lua`（按文件诊断的 task body，内含 `ls.scope.waitReady`）、
  `.../language-features/hover.lua`、`.../language-features/completion.lua`。
- 未包：`.../language-features/go-to-definition.lua`、`go-to-references.lua`、`go-to-implementation.lua`
  ——它们的 provider 会读 `param.scope.vm:getNode(source)` / `variable:getEquivalentLocations(...)` /
  `node.value`，即一定会触发求值。

约束：仓库写法约定（`AGENTS.md` §8 / `facts/eval-context.md` E1）——`---@async` 贴在**调用**上、
闭包不换行、结果经闭包外的局部变量带出、不重排既有缩进。

## Goals / Non-Goals

**Goals:**

- 三个跳转入口的求值期与失效时机与已落地三处完全一致（同一把入口锁、同一个 ctx 栈）。

**Non-Goals:**

- 不改 `ls.feature.*` 函数内部（不在 feature 层隐含求值期语义）。
- 不动 workspace 索引/加载路径的求值（那些不是 LSP 请求入口）。
- 不改 `withEval` 本身的行为。

## Decisions

1. **包装位置放在 capability 调用点，而不是 feature 函数内部。**
   理由：与已落地三处一致；capability 层是「一次请求 = 一次求值期」的自然边界。
   备选（未采用）：在 `ls.feature.definition` 等函数内包 —— 会让测试与内部调用也隐含该语义。
2. **用 `scope.rt` 而非 `document.scope.rt` 等其他取法。**
   理由：`scope` 已由 `ls.scope.findDocument(uri)` 返回并做过判空，且与 hover / completion 逐字一致。
3. **用闭包外局部变量承接返回值，不改 `if not results then` 之类既有判空。**
   理由：`withEval` 无返回值（`facts/eval-context.md` E1 记的签名），保持既有控制流不变形。
   注意 `go-to-definition.lua` 的 `local results = ls.feature.definition(...)` 之后紧跟 `for ... ipairs(results)`，
   必须保证 `results` 一定被赋值（`withEval` 内部异常会向外抛，不落到后续代码）。

## Risks / Trade-offs

- [跳转请求期间被推迟的失效，可能在请求出口才生效，导致同一次请求内后续读拿到「旧值」] →
  这正是该机制的设计意图（同一次求值期内保持一致视图）；请求结束后批量生效，不跨请求泄漏。
- [`withEval` 未包住 `ls.scope.findDocument` 等前置调用] → 前置调用不产出类型求值，无需包；
  与已落地三处保持一致即可。
- [批量诊断扫描不经过这三个入口，扫描数字无法验证本次改动] → 用既有 `test/node/eval-context.lua`
  的断言 + 全量 `--test` 绿 + 面板 0 作为验证；另做一次请求级手工验证（跳到定义仍正常）。
