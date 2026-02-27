# Tracer 类型收窄系统

文件：`script/node/tracer.lua`，测试：`test/node/tracer.lua`

## 概述

`Node.Tracer` 是类型收窄（Type Narrowing）的核心驱动器。它接受一段描述**数据流（Flow）**的 DSL，执行模拟求值，将每个变量引用点的收窄结果写回对应的 `Node.Variable`。

## 三个核心类

| 类 | 职责 |
|----|------|
| `Node.Tracer` | 对外入口，持有 map/parentMap/flow |
| `Node.Tracer.Walker` | 遍历 flow，维护 stack，执行所有收窄逻辑 |
| `Node.Tracer.Stack` | 单层作用域的变量快照，含 `current` 和 `otherSide` |

## Flow DSL 格式

Flow 是一个指令序列，每条指令是一个 table，第一个元素为 tag：

```lua
tracer:setFlow {
    { 'var', 'x', 'x0' },               -- 声明变量 x，对应 alias x0
    { 'if', {                            -- if 分支
        { 'condition', <exp> },          -- 条件表达式
        { 'ref', 'x', 'x2' },           -- true 分支中对 x 的引用
    }, {
        { 'ref', 'x', 'x3' },           -- false 分支中对 x 的引用
    } },
    { 'ref', 'x', 'x4' },               -- if 之后对 x 的引用
}
```

### 指令 tag 一览

| tag | 格式 | 说明 |
|-----|------|------|
| `'var'` | `{'var', id, alias}` | 变量声明，将 alias 的 value 写入 id 的 current |
| `'ref'` | `{'ref', id, alias}` | 变量引用，将当前收窄值写回 alias |
| `'if'` | `{'if', trueBlock, falseBlock}` | 分支，分别在 true/false 侧执行 |
| `'condition'` | `{'condition', ...refs, exp}` | 条件，先遍历前置 ref，再执行最后的条件表达式 |
| `'value'` | `{'value', id}` | 取 map[id] 的字面量节点 |

### 条件表达式（exp）格式

条件表达式是嵌套 table，第一个元素为操作符：

```lua
-- 单变量 truthy 检查（if x then）
{ 'ref', 'x', 'x1' }

-- 等值比较（if x == 1 then）
-- 'v' 标记标识"被比较的值"位置
{ '==', { 'ref', 'x', 'x1' }, 'v', { 'value', 'v1' }, 'v' }

-- 不等比较
{ '~=', ... }

-- 逻辑与（if x and y then）
{ 'and', { 'ref', 'x', 'x1' }, 'v', { 'ref', 'y', 'y1' }, 'v' }

-- 逻辑或（if x or y then）
{ 'or',  { 'ref', 'x', 'x1' }, 'v', { 'ref', 'y', 'y1' }, 'v' }

-- 字段路径（if x.a == 1 then），需要同时提供 parentMap
{ '==',
    { 'ref', 'x',   'x1'   },   -- 根变量 ref
    { 'ref', 'x.a', 'x.a1' },   -- 子路径 ref
    'v',
    { 'value', 'v1' }, 'v'
}
```

## parentMap：字段路径追踪

`parentMap` 描述变量之间的父子关系，用于在收窄子字段时同步收窄父变量：

```lua
local p = {}
p['x.a']   = { 'x',   'a' }   -- x.a 的父是 x，key 为 'a'
p['x.a.x'] = { 'x.a', 'x' }   -- x.a.x 的父是 x.a，key 为 'x'
```

当 `x.a` 被收窄后，Walker 会沿 parentMap 向上传播，同步收窄 `x`。

## Stack 机制

`Walker` 维护一个 stack 数组，每层 stack 保存：
- `current`：当前层已知的变量值（收窄后）
- `otherSide`：当前条件为假时的变量值
- `changed`：在此层被赋值（var/分支合并）的变量 id 集合

`getValue(id)` 从栈顶向下查找第一个有值的层。
`setValue(id, value, isAssign)` 写入栈顶。

## and / or 收窄语义对比

| | `and`（A and B） | `or`（A or B） |
|---|---|---|
| **true 分支 current** | A 收窄后再应用 B（嵌套 stack，stack2 叠在 stack1 上） | A 和 B 各自独立收窄，两侧都有收窄的取并集，单侧有的不写入（保持原始值） |
| **false 分支 otherSide** | `A.otherSide ∪ B.otherSide`（两侧任一为假即可） | `A.otherSide` 后叠 `B.otherSide`（两者都必须为假） |

### and 实现要点
stack2 在 stack1 之上 push（嵌套），`getValue` 可透视 stack1 的收窄结果，实现"先收窄 A 再收窄 B"。

### or 实现要点
stack1 push → popStack → stack2 push（平行），两者从同一基础出发独立收窄，互不影响。最后只对**两侧都出现**的变量取并集写入 current。

## 新增条件类型的步骤

1. 在 `traceConditionUnit` 中添加 `elseif kind == 'xxx'` 分支
2. 实现对应的 `traceXxx(exp, revert)` 方法
3. 利用 `pushStack`/`popStack` 隔离作用域
4. 将结果合并到 `currentStack.current` 和 `currentStack.otherSide`
5. 在 `test/node/tracer.lua` 补充测试用例

## 测试用例结构

```lua
rt:reset()
local r = {}  -- alias → Node.Variable 映射
local p = {}  -- 字段路径 parentMap

local tracer = rt.tracer(r, p)

-- 1. 创建变量和 alias
r['x0'] = rt.variable 'x'
r['x0']:addType(rt.STRING | rt.NIL)
r['x1'] = r['x0']:shadow()
r['x1']:setTracer(tracer)   -- 注册到 tracer

-- 2. 设置 flow
tracer:setFlow { ... }

-- 3. 断言收窄结果
lt.assertEquals(r['x1']:view(), 'string | nil')
lt.assertEquals(r['x2']:view(), 'string')
```
