# 事实台账：多返回值 / 无界返回（vararg）

格式同 `narrowing.md`：断言 / 证据 / 代码 / 状态。

## F1 无界返回的 List：一个值 = 任意位置都有；多个值 = 只有前 min 个保证有
- 断言（单值无界）：`Node.List` 只有**一个值**且无上界（`max = false`，如 `rt.list({T}, 0, false)`）时，
  `select(i)` 对任意 i 都返回 `T`，**不加 `| NIL`**——即 `Node.List:select` 里的
  「无界单元素 list（vararg 语义）：视所有位置均存在，不加可选 | NIL」
- 断言（多值无界）：有多个值且无上界时，超出 `min` 的位置仍带 `| NIL`（`min` = 保证返回的个数，
  只有 `i == min` 不加）
- 证据：test/node/vararg.lua（`list({INTEGER}, 0, false)` → `integer?...`、`select(2)/(100)` = `integer`；
  `list({1,2}, 1, false)` → `select(1)=1`、`select(2)=2 | nil`）；
  test/node/fcall.lua（`return ...` 的函数，调用结果 `select(2)` = `unknown`）
- 代码：`script/node/list.lua`（`select` / `makeViews`）、`script/node/fcall.lua`（`FCall.returns`）
- 踩过的坑：`FCall.returns` 为「不定长返回（spread）」把末位元素**追加**成第二个值时，
  单值无界 list 变成两个值 → `select(2)` 起变成 `T | nil`
  （目标工程 `script/core/command/exportDocument.lua:13` 的 `doc.makeDoc` →
  `local docPath, mdPath = ...` 第二个值报 `any | nil` 就是这个）；现在仅当末位元素
  与已有最后一项不同才追加（`tail:simplify() ~= last:simplify()`）
- 试过（别重走）：把 `Function.returnsPack`（推断路径）的 `min` 从「值个数」改成
  「各 returnList 的 `min` 取最小」（想让 `return ...` 的函数 min = 0）——目标工程
  **+121 处误报**（`return-type-mismatch` 一片，形如 `await.lua:37 return ...`），已还原。
  要动那个 `min` 得先搞清它在 `return-type-mismatch` 里被当成什么用
- 状态：成立（2026-09-22；目标工程 373，本轮移除 4 / 新增 0）
