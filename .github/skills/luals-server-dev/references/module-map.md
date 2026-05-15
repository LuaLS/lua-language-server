# 模块分工

## Parser
- `script/parser/compile.lua`：parser 公共入口，构建 `LuaParser.Ast`，并处理 goto/const 相关收尾逻辑。
- `script/parser/ast/`：AST 节点定义。
- `script/parser/ast/cats/`：LuaCats 专用语法与节点形式。

适用场景：
- 新语法支持。
- LuaCats 注解语法。
- parser 错误恢复、name/token 规则调整。

## Node Runtime
- `script/node/init.lua`：加载所有 node kind 和 runtime helper。
- 代表性节点包括 alias、class、union、intersection、function、variable、field、narrow、tracer。

规则：
- 新 node 模块必须在 `script/node/init.lua` 注册。
- 优先使用公开 Node API，如 `findValue`、`each`、variable child accessors。
- runtime 已有类型信息时，不要在 feature 层重复扫描原始 LuaDoc 文本。

## VM And Coder
- `script/vm/init.lua`：加载 VM 核心模块。
- `script/vm/virtual_file.lua`：文件级语义容器。
- `script/vm/coder/`：负责 AST 到 middle code 的转换、flow metadata 以及执行支持。

规则：
- 排查 tracer 时，应把 middle code 和 flow metadata 视为第一事实来源。
- 不要往 legacy `flow.lua` 或 `branch.lua` 里新增 narrowing 行为。

## Variable 与类型绑定关系

`Node.Variable` 上有两个关键集合，在 feature 层经常需要用来判断变量的绑定来源：

| 字段 | 含义 | 对应 LuaCats 注解 | coder 调用 |
|---|---|---|---|
| `variable.types` | 变量被 `---@type X` 标注 | `catstatetype` | `var:addType(type_node)` |
| `variable.classes` | 变量是 `---@class X` 的声明者 | `catstateclass` | `var:addClass(class_node)` |

### 从 source 找到 variable

```lua
local variable = param.vm:getVariable(param.source)
```

`param.vm:getVariable(source)` 通过 `virtual_file:getVariable(source)` 从 VM 文件中查找对应的 `Node.Variable`。

- `source` 是 `LuaParser.Node.Base`（如 `local`、`var`、`fieldid`、`catid` 等）。
- 返回 `Node.Variable?`，找不到时为 `nil`。
- **注意 shadow variable**：全局赋值 `t = {}` 中的 `var` 节点是 shadow，`addType`/`addClass` 等操作会被转发到 `masterVariable`。直接读 `variable.types` 可能为 nil，需用 `variable.masterVariable or variable` 拿到存储实际状态的节点。

### 常见判断模式

```lua
-- 判断 local/var 变量是否通过 @type 显式标注（而不是类的定义者）
local variable = param.vm:getVariable(param.source)
if variable then
    local effective = variable.masterVariable or variable
    local isTypeRef = effective.types ~= nil
end
```

- `effective.types ~= nil`：变量通过 `---@type X` 持有类型，属于类型使用者。
- `effective.classes ~= nil`（且无 types）：变量是 `---@class X` 的声明变量，属于类的定义者。
- `param.source.kind == 'catid'`：光标直接位于 `---@type <?A?>` 中的类型名，也是类型使用者。

### 相关文件
- `script/node/variable.lua`：`Node.Variable` 定义，含 `types`、`classes`、`addType`、`addClass`。
- `script/vm/coder/state.lua`：`tryBindCat()`，在编译 local/var 时将 catgroup 中的 `catstatetype`/`catstateclass` 绑定到变量。
- `script/vm/vm.lua` + `script/vm/virtual_file.lua`：`getVariable(source)` 实现。

## Language Features
- `script/feature/`：高层语言特性。
- `script/feature/completion/init.lua`：加载 completion providers。
- 当前 completion provider 包括 luacats、word、field、string、postfix、text。
- `script/feature/text-scanner.lua`：为 completion 做光标上下文扫描。

适用场景：
- completion 路由与 provider 行为。
- definition、hover、reference 等 feature 逻辑。
- 位于 VM/Node 之上的特性层 helper。

## Language Server
- `script/language-server/language-server.lua`：生命周期、transport loop、request resolution。
- `script/language-server/language-client.lua`：client capability 处理。

适用场景：
- request lifecycle。
- capability negotiation。
- transport 相关行为。

## Tests
- `test.lua`：测试启动与 filter 支持。
- `test/parser/`：parser 覆盖。
- `test/node/`：node runtime 覆盖。
- `test/coder/`：coder 与 flow 覆盖。
- `test/feature/`：面向最终行为的 feature 测试。
- `test/feature/completion/init.lua`：completion 测试 harness 和 provider 导入。

适用场景：
- 让测试尽量贴近你实际修改的子系统。
- 复用 `TEST_COMPLETION` 这类 helper，而不是手写零散断言。
