# Node 类型节点系统

## 概述

`script/node/` 是整个语言服务器的核心，所有类型信息以**节点（Node）**对象表示。节点是不可变的（原则上），通过组合操作构建复杂类型。

## 节点注册

所有节点类通过 `ls.node.register` 创建，自动继承 `Node` 基类并获得 `|`、`&` 操作符支持：

```lua
local M = ls.node.register 'Node.Union'
M.kind = 'union'
```

节点 kind 枚举定义在 `script/node/node.lua`：
```lua
ls.node.kind = {
    ['type']     = 1 << 0,   -- 命名类型（string, number...）
    ['value']    = 1 << 1,   -- 字面量值（1, "hello", true）
    ['table']    = 1 << 2,   -- 表类型
    ['tuple']    = 1 << 3,   -- 元组
    ['array']    = 1 << 4,   -- 数组
    ['union']    = 1 << 7,   -- 联合类型（A | B）
    ['variable'] = 1 << 15,  -- 变量节点（用于类型追踪）
    ['tracer']   = 1 << 24,  -- 类型收窄追踪器
    -- ... 共 25 种 kind
}
```

## 关键基类方法（Node）

| 方法 | 说明 |
|------|------|
| `node:canCast(other)` | 判断自己是否是 `other` 的子类型 |
| `node:narrowEqual(other)` | 等值收窄，返回 `(narrowed, otherSide)` |
| `node:narrowByField(key, value)` | 按字段收窄，返回 `(narrowed, otherSide)` |
| `node:get(key)` | 获取字段/索引值 |
| `node:getChild(key)` | 获取子变量节点（用于路径追踪） |
| `node:view()` | 返回可读字符串表示 |
| `node:each(kind, cb)` | 遍历指定 kind 的节点 |
| `node:every(cb)` | 对每个叶节点执行变换 |
| `node.truly` | 去除 falsy 值后的类型（getter） |
| `node.falsy` | 去除 truly 值后的类型（getter） |

## 常用节点类型

### Node.Union（联合类型）
```lua
local u = rt.union { rt.STRING, rt.NIL }  -- string | nil
```
- `union:narrowEqual(value)` 对每个成员分别收窄后重组

### Node.Value（字面量值）
```lua
local v = rt.value(1)      -- 字面量 1
local v = rt.value("hi")   -- 字面量 "hi"
```

### Node.Table（表类型）
```lua
local t = rt.table { a = rt.value(1), b = rt.STRING }
-- { a: 1, b: string }
```

### Node.Variable（变量节点）
变量是**可追踪**的节点容器，支持 shadow（创建收窄版本）和 setCurrentValue（设置当前值）：
```lua
local x = rt.variable 'x'
x:addType(rt.STRING | rt.NIL)
local x2 = x:shadow()            -- 创建收窄副本
x2:setCurrentValue(rt.STRING)    -- 在特定分支设为 string
```

### Node.Tracer（类型收窄追踪器）
见专项文档 `03-tracer-narrowing.md`。

## `__getter` 懒属性模式

节点属性可以声明为懒计算：
```lua
M.__getter.value = function(self)
    -- 第一次访问时计算，返回 (value, true) 表示缓存
    return computedValue, true
end
```
返回第二个值 `true` 表示将结果缓存到 `self.value`，后续访问不再触发函数。

## 节点操作符重载

```lua
nodeA | nodeB   -- 等价于 rt.union{nodeA, nodeB}
nodeA & nodeB   -- 等价于 rt.intersection{nodeA, nodeB}
nodeA >> nodeB  -- 等价于 nodeA:canCast(nodeB)，返回 boolean
```

## 初始化入口

`script/node/init.lua` 按顺序 require 所有节点模块，确保注册顺序正确。新增节点类型必须在此文件追加 require。
