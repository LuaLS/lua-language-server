# Design

## 两处改动与理由

```lua
---@param list parser.object | parser.object[] | nil     -- ①放宽
---@param mark? table
function vm.countList(list, mark)
    if not list then return 0, 0, 0 end
    local lastArg = list[#list]--[[@as parser.object?]]   -- ②元素读断言回节点
    if not lastArg then return 0, 0, 0 end
    ...
    if lastArg.type == '...' or ... then
    elseif lastArg.type == 'call' then
        local rmin, rmax, rdef = vm.countReturnsOfCall(lastArg.node, lastArg.args, mark)  -- 319
```

① 的事实依据：`countList` 的 7 个调用点里 6 个传**单个 `parser.object`**
（`source.args`、`return` 节点；按目标工程自己的约定「节点 = 带编号子项」），
只有 `vm/function.lua:203` 传真正的 `parser.object[]`；原注解 `parser.object[]?` 比实际契约窄。

② 的必要性：参数放宽后 `list[#list]` 的读值变成并集，`lastArg.type == 'call'`
（`:310`）的收窄没能把它收窄回节点 ⇒ `:319` 的 `lastArg.node` 报
`Cannot assign <并集> to parameter parser.object`（218 → 217 的“新增 1”）。
在**元素读**上加 `--[[@as parser.object?]]` 是就地的正解：断言元素是节点（数组元素本来就是节点），
`?` 保住 `if not lastArg` 的判空语义，收窄链随后照旧。

## 为什么不改引擎（本轮）

- 整段停掉「参数反推」（`tracer.lua:1053-1062`）实测移除 6 / 新增 7 ⇒ 承重机制；
- ② 暴露的引擎缺口（字段判等收窄作用在**索引读值**上不生效 / 字段不存在时 `NEVER:canCast` 恒真）
  仍值得单独量，但本轮用目标侧一行的 cast 就能收敛，先把目标工程推进。

## 验证

- 目标扫描：`--baseline=tmp/17-base2.txt`（218）→ 216（移除 2 / 新增 0）；
- 本仓库 `--test` 全量绿；面板 0；目标基线存入 `tmp/20-base-final.txt`。
