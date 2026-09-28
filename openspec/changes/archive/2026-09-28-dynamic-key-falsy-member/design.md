# Design

## 诊断

`Variable:getDynamicKeyValue`（`script/node/variable.lua`）的取值链：

```lua
    local base = parent:getCurrentValue()
        or parent:getStaticValue()
        or parent.value
    for _ = 1, 100 do
        local value = base:simplify()
        ...
        local result, exists = value:get(rt.UNKNOWNKEY)
```

- `parent:getCurrentValue()` 是 walker 写在节点上的收窄值，随 `class.flush` 失效
  （同一趟 walk 里就会被清掉）；
- 退到 `parent:getStaticValue()` 时拿到的是**槽位**的静态值 ——
  对「可选字段读出来的数组」（`state.lines`，`state` 的守卫收窄只在**读点**的 flow 值上）
  来说就是 `integer[] | nil`；
- `Union:get(rt.UNKNOWNKEY)` 把 `nil` 成员的取值也算进结果 ⇒ 元素变成 `integer | nil`。

最小复现（`test/project/repro/array-index-nil.lua`）：

```lua
local state = getState()          -- ---@return State?
if not state then
    return 0
end
local lines = state.lines         -- 槽位值 = integer[] | nil
local firstRow = rowCol()
return needInteger(lines[firstRow])   -- 修前：Cannot assign `integer | nil` to parameter `integer`
```

## 修法

在元素推导前丢掉基值里**恒假**的成员：

```lua
local function dropFalsyMembers(rt, value)
    if value.kind ~= 'union' then
        return value
    end
    local values = {}
    for _, v in ipairs(value.values) do
        if v.truthy ~= rt.NEVER then
            values[#values+1] = v
        end
    end
    if #values == 0 or #values == #value.values then
        return value
    end
    return rt.union(values)
end
```

- 用 `v.truthy ~= rt.NEVER` 判「恒假」（`NIL.truthy` / `FALSE.truthy` 都是 `NEVER`）；
- 全被滤掉（基值恒假）或一个都没滤掉时原样返回，不改变原路径；
- 只作用在**元素推导**上：元素类型自身含 nil（`(integer|nil)[]`）不受影响；
  「基值可能为 nil」由读点基值的 flow 值负责（那里是收窄后的 `integer[]`）。

## 为什么不用「基值的 flow 值」

试过：在 `traceRef` 的动态键分支里把基值的 flow 值喂给 `getDynamicKeyValue`。
拿不到 —— 动态键子变量是在 `Variable:getChild` 里**转发到值链上的变量**创建的
（`parent` 是 `currentValue/staticValue` 那个变量，不在 flow 里），
`nodeID` 查不到对应 id ⇒ 0/0。另一条是给动态键读登记 `parentMap`
（让 walker 走 `deriveFieldValue`），需要 coder 侧配合（键不是字面量、
`parentMap` 的值要保持纯数据），方案 1 已经 0/0 说明不是必需。

## 回归钉的说明（写进台账 F22）

同一形状在 `TEST_DIAGNOSTIC`（feature 侧）与节点级构造里都**不复现**
（那里 `Union:get` 不掺 nil），所以这条没有 harness 回归钉；
回归以 `test/project/repro/array-index-nil.lua` + 目标工程基线比对为准。
