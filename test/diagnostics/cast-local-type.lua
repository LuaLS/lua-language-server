local config = require "config.config"
TEST [[
local x = 0

<!x!> = true
]]

TEST [[
---@type integer
local x

<!x!> = true
]]

TEST [[
---@type unknown
local x

x = nil
]]

TEST [[
---@type unknown
local x

x = 1
]]

TEST [[
---@type unknown|nil
local x

x = 1
]]

TEST [[
local x = {}

x = nil
]]

TEST [[
---@type string
local x

<?x?> = nil
]]

TEST [[
---@type string?
local x

x = nil
]]

TEST [[
---@type table
local x

<!x!> = nil
]]

TEST [[
local x

x = nil
]]

TEST [[
---@type integer
local x

---@type number
<!x!> = f()
]]

TEST [[
---@type number
local x

---@type integer
x = f()
]]

TEST [[
---@type number|boolean
local x

---@type string
<!x!> = f()
]]

TEST [[
---@type number|boolean
local x

---@type boolean
x = f()
]]

TEST [[
---@type number|boolean
local x

---@type boolean|string
<!x!> = f()
]]

TEST [[
---@type boolean
local x

if not x then
    return
end

x = f()
]]

TEST [[
---@type boolean
local x

---@type integer
local y

<!x!> = y
]]

TEST [[
local y = true

local x
x = 1
x = y
]]

TEST [[
local t = {}

local x = 0
x = x + #t
]]

TEST [[
local x = 0

x = 1.0
]]

TEST [[
---@class A

local t = {}

---@type A
local a

t = a
]]

TEST [[
---@type integer
local x

x = 1.0
]]

TEST [[
---@type integer
local x

<!x!> = 1.5
]]

TEST [[
---@type integer
local x

x = 1 + G
]]

TEST [[
---@type integer
local x

x = 1 + G
]]

TEST [[
---@alias A integer

---@type A
local a

---@type integer
local b

b = a
]]

TEST [[
---@type string[]
local t

<!t!> = 'xxx'
]]

TEST [[
---@type 1|2
local x

x = 1
x = 2
<!x!> = 3
]]

TEST [[
---@type 'x'|'y'
local x

x = 'x'
x = 'y'
<!x!> = 'z'
]]

TEST [[
local t = {
    x = 1,
}

local x
t[x] = true
]]

TEST [[
---@type table<string, string>
local x

---@type table<number, string>
local y

<!x!> = y
]]

TEST [[
---@type table<string, string>
local x

---@type table<string, number>
local y

<!x!> = y
]]

TEST [[
---@type table<string, string>
local x

---@type table<string, string>
local y

x = y
]]

TEST [[
---@type { x: number, y: number }
local t1

---@type { x: number }
local t2

<!t1!> = t2
]]

TEST [[
---@type { x: number, [integer]: number }
local t1

---@type { x: number }
local t2

<!t1!> = t2
]]

TEST [[
local x

if X then
    x = 'A'
elseif X then
    x = 'B'
else
    x = 'C'
end

local y = x

<!y!> = nil
]]
(function (diags)
    local diag = diags[1]
    assert(diag.message == [[
已显式定义变量的类型为 `string` ，不能再将其类型转换为 `nil`。
- `nil` 无法匹配 `string`
- 类型 `nil` 无法匹配 `string`]])
end)

TEST [[
---@type 'A'|'B'|'C'|'D'|'E'|'F'|'G'|'H'|'I'|'J'|'K'|'L'|'M'|'N'|'O'|'P'|'Q'|'R'|'S'|'T'|'U'|'V'|'W'|'X'|'Y'|'Z'
local x

<!x!> = nil
]]
(function (diags)
    local diag = diags[1]
    assert(diag.message == [[
已显式定义变量的类型为 `'A'|'B'|'C'|'D'|'E'...(+21)` ，不能再将其类型转换为 `nil`。
- `nil` 无法匹配 `'A'|'B'|'C'|'D'|'E'...(+21)`
- `nil` 无法匹配 `'A'|'B'|'C'|'D'|'E'...(+21)` 中的任何子类
- 类型 `nil` 无法匹配 `'Z'`
- 类型 `nil` 无法匹配 `'Y'`
- 类型 `nil` 无法匹配 `'X'`
- 类型 `nil` 无法匹配 `'W'`
- 类型 `nil` 无法匹配 `'V'`
- 类型 `nil` 无法匹配 `'U'`
- 类型 `nil` 无法匹配 `'T'`
- 类型 `nil` 无法匹配 `'S'`
- 类型 `nil` 无法匹配 `'R'`
- 类型 `nil` 无法匹配 `'Q'`
...(+13)
- 类型 `nil` 无法匹配 `'C'`
- 类型 `nil` 无法匹配 `'B'`
- 类型 `nil` 无法匹配 `'A'`]])
end)

TEST [[
---@class A
---@field x string
---@field y number

local a = {x = "", y = 0}

---@type A
local v
v = a
]]

config.set(nil, 'Lua.type.checkTableShape', true)

TEST [[
---@class A
---@field x string
---@field y number

local a = {x = ""}

---@type A
local v
<!v!> = a
]]

TEST [[
---@class A
---@field x string
---@field y number

local a = {x = "", y = ""}

---@type A
local v
<!v!> = a
]]

TEST [[
---@class A
---@field x string
---@field y? B

---@class B
---@field x string

local a = {x = "b", y = {x = "c"}}

---@type A
local v
v = a
]]

TEST [[
---@class A
---@field x string
---@field y B

---@class B
---@field x string

local a = {x = "b", y = {}}

---@type A
local v
<!v!> = a
]]

config.set(nil, 'Lua.type.checkTableShape', false)
