# Proposal

## Why

目标工程 `script/core/completion/completion.lua:1861`（与 1884）报
`Cannot assign parser.object | truthy to parameter string`。用户判断这是目标工程侧该加内联 cast。

查证成立：那两处 `matchKey(source[1], name)` 的 `name` 取自 `doc.class[1]` 这类 **luadoc 构造**节点，
其 `[1]` 的注解是 `[integer]: parser.object|any`（`script/parser/guide.lua:80`，对所有 parser 对象都太宽），
而运行期 `[1]` 是**名字字符串**（`script/parser/luadoc.lua:232-238` 的 `parseName` 写入 `[1] = nameText`）。
目标工程自己在 1166 行就有同一写法的先例：`source[1]--[[@as string]]`。

## What Changes

- 目标工程 `script/core/completion/completion.lua` 1861 / 1884：
  `matchKey(source[1], name)` → `matchKey(source[1], name--[[@as string]])`
  （该处 `name` 已被 `if name and …` 守卫为真，断言 `string` 是健全的）。
- 引擎**零改动**。
- 落 `test/project/repro/inline-cast-index.lua`：内联 cast 挂在索引读取上（含条件位置）的对照组。
- 台账 `facts/casts.md` 新增 F2（含「先看诊断的列」这条排查教训）。

## Capabilities

### New Capabilities

（无）

### Modified Capabilities

（无 —— 引擎行为未变，`.openspec.yaml` 用 `skip_specs: true`）

## Impact

- 目标工程诊断基线：**220 → 218（移除 2 / 新增 0）**（`completion.lua:1861`、`1884`）。
- 本仓库 `--test` 全量绿；问题面板 0；复现目录 0 诊断。

### 试过但未采用（实测）

先把 cast 加在**第一个实参**上（`source[1]--[[@as string]]`）⇒ 220 → 220（移除 2 / 新增 2，
诊断只是位置平移）。探针（`--probe-file=core/completion/completion.lua --probe-filter=@1861`）显示
`call(...)(string, parser.object | truthy)` ⇒ 真正报的是**第 2 个实参 `name`**
（用户给的区间 1861:41–45 也正是 `name`）。教训：先看诊断的**列**再下结论。
