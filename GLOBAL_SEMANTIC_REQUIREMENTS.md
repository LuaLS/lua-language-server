# Lua 5.5 `global` 关键字语义分析需求

## 当前状态

✅ **已完成：语法解析层 (Parser)**
- 解析 `global function Name funcbody`
- 解析 `global attnamelist ['=' explist]`
- 解析 `global [attrib] '*'`
- 支持属性（const/close）的解析
- 检查 global 不能有 close 属性
- 支持初始化赋值

⬜ **待实现：语义分析层 (Semantic Analysis)**

## 核心语义规则

### 1. 隐式 `global *` 机制

**规则**：每个 chunk 开始时都有一个隐式的 `global *` 声明。

```lua
-- 每个文件隐式以此开始：
-- (implicit) global *

X = 1  -- OK，因为隐式 global * 使 X 成为全局变量
```

**实现需求**：
- 在 chunk 开始时创建隐式的 `global *` 作用域标记
- 跟踪隐式 `global *` 的有效性状态

### 2. global 声明使隐式 `global *` 失效

**规则**：任何显式的 `global` 声明会在其作用域内使隐式 `global *` 失效（void）。

```lua
X = 1       -- OK，隐式 global * 有效
do
  global Y  -- 显式 global 声明
  Y = 1     -- OK，Y 已声明
  X = 1     -- 错误！隐式 global * 在此作用域内失效，X 未声明
end
X = 2       -- OK，回到外层作用域，隐式 global * 恢复
```

**实现需求**：
- 当遇到任何 `global` 声明时，标记当前作用域的隐式 `global *` 为 void
- 作用域结束时恢复外层的隐式 `global *` 状态
- 在失效的作用域内，未声明的变量引用应报错

### 3. 初始化的特殊规则

**规则**：

| 声明类型 | 无初始化 | 有初始化 |
|---------|---------|---------|
| `local x` | 初始化为 `nil` | 按多重赋值规则 |
| `global x` | **保持不变** | **如果已定义（非 nil）则运行时错误** |

**重要发现**：global 声明是**全局性的**，不受词法作用域限制。即使在不同的词法作用域中声明，也会影响同一个全局变量。

```lua
-- 测试 1: 声明后初始化 - OK
global X
global X = 1  -- OK，X 之前未初始化

-- 测试 2: 初始化后声明 - OK
global Y = 2  -- OK，首次初始化
global Y      -- OK，只是声明，不修改值

-- 测试 3: 两次初始化 - ERROR
global Z = 3
global Z = 4  -- 运行时错误！Z 已经定义（非 nil）

-- 测试 4: global 声明是全局的，不是词法作用域的
do
  global X = 1  -- X 进入全局环境
end
global X = 2    -- 错误！X 已经在全局环境中定义了
global X        -- OK，只是声明
```

**关键理解**：
1. `global x` 的"已定义"检查是针对**全局环境**的，而不是词法作用域
2. 多次 `global x`（无初始化）是允许的
3. 一旦 `global x = value` 执行，x 在全局环境中就有值了
4. 再次 `global x = value2` 会检测到 x 已定义并报错

**实现需求**：
- 检查 `global x = value` 时，需要查询全局环境中 x 是否已有值
- 这是**运行时检查**，不是编译时检查
- 在语义分析层，我们可以提供**警告**：
  - 如果在同一文件中检测到同一个全局变量的两次初始化
  - 如果跨文件，可能需要全局符号表来检测

### 4. `global *` vs `global <const> *`

**规则**：

```lua
-- global * - 所有未声明变量自动成为可读写全局
global *
X = 1    -- OK，X 自动声明为全局可读写
Y = 2    -- OK，Y 自动声明为全局可读写

-- global <const> * - 所有未声明变量自动成为只读全局
global <const> *
print(math.pi)  -- OK，print 和 math 自动为只读
X = 1           -- 错误！X 自动声明为只读，不能赋值
```

**实现需求**：
- 跟踪 `global *` 的 const 属性
- 在变量赋值时检查是否为 const
- 区分显式声明和隐式声明（通过 global *）

### 5. const 属性的赋值限制

**规则**：const 变量不能作为赋值的左侧。

```lua
global <const> PI = 3.14159
PI = 3.14       -- 编译时错误

global X <const>, _G
X = 1           -- 编译时错误（语法检查）
_ENV.X = 1      -- OK（绕过语法检查）
```

**实现需求**：
- 在赋值语句中检查左侧变量是否为 const
- 仅在直接赋值时检查，`_ENV.X` 形式的赋值不检查
- 生成相应的诊断错误

### 6. 作用域和遮蔽

**规则**：内层声明遮蔽外层同名声明。

```lua
global print, x
x = 10                -- 全局 x
do                    
  local x = x         -- 新的局部 x，右侧是全局 x
  print(x)            --> 10
  do                  
    global x          -- 新的全局 x（遮蔽外层的全局 x）
    x = 20            -- 赋值给内层的全局 x
  end
end
print(x)              --> 10 (外层全局 x 未改变)
```

**实现需求**：
- 正确处理多层作用域
- 内层 global 声明遮蔽外层
- 引用解析时找到最内层的声明

## 需要添加的诊断类型

### 1. VARIABLE_NOT_DECLARED
在显式 global 作用域内使用未声明的变量。

```lua
global X
Y = 1  -- 错误：Y 未声明
```

### 2. GLOBAL_ALREADY_DEFINED
初始化已定义的全局变量（警告级别）。

```lua
global X = 10
global X = 20  -- 警告：X 可能在运行时已定义
```

