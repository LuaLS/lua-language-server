# 事实台账：内联 cast（`--[[@as T]]` / `---@as T`）

格式同 `narrowing.md`：断言 / 证据 / 代码 / 状态。

## F1 内联 `@as` cast 尚未解析（`---@cast` 语句式已支持）
- 断言：`f(x--[[@as integer]])` 里的 `--[[@as integer]]` 应当作用于这次读取，
  读值变成 `integer`（作者用它覆盖推断出来的类型）
- 证据：目标工程 `tools/lua51.lua:378` `osExit(code--[[@as integer]])` 仍按
  `code = tonumber(code) or 0` 的 `0 | truthy | number` 判定 → `param-type-mismatch`；
  目标工程共 4 处 `--[[@as` + 1 处 `---@as`
- 代码：`---@cast`（语句式）走 `script/parser/ast/cats/cast.lua` → coder `catstatecast`
  → `tracer:appendCast` → `W:traceCast`；**内联 `@as` 的注释在 parser 里根本没有被识别**
  （grep 无 `catstateas`/`'as'`），所以 coder/walker 拿不到它
- 已铺好的半边：`appendCast` 现在会把所在表达式的 `uniqueKey` 作为 alias 一起发下去
  （`{'cast', id, op, typeKey, isOptional, alias}`），`W:traceCast` 会把结果写回该读取点
  （否则诊断 provider 读到的是 cast 之前的值）；只差 parser 产出这条 cast。
  注意 alias 只在 `coder.compiled[varSource]` 为真时记录 —— `---@cast x T` 注解里的名字
  没有对应运行时节点，记了会触发 `coder.map` 的 `No such key`
- 状态：**未满足（open）**
