# 事实台账：视图渲染（`script/node/view.lua` / `Node.*:onView`）

格式：断言（可判定的一句话）/ 证据（测试或目标工程坐标）/ 代码 / 状态。
状态取值：成立 / 未满足(open) / 已废弃。

## V1 位置环被跳过时，字段在视图里显示成 `...`（诊断消息会藏住真正失败的那个字段）（未满足）

- 断言（未满足）：表类型的视图在渲染字段时，若某个 `field.location` 已被访问过
  （`checkSkip` 判环），该字段被整条跳过、只在末尾补一个 `...`。于是诊断消息里的实参类型
  看起来像「少了这些字段」，而真实的失败原因（某个字段的值类型）被 `...` 遮住，误导定位。
  应当：让 `...` 只表示「开放结构 / 未知键」，或者至少不让**已存在**的字段因判环而消失
- 证据：目标工程 `script/json-edit.lua:405` 的 `return-type-mismatch` 消息
  （消息里显示 `{ d: ..., v: any, ... }`，看似缺 `s`/`f`，但插桩 `Node.Table:onCanBeCast` 显示
  失败键是 **`f`**：`act` = `statusPos` 那串带 `nil` 的并集、`exp = integer`；
  合并本身没错，插桩 `Node.Table:addChilds` 打出的合并键集 `{d,s,v,f}` 是齐全的）
- 代码：`script/node/table.lua:727-746`（`checkSkip`：`field.location` 重复即 `skipped = true`）、
  `:811-813`（`skipped` → `kv[#kv+1] = '...'`）
- 试过：无（本轮只定位，未改视图——改它会牵动大量 view 断言，需单独一轮基线比对）
- 状态：未满足（open，2026-09-29 记；与 `narrowing.md` F26 同一轮发现）