**注意**：这是运行时错误，编译时只能给出警告，因为：
1. 全局变量可能来自其他文件
2. 全局变量可能在运行时动态创建
3. 只有当变量在**同一文件**中先初始化后再次初始化时，才能确定报错

### 3. ASSIGN_TO_CONST
赋值给 const 变量。

```lua
global <const> PI = 3.14
PI = 3.15  -- 错误：不能赋值给常量
```

### 4. GLOBAL_CLOSE_ATTRIBUTE
global 变量不能有 close 属性。

```lua
global x <close>  -- 错误：global 不能有 close 属性
```

## 实现模块

需要修改的模块：

### 1. `script/vm/scope.lua` 或 `script/vm/global-manager.lua` (新建)
- 跟踪全局变量的声明和初始化
- 维护每个文件的全局变量表
- 记录每个全局变量的：
  - 首次声明位置
  - 首次初始化位置
  - 是否有 const 属性
  - 来源于哪个 global 声明（普通/`global *`/`global <const> *`）

**数据结构建议**：
```lua
{
    globals = {
        ['X'] = {
            declarations = {
                { position = ..., hasInit = false },
                { position = ..., hasInit = true },  -- 第一次初始化
            },
            isConst = false,
            fromGlobalAll = false,
        }
    }
}
```

### 2. `script/vm/compiler.lua`
- 处理 global 声明的编译
- ~~生成初始化检查代码~~（注：这是运行时行为，LSP 不需要生成）

### 3. `script/core/diagnostics.lua` 
添加新的诊断规则：

#### 诊断实现优先级：

**P0 - 高优先级（确定性错误）：**
1. **GLOBAL_CLOSE_ATTRIBUTE** - global 不能有 close 属性（✅ 已在 parser 实现）
2. **ASSIGN_TO_CONST** - 赋值给 const 全局变量

**P1 - 中优先级（作用域错误）：**
3. **VARIABLE_NOT_DECLARED** - 在显式 global 作用域内使用未声明变量

**P2 - 低优先级（警告）：**
5. **POSSIBLE_GLOBAL_REDEFINITION** - 可能的跨文件重复初始化（警告）

#### 详细实现说明：

**ASSIGN_TO_CONST**:
```lua
-- 检测逻辑：
-- 1. 扫描 global 声明，维护 const 全局变量列表
-- 2. 扫描所有赋值语句（setglobal 节点）
-- 3. 如果赋值目标是 const 变量，报错

global <const> PI = 3.14
PI = 3.15  -- 错误！PI 是常量
```

**VARIABLE_NOT_DECLARED**:
```lua
-- 检测逻辑：
-- 1. 跟踪当前作用域是否有显式 global 声明
-- 2. 如果有，隐式 global * 失效
-- 3. 检查 getglobal 节点是否对应已声明的变量
-- 4. 如果未声明，报错

global X
Y = 1  -- 错误！Y 未声明（隐式 global * 已失效）
```

### 4. `script/core/completion.lua`
- 提供 global 关键字补全
- 提供已声明全局变量的补全

### 5. `script/core/hover.lua`
- 显示全局变量的声明信息
- 显示 const/read-only 属性

## 实现优先级

### 阶段 1：基础作用域支持
1. 实现隐式 `global *` 的跟踪
2. 实现 global 声明使隐式 `global *` 失效
3. 添加 VARIABLE_NOT_DECLARED 诊断

### 阶段 2：属性支持
1. 实现 const 属性的跟踪
2. 添加 ASSIGN_TO_CONST 诊断
3. 实现 `global <const> *` 的语义

### 阶段 3：高级功能
1. 实现初始化检查
2. 实现作用域遮蔽的完整逻辑
3. 添加代码补全和悬停提示

## 测试用例

### 测试 1：基本 global 声明
```lua
global x
x = 10  -- OK
y = 20  -- 错误：y 未声明
```

### 测试 2：隐式 global * 失效
```lua
x = 1       -- OK
do
  global y
  y = 1     -- OK
  x = 1     -- 错误：x 未声明
end
x = 2       -- OK
```

### 测试 3：同一文件中重复初始化
```lua
global X = 10
global X = 20  -- 错误/警告：X 在本文件中已初始化
```

### 测试 4：声明后初始化
```lua
global X
global X = 10  -- OK，第一次初始化
```

### 测试 5：初始化后声明
```lua
global X = 10
global X       -- OK，只是声明，不修改
```

### 测试 6：跨作用域的全局性
```lua
do
  global X = 1  -- X 进入全局环境
end
global X = 2    -- 错误：X 已在全局环境中定义
global X        -- OK：只是声明
```

### 测试 7：const 属性
```lua
global <const> PI = 3.14159
PI = 3.14   -- 错误：不能赋值给常量
```

### 测试 8：global *
```lua
global *
x = 1  -- OK，自动全局
y = 2  -- OK，自动全局
```

### 测试 9：global <const> *
```lua
global <const> *
print(x)  -- OK，x 自动只读
x = 1     -- 错误：x 是只读的
```

### 测试 4：global *
```lua
global *
x = 1  -- OK，自动全局
y = 2  -- OK，自动全局
```

### 测试 5：global <const> *
```lua
global <const> *
print(x)  -- OK，x 自动只读
x = 1     -- 错误：x 是只读的
```

### 测试 6：初始化
```lua
global x = 10     -- OK
global y = 20     -- OK
global x = 30     -- 运行时错误：x 已定义
```

## 兼容性注意事项

- 仅在 Lua 5.5 中启用这些语义
- Lua 5.4 及以下版本不受影响
- 提供配置选项启用/禁用严格的 global 检查
