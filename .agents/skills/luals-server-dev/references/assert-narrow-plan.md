# assert 签名注解收窄 规划

## 背景

`assert(cond)` 作为语句时，其后同一 block 作用域内 `cond` 应收窄为 truthy。
当前缺口：语句级 call 在 flow DSL 中有 entry，但 Walker `traceUnit` 不处理 `call` tag，
收窄只在条件表达式（`if fn() then`）里通过 `traceCallTruly` 触发。

## 核心约束

- 不按函数名硬编码判断 assert。
- 原理上应在运行时根据函数签名注解了解 assert 语义。
- 现有签名系统（`paramsPack`/`returnsDef`）尚未实现，narrow 注解独立于签名结构，未来可迁移。

## 现状资产（已支付成本，复用）

| 资产 | 位置 | 说明 |
|---|---|---|
| flow DSL block 含所有 call entry | `script/vm/coder/tracer.lua` `T:appendCall` | 每条 call 已生成 `{'call', funcAlias, argAliases}` |
| 按签名收窄参数为 truthy | `script/node/tracer.lua:551` `W:traceCallTruly` | 已实现，仅在条件表达式触发 |
| 函数节点解析 | `script/node/tracer.lua` `getFuncVar` | 已有 |
| 收窄原语 | `script/node/narrow.lua` | `matchTruly` / `matchValue` / `asCall` 全具备 |
| 注解绑定链路 | `script/vm/coder/function.lua` `findNearedCats` | cat 注解 → `Node.Function` 注入路径 |

## 注解语法

```
---@narrow [paramName] [narrowedType?]
```

- `narrowedType` 缺省 → truthy 收窄（`matchTruly`，assert 语义）。
- `narrowedType` 给出 → 收窄为指定类型（`matchValue`，assertIsString 语义）。
- 可多行注解多次窄化多个参数。

### 对照其他语言

| 语言 | 对应物 | 本设计 |
|---|---|---|
| TypeScript | `asserts v is string` | `---@narrow v string` |
| Kotlin | `returns(true) implies (v != null)` | `---@narrow v` |
| Python | `-> TypeIs[str]` | `---@narrow v string` |

## 落地链路

| 层 | 文件 | 改动 |
|---|---|---|
| parser | `script/parser/ast/cats/cat.lua` | `registerCatParser('narrow', ...)` + `parseCatStateNarrow`（仿 `param.lua`，解析 paramName + CatExp） |
| parser | `script/parser/ast/cats/narrow.lua`（新） | `CatStateNarrow` 节点定义 |
| coder | `script/vm/coder/cat.lua` | `catstatenarrow` provider，编译注解 |
| coder | `script/vm/coder/function.lua` | `findNearedCats(source,'catstatenarrow')` → `func:addNarrowDef(name, type)` |
| node | `script/node/function.lua` | `Node.Function:addNarrowDef` / `getNarrowDefs` 存储 |
| runtime | `script/node/tracer.lua` | `traceUnit` 加 `call` 分支 → 查 `func` 的 narrowDefs → 命中则 `rt.narrow(arg):matchTruly()` / `matchValue()` |
| meta | `meta/template/basic.lua` | assert 加 `---@narrow v` |

## meta 里 assert 声明（最终形态）

```lua
---@generic T
---@param v? T
---@param message? any
---@param ... any
---@return T
---@return any ...
---@narrow v
function assert(v, message, ...) end
```

## 边界

- ✅ 签名注解独立于现有 `paramsPack`/`returnsDef`，不破坏未实现的签名系统。
- ✅ 运行时判函数（读 `Function` 节点注解），非函数名硬编码。
- ✅ `traceCallTruly`（条件表达式）与 `---@narrow`（语句级）并存，互不干扰。
- ✅ 非 narrow 函数调用直接跳过，无额外收窄、无 propagate。
- ✅ 注解在 meta 编译期解析一次，缓存于 `Function` 节点，Walker O(1) 查表。

## 验证

- `bin\\lua-language-server.exe --test parser`：narrow 注解解析。
- `bin\\lua-language-server.exe --test node`：Function narrowDefs 存储。
- `bin\\lua-language-server.exe --test coder`：flow DSL call entry 不变。
- `bin\\lua-language-server.exe --test feature`：assert 收窄行为。
