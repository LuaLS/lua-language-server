# Always trace local set

```lua
local x
x = 1
x = true
print(x) --> x is `integer|boolean`
```

```lua
---@type string
local x
x = 1
x = true
print(x) --> x is `string`
```

# Dose not trace field inject

```lua
local x = {}
local y = x
y.field = 1

print(x.field) --> undefined field `field`
```

# Dose not search metatable in this case

```lua
setmetatable(object, { __index = {
    default = 1
} })
print(object.default) --> undefined field `default`
```

This turns the reference into a definition, and checking the reference in order to search for a definition is too expensive.

Please use `---@class` or use this:

```lua
object = setmetatable(object, { __index = {
    default = 1
} })
print(object.default) --> this is OK
```

# Finding definition does not recurse

```lua
local t = {}
t.x = 1
t.y = t.x

print(t.y) --> t.y is `1`
```

Find definition of `t.y` will not find out `t.x`

```lua
---@class C
local mt = {}

---@type C
local o
```

Find definition of `o` will not find out `mt`

# Type `unknown`

```lua
local t = {}
print(t.x) --> t.x is `unknown` instead of `any`
```

# Types can be used in doc-table keys

```lua
---@type { [number]: string }
local t

print(t[1]) --> t[1] is `string`
print(t.x) --> t.x is `unknown`
```

# Type `true` and `false`

```lua
---@class true: boolean  --> this is builtin
---@class false: boolean --> this is builtin
```

You can use `---@type { [string]: true }` now.

# `class` and `alias` support generic inheritance

```lua
---@class table<K, V>: { [K]: V } --> this is builtin

---@alias mark<K> { [K]: true } 
```

# `table<integer, string>` can not convert to `string[]`

```lua
---@type table<integer, string>
local t = {}

for k, v in ipairs(t) do --> v is `unknown`
end
```

# Default value of `unrary` and `binary`

```lua
---@type unknown
local x

local y = - x --> y is `number` instead of `unknown`
```

# `unknown` can form union types with other types

```lua
function f()
    if x then
        return y
    else
        return nil
    end
end

local n = f() --> n is `unknown|nil`
```
