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

## ⚠️ 关于 `self.map` 的访问规则（重要）

**`self.map` 是一个严格 proxy**，访问不存在的 key 会直接抛出错误（`No such key: xxx`）。这是**故意设计**的，绝对不要用 `pcall` 或 `rawget` 来绕过这个错误。

### 设计原因

- `Node.Tracer` 是在 coder 中间代码执行完毕之后才有机会被调用的
- 中间代码执行时，所有 `Node.Variable` 节点会通过 `r["uniqueKey"] = rt.variable(...)` 写入 proxy 的底层 map（变量名 `r` 即 `coder.map`）
- Walker 里通过 `self.map[alias]` 访问节点时，`alias` 是 flow entry 里的 uniqueKey，这些 uniqueKey **必须**在中间代码里已经被注册

### 遇到 `No such key` 时的排查方法

如果 Walker 访问 `self.map[alias]` 时报 `No such key`，说明：

1. **中间代码生成有误**：对应节点的 `r["uniqueKey"] = ...` 语句没有被生成。可通过 `LAST_CODE` 全局变量查看最近一次生成的中间代码，确认 `r` 表中是否有对应 entry：
   ```lua
   -- 在测试里打印中间代码
   print(LAST_CODE)
   ```

2. **Tracer flow 数据有误**：flow entry 里的 alias（uniqueKey）写错了，与中间代码里实际生成的 key 不匹配。检查 `LAST_FLOW` 可查看最近的 flow 数据：
   ```lua
   print(LAST_FLOW)
   ```

3. **中间代码存在赋值时序问题**：key 的确被生成了，但生成顺序有误——`r["key"]` 在 `= ...` 赋值语句之前就被读取了。这是一种较为隐蔽的 bug，见下一节。

### 中间代码赋值时序问题

**现象**：某个 key（如 `r["field@80:1-80:10"]`）在中间代码里确实存在赋值行，但 coder 执行时仍然报 `No such key`。

**原因**：这是中间代码的**生成顺序**问题。某行使用了 `r["field@80:1-80:10"]`（读取），而这个 key 的赋值行在更后面才出现。当代码顺序执行到读取行时，proxy 的底层 table 里还没有这个 key，因此触发 `No such key` 错误。

#### 如何确认是时序问题

1. **确认哪个文件的 coder 失败了**：
   - `script/vm/coder/coder.lua` 在失败时会把中间代码保存到 `log/` 目录，文件名格式为：
     ```
     failed_coder_file____d_3A_github_vscode-lua-4_server_script_xxx.lua.log
     ```
   - 有多个失败时会生成多个文件（每个 URI 独立保存）
   - 用 `findstr /m "关键key名" log\failed_coder_*.log` 定位到具体文件

2. **查找 key 的使用行和赋值行**：
   ```bat
   findstr /n "field@80:1-80:10" log\failed_coder_xxx.lua.log
   ```
   输出示例：
   ```
   663:    r["param@80:30"]:setMasterVariable(r["field@80:1-80:10"])  ← 读取（早）
   712:    r["field@80:1-80:10"] = r["var:M@80:1-80:1"]:getChild(...) ← 赋值（晚）
   ```
   如果**读取行编号 < 赋值行编号**，就是典型的时序问题。

#### 常见时序问题根因

| 场景 | 问题描述 | 修复方向 |
|------|----------|----------|
| `assign` provider 中，函数体内 `setMasterVariable(field)` 引用了函数名 | `assign` 先编译 values（函数体），后编译 exps（函数名），导致函数名 key 在函数体内被引用时还未注册 | 将 `assign` 改为**先编译 exps**（注册 key），再编译 values（函数体），最后执行 `compileAssign` |
| `param` provider 里 `looksLikeSelf` 拿到 `parentVariable`（如 `field@M:method`），但此时 `parentVariable` 还未在中间代码里赋值 | 同上，函数名（exps）的编译在函数体之后 | 同上 |

#### 总结

| 情况 | 处置方式 |
|------|----------|
| `self.map[alias]` 报 `No such key` | 查 `LAST_CODE` 确认中间代码，查 `LAST_FLOW` 确认 flow 数据，**修复根本原因** |
| 确认是时序问题 | 用 `findstr /n` 在 `failed_coder_*.log` 里定位读取行与赋值行，调整 coder provider 的编译顺序 |
| 试图用 `pcall` 绕过 | ❌ 禁止，会掩盖真正的 bug |
| 试图用 `rawget` 绕过 | ❌ 禁止，`rawget` 绕过 proxy 但无法正确访问底层 t |

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
