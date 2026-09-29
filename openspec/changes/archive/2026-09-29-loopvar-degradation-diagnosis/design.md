# Design

## 现象分解

```lua
local returns = source.returns          -- parser.object[]?
if not returns then return end
local min = vm.countReturnsOfSource(source)
if min == 0 then return end
for _, ret in ipairs(returns) do
    local rmin, rmax = vm.countList(ret)     -- 形参 list: parser.object[]?（vm/function.lua:291）
    if rmax < min then
        if rmin == rmax then
            callback { start = ret.start }   -- ← 报 Undefined field `start`
```

- provider（`undefined-field`）取的是**基值**：`vfile:getNode(field.last)` = `ret` 的读值
  ⇒ 诊断期打印 `base=parser.object[] | nil exists=false` ⇒ `Array` 不认具名字段 ⇒ 报。
- 悬浮/读值是**读节点自己的值** = `any`（tracer 的宽松路径）⇒ 两条路径不同源，才有「是 any 却报」的观感。

## 逐位置探针（决定性证据）

`--probe-file=core/diagnostics/missing-return-value.lua --probe-filter=ret@`：

| 位置 | 读值 |
|---|---|
| `@25`（`local ret` 声明） | `any` |
| `@26`（`vm.countList(ret)` 的实参读） | `any` |
| `@30` / `@31`（调用 + 比较之后的嵌套 if，报错处） | `parser.object[] | nil` |
| `@39` / `@40`（第二个循环） | `never` |

⇒ 循环变量进循环时是对的（`any` = 元素未知），**在调用与结果比较之后退回未收窄的「声明类型」**。

## 归因与候选

按注解：`returns? parser.object[]` ⇒ 元素 `parser.object | nil` ⇒ `start` 存在 ⇒ **不该报**
⇒ 缺口在我们这边（循环变量/元素解析），不是目标工程注解问题。两个候选（下一步二分）：

1. `ipairs(<未收窄的 parser.object[] | nil>)`：守卫的 truthy 收窄只体现在读点，槽位仍是声明类型
   ⇒ 元素/泛型 V 解析退化，循环变量退回「迭代对象的表值」；
2. `W:traceLink` 的间接窄化（`tracer.lua:1053-1062`）→ `W:traceCallEqual`
   按形参注解反推实参 ⇒ `ret` 被写成 `parser.object[] | nil`（`limitByOwnValue` 的「不得比实参更宽」
   在实参自身值是 `any` 时形同虚设：`any` 是任何类型的上界）。

## 回归与测量方式

- 复现：`test/project/repro/ipairs-narrow-field.lua`（同形状，带 disable 标记）。
- 二分手段：分别关掉候选 1 / 候选 2 的路径，看复现与目标基线（当前 218）的变化。
