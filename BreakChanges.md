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
