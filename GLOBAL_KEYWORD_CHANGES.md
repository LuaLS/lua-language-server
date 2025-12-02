# Lua 5.5 `global` 关键字语法支持 - 变更摘要

## 概述
为 Lua Language Server 添加了对 Lua 5.5 新增的 `global` 关键字的完整语法解析支持。

## 修改的文件
- `script/parser/compile.lua`

## 主要变更

### 1. 关键字识别 (第 1391-1420 行)
在 `isKeyWord` 函数中添加了对 `global` 关键字的处理：
- 仅在 Lua 5.5 中将 `global` 视为关键字
- 其他版本中可作为普通标识符使用
- 与 `goto` 关键字的处理方式一致

### 2. 解析函数 (第 3130-3274 行)
新增 `parseGlobal` 函数，支持三种语法形式：

**a) 全局函数声明**
```lua
global function funcName() end
```

**b) 全局变量声明（带属性）**
```lua
global x                          -- 单个变量
global <const> y                  -- 带属性
global a, b, c                    -- 多个变量
global <const> x, <close> y, z    -- 混合属性
```

**c) 全局所有变量**
```lua
global *              -- 所有后续变量为全局
global <const> *      -- 带属性的全局所有
```

### 3. 语法分发 (第 4117-4119 行)
在 `parseAction` 函数中添加了 global 关键字的检查和分发：
```lua
if token == 'global' and isKeyWord('global', Tokens[Index + 3]) then
    return parseGlobal()
end
```

## 生成的 AST 节点

### setglobal 节点
用于全局变量和函数声明：
```lua
{
    type = 'setglobal',
    start = <position>,
    finish = <position>,
    [1] = <variable_name>,
    attrs = <optional_attributes>,  -- 可选的属性列表
    value = <optional_value>        -- 对于函数声明
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

## 兼容性

- **Lua 5.5**: `global` 是保留关键字
- **Lua 5.4 及以下**: `global` 可用作标识符

## 测试

要测试此功能：
1. 设置 Lua 版本为 5.5
2. 使用包含 global 声明的代码
3. 验证语法高亮和解析正确性

## 下一步

此实现仅完成了语法解析。完整的功能还需要：
- 语义分析（作用域、引用）
- 类型推断
- 代码补全
- 诊断检查
- 文档生成

详见 `GLOBAL_KEYWORD_IMPLEMENTATION.md`
