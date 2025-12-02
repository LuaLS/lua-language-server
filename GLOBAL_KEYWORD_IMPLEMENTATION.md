# Lua 5.5 `global` 关键字实现

## 概述

本次修改为 Lua Language Server 添加了对 Lua 5.5 新增的 `global` 关键字的语法解析支持。

## 语法规则

根据 Lua 5.5 的语法规范，`global` 关键字支持以下三种形式：

### 1. 全局函数声明
```lua
global function funcName()
    -- function body
end
```

### 2. 全局变量声明（带属性）
```lua
-- 单个变量
global x

-- 带属性的变量
global <const> y

-- 多个变量
global a, b, c

-- 带属性的多个变量
global <const> x, <close> y, z
```

### 3. 全局所有变量声明
```lua
-- 声明所有后续变量为全局
global *

-- 带属性的全局所有变量
global <const> *
```

## 实现细节

### 1. 关键字识别 (`isKeyWord` 函数)

在 `compile.lua` 的 `isKeyWord` 函数中添加了对 `global` 关键字的处理：

```lua
if word == 'global' then
    if State.version == 'Lua 5.5' then
        return true
    end
    return false
end
```

类似于 `goto` 关键字的处理方式，`global` 仅在 Lua 5.5 版本中被视为关键字。在其他版本中，它可以作为普通标识符使用。

### 2. 解析函数 (`parseGlobal` 函数)

创建了新的 `parseGlobal` 函数来处理三种不同的 global 语法形式：

- **全局函数**: 调用 `parseFunction` 并将返回的名称类型设置为 `'setglobal'`
- **全局变量**: 解析 attnamelist，支持前置和后置属性
- **全局所有**: 创建特殊的 `'globalall'` 节点

### 3. 语法分发 (`parseAction` 函数)

在 `parseAction` 函数中添加了对 `global` 关键字的检查：

```lua
if token == 'global' and isKeyWord('global', Tokens[Index + 3]) then
    return parseGlobal()
end
```

## 生成的 AST 节点类型

### setglobal 节点
用于全局变量和全局函数声明：
```lua
{
    type = 'setglobal',
    start = <position>,
    finish = <position>,
    [1] = <variable_name>,
    attrs = <optional_attributes>,
    value = <optional_function_or_value>
}
```

### globalall 节点
用于 `global *` 声明：
```lua
{
    type = 'globalall',
    start = <position>,
    finish = <position>,
    attrs = <optional_attributes>
}
```

## 版本兼容性

- **Lua 5.5**: `global` 作为关键字，启用完整的语法解析
- **Lua 5.4 及更早版本**: `global` 作为普通标识符，可以用作变量名

## 测试建议

要测试此实现，需要：

1. 设置项目的 Lua 版本为 5.5
2. 创建包含 global 声明的测试文件
3. 验证语法高亮和错误检查是否正常工作

示例测试代码：
```lua
-- 这些在 Lua 5.5 中应该正常解析
global function test()
    print("hello")
end

global x
global <const> y
global a, b, c
global *

-- 这在非 Lua 5.5 版本中应该可以正常使用
local global = 10  -- 'global' 作为变量名
```

## 修改的文件

本次实现仅修改了一个文件：

- `script/parser/compile.lua`

### 修改内容总结

1. **isKeyWord 函数** (约第 1391 行)
   - 添加了对 `global` 关键字的版本检查
   - 仅在 Lua 5.5 中将其识别为关键字

2. **parseGlobal 函数** (约第 3123 行，新增)
   - 完整实现了三种 global 语法的解析
   - 支持初始化赋值：`global x = 10`
   - 处理属性（attrib）的解析和关联
   - 支持多变量声明的解析：`global a, b, c = 1, 2, 3`
   - 检查 global 不能有 close 属性
   - 使用 parseMultiVars 处理初始化赋值

3. **parseAction 函数** (约第 4117 行)
   - 添加了 global 关键字的分发逻辑
   - 使用 `isKeyWord` 检查确保版本正确性

## 使用示例

在支持 Lua 5.5 的环境中，以下代码将被正确解析：

```lua
-- 示例 1: 声明全局函数
global function myGlobalFunction()
    return 42
end

-- 示例 2: 声明全局变量（无初始化）
global x

-- 示例 3: 声明并初始化全局变量
global y = 100

-- 示例 4: 声明带常量属性的全局变量
global <const> PI = 3.14159

-- 示例 5: 声明多个全局变量
global width, height, depth

-- 示例 6: 声明并初始化多个全局变量
global a, b, c = 1, 2, 3

-- 示例 7: 声明带不同属性的多个全局变量
global <const> MAX_SIZE = 100, counter = 0

-- 示例 8: 属性可以在变量名前后
global x <const>, <const> y

-- 示例 9: 声明所有后续变量为全局（可读写）
global *
x = 1  -- x 自动成为全局变量
y = 2  -- y 自动成为全局变量

-- 示例 10: 声明所有后续变量为只读全局
global <const> *
print(math.pi)  -- OK，print 和 math 自动为只读
z = 1           -- 错误！z 被声明为只读
```

### 错误示例

```lua
-- 错误 1: global 不能有 close 属性
global x <close>  -- 解析错误！

-- 错误 2: 在隐式 global * 失效的作用域内使用未声明变量
global x
y = 1  -- 错误：y 未声明（需要语义分析支持）

-- 错误 3: 赋值给 const 变量
global <const> PI = 3.14
PI = 3.15  -- 错误：不能赋值给常量（需要语义分析支持）

-- 错误 4: 初始化已存在的全局变量
X = 10
global X = 20  -- 运行时错误：X 已定义（需要语义分析支持）
```

## 后续工作

当前实现仅包括语法解析层面的支持。完整的功能还需要：

1. **语义分析支持**
   - 变量作用域处理
   - 引用关系跟踪
   - `globalall` 声明的作用域影响

2. **类型推断支持**
   - 全局变量的类型推断
   - 属性（const/close）的类型约束

3. **代码补全支持**
   - global 关键字的补全
   - 全局变量的智能提示

4. **诊断和错误检查**
   - 重复声明检查
   - 常量修改检查
   - close 属性的正确性验证

5. **文档生成支持**
   - 全局变量的文档注释
   - API 文档生成

这些功能需要在以下模块中进行相应的修改：
- `script/vm/*` - 虚拟机和语义分析
- `script/core/completion.lua` - 代码补全
- `script/core/diagnostics.lua` - 诊断
- `script/core/hover.lua` - 悬停提示
- 等等

## 兼容性说明

此实现完全向后兼容：

- **Lua 5.5**: `global` 是保留关键字，按新语法解析
- **Lua 5.4 及以下**: `global` 是普通标识符，可以用作变量名或函数名

示例：
```lua
-- 在 Lua 5.4 中，这是有效的：
local global = "这是一个变量"
function global() 
    return "这是一个函数"
end

-- 在 Lua 5.5 中，上述代码会报错，因为 global 是关键字
```

## 技术细节

### attnamelist 的解析

attnamelist 的语法定义为：
```
attnamelist ::= [attrib] Name [attrib] {',' Name [attrib]}
```

这意味着属性可以出现在变量名之前或之后。我们的实现支持这两种情况：

```lua
-- 属性在前
global <const> x

-- 属性在后  
global x <const>

-- 混合使用
global <const> x <close>, y, <const> z
```

### AST 节点设计

所有 global 声明都会生成适当的 AST 节点，与现有的 `local` 声明保持一致的结构，便于后续的语义分析和其他处理。
