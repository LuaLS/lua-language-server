
# setmetatable Go-to-Definition 修复进展记录
日期：2026-03-03

## 目标

修复 `test/feature/definition/special.lua` 中与 `setmetatable` 相关的 Go-to-Definition 测试。

核心需求：对 `setmetatable({}, {__index = mt})` 创建的对象 `obj`，执行 `obj:x()` 时，
Go-to-Definition 应该**同时**返回 `obj.x` 和 `mt.x` 两个定义位置。

---

## 已解决的问题

### 1. 结构性追踪（`lookIntoIntersection`）

**文件：** `script/node/variable.lua`

**问题：** `allEquivalents` 的计算依赖变量的等价关系，但 `setmetatable` 的返回值在
LLS 内部被表示为 `Intersection` 节点（`T & MT['__index']`），而 `obj_var` 的
`currentValue` 是一条 `Select → FCall` 调用链，原来的等价追踪（`lookIntoVariable`）
无法穿透这条链到达 `Intersection`，也无法从 `Intersection` 中提取出 `mt_var`。

**解决方案：** 实现了 `lookIntoIntersection` 函数，进行结构性遍历：
- `Select` 节点 → 调用 `head:select(key)` 获取下一级
- `FCall` 节点 → 取 `.returns`
- `List` 节点 → 取 `:select(1)`
- `Intersection` 节点 → 遍历 `.rawNodes`（见下方第2条）

当 `currentValue` 的 kind 是 `select/fcall/list` 时，直接走 `lookIntoIntersection`
而不是 `lookIntoValue`，避免 `findValue` 的浅层搜索提前终止。

---

### 2. 使用 `rawNodes` 避免 `simplify()` 破坏 Variable 节点

**文件：** `script/node/intersection.lua`（读取方式），`script/node/variable.lua`

**问题：** `Intersection.values` getter 在内部调用 `simplify()`，会把 `Variable`
节点直接替换为其对应的 `Table` 值，导致追踪时找不到原来的 `mt_var`。

**解决方案：** 在遍历 intersection 的成员时，改为访问 `.rawNodes`（直接存储的原始
节点列表），绕过 `simplify()` 的转换，从而保留对 `mt_var` 的引用。

---

### 3. `Node.Field.value` 的缓存冲洗问题

**文件：** `script/node/field.lua`

**问题：** `Node.Field` 的 `value` 属性在 `__getter` 中被懒加载并缓存，但 `flushCache`
调用时会把 `value` 一并清空，导致某些情况下 `.value` 回退到 `self`（自身），造成
无限递归或逻辑错误。

**解决方案：** 引入受保护的 `_value` 字段存储真正的值，`__getter.value` 从 `_value`
读取，`flushCache` 只清空其他缓存属性，不影响 `_value`。

```lua
-- field.lua 中的关键改动
function M:__init(scope, key, value, optional)
    -- ...
    self._value = value  -- 受保护，不被 flushCache 清空
end

M.__getter.value = function (self)
    return self._value or self.scope.rt.UNKNOWN, true
end
```

---

## 当前状态（尚未解决）

### 剩余问题：`mt_var.childs['x']` 为 nil

**症状：** 在 `allEquivalents` 的 parent 处理阶段，我们已经能正确追踪到 `mt_var`
作为 `obj_var` 的等价变量之一。但当访问 `mt_var.childs['x']` 时，结果为 `nil`。

```
[DBG-PARENT]   eq.key=mt  childs=yes  lookup_key=x(string)  child=nil
[DBG-PARENT]     childs is EMPTY
```

**调试中发现：** Intersection 节点的调试输出出现了意外的 `otherParts count=0` 日志，
这段日志**不来自我们写的代码**——说明 intersection 内部处理路径上还有另一段尚未定位
的逻辑参与了。这是明天需要继续排查的入口。

**待排查方向：**
1. `mt_var.childs` 为空的原因——是 GC 弱引用回收，还是初始化顺序问题，还是
   `mt_var` 本身不是函数定义时使用的同一个对象？
2. `otherParts count=0` 日志来自何处，它是否提前拦截了 intersection 的遍历？
3. 确认 `function mt:x() end` 编译时，`mt_var:getChild('x')` 生成的子变量是否
   经过了 `addAssign` 从而被 REF_POOL 保护。

---

## 涉及的关键文件

| 文件 | 改动性质 |
|------|----------|
| `script/node/variable.lua` | 主要逻辑：实现 `lookIntoIntersection`，增加调试日志 |
| `script/node/field.lua` | 修复：`_value` 保护，避免 `flushCache` 破坏 value |
| `script/node/intersection.lua` | 只读：理解 `rawNodes` vs `values` 的区别 |
| `script/node/runtime.lua` | 只读：了解 `luaKey`、`REF_POOL` 的机制 |

---

## 临时调试日志清理提醒

`variable.lua` 中目前有大量 `io.write('[DBG...]')` 调试输出，在最终提交前需要全部
移除。这些日志前缀包括：`[DBG]`、`[DBG2]`、`[DBG3]`、`[DBG-INT]`、`[DBG-PARENT]`。
