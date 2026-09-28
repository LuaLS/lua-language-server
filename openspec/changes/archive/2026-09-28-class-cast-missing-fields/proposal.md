# Proposal

## Why

目标工程 `completion.lua:1683` 报 `param-type-mismatch`，而该行上面写着
`---@diagnostic disable-next-line: missing-fields` —— 即作者预期这里由 **`missing-fields`** 报。

查证上游（目标工程）：
- 诊断管道**没有**跨诊断的同位置优先级：按位置去重只在**单个诊断内部**
  （`script/core/diagnostics/init.lua:117-129` 的 `mark[result.start]`），结果汇总只拼接
  （`provider/diagnostic.lua` 的 `mergeDiags`），禁用按**代码名**匹配
  （同文件 120 行 `vm.isDiagDisabledAt(uri, start, name)`）。
- 上游这里只出 `missing-fields`，是因为 `Lua.type.checkTableShape` 默认 **false**
  （`script/config/template.lua:432`）+ `vm.isSubType` 的门控（`script/vm/type.lua:572-581`：
  child 是 table、parent 是非基础类型时直接 `return true`）⇒ param/assign 两条不做表形状检查。
- 我们这边：`Lua.type.checkTableShape` 键有（默认 false）但**从未读过** ⇒ 转换检查一直做严格形状检查。

## What Changes

- `script/node/type.lua` `M:onCanBeCast` 的类分支：当实参是**表**、与该类**有同名交集**、
  又**缺**其它必填字段时，判为相容（缺字段交给 `missing-fields` 一类专门规则）；
  交集中的字段类型照旧比较。字段齐全的、以及与该类毫无交集的表（`{[1] = ...}` 这类索引构造）
  仍走原判据。就地比较（不新建节点），并加 `_classCastDepth` 兜底防自引用爆栈。
- 更新 `test/node/cast_type.lua`（`ta`/`tb` 部分字段 ⇒ true、`tc` 无交集 ⇒ false）、
  新增 `test/node/cast_table.lua` 一组断言（完整 / 缺字段 / 字段类型错 / 数组）。
- 复现落库：`test/project/repro/class-literal-shape.lua`（三态）。
- 台账新增 F25（含上游机制与三条「试过未采用」）。

## Capabilities

### Modified Capabilities

- `class-fields`: 追加「表值 → 类」转换时缺字段的判定。

## Impact

- 代码：`script/node/type.lua`。
- 目标工程诊断基线：**259 → 220（移除 23 / 新增 0）**，含用户报的
  `completion.lua:1683` 与 `1365`；`vm/operator.lua` 8 处、`vm/compiler.lua` 3 处的移除行
  **与目标工程自己写的 `disable-next-line: missing-fields` 逐行对上**。
- `--test` 全量绿；本仓库问题面板 0；复现目录 0 诊断。

### 试过但未采用（实测）

1. 对所有 table-like 值无限制宽限 ⇒ 259 → 194，但把 `parser.object[] | parser.object` 这类
   联合/数组值也放了，丢掉真检查（`containsGenericName(field.extends)` 一族）。
2. 临时拼一张「已出现字段」的表再 `canCast` ⇒ **爆栈**：每次调用新建节点，cast 缓存命中不了，
   表与类互转的递归不收敛（现改为就地比较 + 深度兜底）。
3. 只要求「有缺失」、不要求「有交集」⇒ `objs = {}; objs[1] = g(source); return objs` 这类
   索引构造的表也放行，破 `test/feature/diagnostic/return-type-mismatch.lua` 的钉子。
