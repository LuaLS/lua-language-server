# 测试系统指南

## 运行测试

```bash
# Windows（在 server/ 目录下）

# 运行全部测试
bin\lua-language-server.exe test.lua

# 运行指定测试文件（支持路径过滤，斜杠/反斜杠均可）
bin\lua-language-server.exe test.lua test/feature/definition/luadoc.lua
bin\lua-language-server.exe test.lua test/node/tracer.lua

# 也可以指定到目录层级（运行该目录下所有测试）
bin\lua-language-server.exe test.lua test/feature/definition
bin\lua-language-server.exe test.lua test/node
```

测试通过时输出 `[xxx] 测试完毕`，失败时输出：
```
测试失败：
test\node\tracer.lua:123: expected: string | nil, actual: string.
```

## 测试目录结构

```
test/
├── node/       # Node 类型系统单元测试
│   ├── tracer.lua      # 类型收窄测试（最重要）
│   └── ...
├── parser/     # 解析器测试
├── coder/      # VM 编译 / flow 生成测试
│   └── flow.lua
├── feature/    # 语言特性集成测试
├── tools/      # 工具函数测试
├── catch.lua   # 测试运行器基础设施
├── ltest.lua   # 断言库（lt.assertEquals 等）
└── include.lua # 测试环境初始化
```

## 断言 API

使用 `lt`（ltest）提供的断言，核心如下：

```lua
lt.assertEquals(actual, expected)    -- 相等断言
lt.assertNotEquals(actual, expected) -- 不相等断言
lt.assertTrue(value)                 -- 为真
lt.assertFalse(value)                -- 为假
lt.assertNil(value)                  -- 为 nil
lt.assertNotNil(value)               -- 非 nil
```

## test.scope.rt（运行时工厂）

Node 系统的测试通过 `test.scope.rt` 创建运行时对象：

```lua
local rt = test.scope.rt

-- 基础类型常量
rt.STRING  -- string 类型节点
rt.NUMBER  -- number 类型节点
rt.NIL     -- nil 类型节点
rt.TRULY   -- 所有 truthy 值的占位符
rt.NEVER   -- never（空类型）

-- 节点工厂
rt.value(1)                  -- 字面量节点
rt.union { a, b }            -- 联合类型
rt.table { a = rt.STRING }   -- 表类型
rt.tuple { rt.value(1) }     -- 元组
rt.variable 'x'              -- 变量节点
rt.type 'MyClass'            -- 命名类型
rt.class('A')                -- 类定义
rt.field('a', rt.STRING)     -- 字段定义
rt.tracer(r, p)              -- 创建收窄追踪器

-- 重置运行时（每个 do...end 测试块开头调用）
rt:reset()
```

## 典型测试块结构

每个独立测试用 `do...end` 块隔离，注释说明对应的 Lua 代码语义：

```lua
do
    --[[
    ---@type string?
    local x
    if x then
        x   -- 应该是 string
    end
    ]]

    rt:reset()
    local r = {}
    local tracer = rt.tracer(r, {})

    r['x0'] = rt.variable 'x'
    r['x0']:addType(rt.STRING | rt.NIL)
    r['x1'] = r['x0']:shadow()
    r['x1']:setTracer(tracer)
    r['x2'] = r['x0']:shadow()
    r['x2']:setTracer(tracer)

    tracer:setFlow {
        { 'var', 'x', 'x0' },
        { 'if', {
            { 'condition', { 'ref', 'x', 'x1' } },
            { 'ref', 'x', 'x2' },
        }, {} },
    }

    lt.assertEquals(r['x2']:view(), 'string')
end
```

## 临时文件存放规范

在调试或测试过程中产生的临时文件（如 `.txt` 输出文件、中间结果等）**必须存放到 `/tmp` 目录**，该目录已被 `.gitignore` 忽略，不会提交到 git。

```
server/
└── tmp/          ← 所有临时文件放这里（已 gitignored）
    ├── test_output.txt
    ├── test_stderr.txt
    └── ...
```

**不要**把临时文件直接放在根目录或其他未被忽略的位置。

## 常见失败原因排查

| 现象 | 可能原因 |
|------|---------|
| `expected: A, actual: never` | 收窄过度，条件逻辑反了（revert 参数） |
| `expected: A, actual: A\|B` | 收窄未生效，stack 层次错误或 id 未匹配 |
| `expected: A\|B, actual: A` | 收窄过度，or/and 语义实现有误 |
| 测试挂起/无输出 | 死循环，检查 `getValue` 或 `narrowEqual` 中的循环引用 |

## 新增测试的规范

1. 在对应测试文件的末尾追加 `do...end` 块
2. 开头注释写出等价的 Lua 代码（用 `--[[ ... ]]` 包裹）
3. 调用 `rt:reset()` 重置状态
4. 创建所有需要的变量、alias、tracer
5. 设置 flow 并断言每个引用点的类型
6. 测试应覆盖 true 分支、false 分支、分支后三种情况
