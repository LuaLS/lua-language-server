local config = require 'config'

config.add(nil, 'Lua.diagnostics.disable', 'unused-local')
config.add(nil, 'Lua.diagnostics.disable', 'undefined-global')

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
---@type integer
local x = 0

<!x!> = 1.0
]]

TEST [[
---@class A

local t = {}

---@type A
local a

t = a
]]

TEST [[
local m = {}

---@type integer[]
m.ints = {}
]]

TEST [[
---@class A
---@field x A

---@type A
local t

t.x = {}
]]

TEST [[
---@class A
---@field x integer

---@type A
local t

<!t.x!> = true
]]

TEST [[
---@class A
---@field x integer

---@type A
local t

---@type boolean
local y

<!t.x!> = y
]]

TEST [[
---@class A
local m

m.x = 1

---@type A
local t

<!t.x!> = true
]]

TEST [[
---@class A
local m

---@type integer
m.x = 1

<!m.x!> = true
]]

TEST [[
---@class A
local mt

---@type integer
mt.x = 1

function mt:init()
    <!self.x!> = true
end
]]

TEST [[
---@class A
---@field x integer

---@type A
local t = {
    <!x!> = true
}
]]

TEST [[
---@type boolean[]
local t = {}

t[5] = nil
]]
config.remove(nil, 'Lua.diagnostics.disable', 'unused-local')
config.remove(nil, 'Lua.diagnostics.disable', 'undefined-global')
