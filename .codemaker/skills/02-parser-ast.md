# 解析器与 AST

## 概述

`script/parser/` 负责将 Lua 源码解析为 AST（抽象语法树）。解析器是手写的递归下降解析器，支持完整 Lua 语法以及 LuaCats 注解（`---@xxx`）。

## 目录结构

```
script/parser/
├── lexer.lua           # 词法分析器（tokenizer）
├── compile.lua         # 编译入口
├── init.lua            # 模块初始化
└── ast/
    ├── ast.lua         # AST 节点基类
    ├── main.lua        # 顶层解析调度
    ├── exp.lua         # 表达式解析
    ├── block.lua       # 语句块解析
    ├── state/          # 各类语句（if/while/for/local...）
    │   ├── if.lua
    │   ├── local.lua
    │   ├── for.lua
    │   └── ...
    └── cats/           # LuaCats 注解
        ├── class.lua   # ---@class
        ├── field.lua   # ---@field
        ├── param.lua   # ---@param
        ├── return.lua  # ---@return
        ├── type.lua    # ---@type
        ├── union.lua   # A | B
        ├── generic.lua # ---@generic
        └── ...
```

## 解析入口

```lua
local ast = require 'parser'
local tree = ast:parse(source, uri)
```

## AST 节点结构

AST 节点是 Lua table，包含：
- `type`：节点类型字符串（如 `'if'`、`'local'`、`'binary'`）
- `start`、`finish`：源码偏移量
- 各字段按节点类型而定

常见节点示例：
```lua
-- if 语句
{ type='if', start=0, finish=20,
  ifBlock = { condition=..., body=... },
  elseifBlocks = { ... },
  elseBlock = ... }

-- 局部变量
{ type='local', start=0, finish=10,
  names = { {type='id', name='x'} },
  values = { ... } }

-- 二元表达式
{ type='binary', op='and', left=..., right=... }
```

## LuaCats 注解（cats）

注解解析在 `ast/cats/` 中，每个文件对应一种注解标签：

| 文件 | 注解 | 示例 |
|------|------|------|
| `class.lua` | `---@class` | `---@class MyClass: Base` |
| `field.lua` | `---@field` | `---@field name string` |
| `param.lua` | `---@param` | `---@param x number` |
| `return.lua` | `---@return` | `---@return string` |
| `type.lua`  | `---@type`  | `---@type string\|nil` |
| `generic.lua` | `---@generic` | `---@generic T` |
| `alias.lua` | `---@alias` | `---@alias MyType string` |

## 新增语法注意事项

1. 词法层：在 `lexer.lua` 中添加 token 识别
2. 语法层：
   - 表达式 → `ast/exp.lua`
   - 语句 → `ast/state/` 对应文件
   - 注解 → `ast/cats/` 新建文件，并在 `ast/cats/cat.lua` 注册
3. 测试：在 `test/parser/` 添加解析测试用例
