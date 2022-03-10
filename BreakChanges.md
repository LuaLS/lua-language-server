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
