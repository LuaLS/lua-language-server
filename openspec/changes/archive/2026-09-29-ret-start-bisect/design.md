# Design

## 二分设计

基线：目标工程 218 条。目标项：`core/diagnostics/missing-return-value.lua:30/31`
（`start = ret.start` / `finish = ret.start + #'return'`）。

### 候选 ②：`W:traceLink` 的间接窄化

`tracer.lua:1053-1062`：对一个**来自函数调用的变量**做比较时（`if rmax < min` / `rmin == rmax`），
用 `link` 记录把比较**反推**到调用的实参上（`W:traceCallEqual`），按**形参注解**收窄实参。

停掉这一段后实测：

| | |
|---|---|
| 目标项 | `missing-return-value.lua:30/31` **消失** |
| 整体 | **移除 6 / 新增 7**（218 → 219） |

⇒ 是元凶，但不能整段停：它同时承担
`compile.lua:2789`（`parseSimple(name, true)` 一族）、`vm/operator.lua:199/205/223`
的 **FP 修复**，并挡住 `cli/doc/export.lua:122`、`newline-call.lua:46/49` 的新报。

### 候选 ①：`ipairs(<未收窄表>)` 的元素解析

停掉 ② 后，复现文件 `test/project/repro/ipairs-narrow-field.lua` 里 `ret` 各位置
都回到 `repro.Obj`（不再退化）⇒ ① 不是这两条的成因，不必单独动。

## 目标侧试探（未采用）

`vm/function.lua:291` `---@param list parser.object[]?`：

- `countList` 的 7 个调用点里，6 个传**单个 `parser.object`**
  （`source.args`、`return` 节点；按目标工程自己的约定「节点 = 带编号子项」），
  只有 `vm/function.lua:203` 传真正的 `parser.object[]`
  ⇒ 注解比实际契约**窄**；
- 放宽成 `parser.object | parser.object[] | nil` ⇒ 30/31 消失，但 218 → 217
  （移除 2 / **新增 1**）：本体 `local lastArg = list[#list]` 读值变宽后，
  `lastArg.type == 'call'`（`function.lua:310`）的收窄没生效 ⇒ `function.lua:319`
  新增一条 `Cannot assign <并集> to parameter parser.object`。

⇒ 目标侧要**两处一起**（参数注解 + 本体元素读）；或者先修
「字段判等收窄没作用在**索引读值**上」这个新暴露的缺口。

## 归因更新（写进 F3）

F3 不再是「循环变量的元素解析」单一成因，而是：

1. 目标工程形参注解太窄（`countList(list: parser.object[]?)` vs 传入的单个节点）；
2. 参数反推按**形参注解**把实参**写回变量**（后续读取都受影响）；
3. 反推本身是承重机制（整段停 = 净变差），所以不能靠停它来修。
