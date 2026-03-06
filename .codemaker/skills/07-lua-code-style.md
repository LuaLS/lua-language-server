# Lua 代码风格规范

## 多条件 if 语句格式

当 `if` 语句有多个 `and` / `or` 条件并列时，每个条件独占一行，`and` / `or` 与 `if` 的 `i` 对齐（`if` 后跟两个空格以补齐宽度）：

```lua
if  condition1
and condition2
and condition3 then
    doSomething()
end
```

```lua
if condition1
or condition2
or condition3 then
    doSomething()
end
```

混合示例：

```lua
if  type(name) == 'string'
and var.assigns
and ls.util.stringSimilar(word, name, true) then
    action.push {
        label = name,
        kind  = ls.spec.CompletionItemKind.Field,
    }
end
```

> **注意**：单个条件仍用普通 `if condition then` 格式，不需要强制换行。
