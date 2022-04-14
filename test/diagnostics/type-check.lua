local config = require 'config'

config.get(nil, 'Lua.diagnostics.neededFileStatus')['unused-local'] = 'None'
TEST [[
---@param table     table
---@param metatable table
---@return table
function Setmetatable(table, metatable) end

Setmetatable(<!1!>, {})
]]

TEST [[
---@param table     table
---@param metatable table
---@return table
function Setmetatable(table, metatable) end

Setmetatable(<!'name'!>, {})

]]

TEST [[
---@param table     table
---@param metatable table
---@return table
function Setmetatable(table, metatable) end

---@type table
local name
---@type function
local mt
---err
Setmetatable(name, <!mt!>)
]]

TEST [[
---@param p1 string
---@param p2 number
---@return table
local function func1(p1, p2) end

---@type string
local s
---@type table
local t
---err
func1(s, <!t!>)
]]

TEST [[
---@class bird
---@field wing string

---@class eagle
---@field family bird

---@class chicken
---@field family bird

---@param bd eagle
local function fly(bd) end

---@type chicken
local h
fly(<!h!>)
]]

TEST [[
---@overload fun(x: number, y: number)
---@param x boolean
---@param y boolean
local function f(x, y) end

f(true, true) -- OK
f(0, 0) -- OK

]]

TEST [[
---@class bird
local m = {}
setmetatable(m, {}) -- OK
]]

TEST [[
---@class childString: string
local s
---@param name string
local function f(name) end
f(s)
]]

TEST [[
---@class childString: string

---@type string
local s
---@param name childString
local function f(name) end
f(<!s!>)
]]

TEST [[
---@alias searchmode '"ref"'|'"def"'|'"field"'|'"allref"'|'"alldef"'|'"allfield"'

---@param mode   searchmode
local function searchRefs(mode)end
searchRefs('ref')
]]

TEST [[
---@class markdown
local mt = {}
---@param language string
---@param text string|markdown
function mt:add(language, text)
    if not text then
        return
    end
end
---@type markdown
local desc

desc:add('md', 'hover')
]]

---可选参数和枚举
TEST [[
---@param str string
---@param mode? '"left"'|'"right"'
---@return string
local function trim(str, mode)
    if mode == "left" then
        print(1)
    end
end
trim('str', 'left')
trim('str', nil)
]]

config.get(nil, 'Lua.diagnostics.neededFileStatus')['unused-local'] = 'Any'

---不完整的函数参数定义，会跳过检查
TEST [[
---@param mode string
local function status(source, field, mode)
    print(source, field, mode)
end
status(1, 2, 'name')
]]


TEST [[
---@alias range {start: number, end: number}
---@param uri string
---@param range range
local function location(uri, range)
    print(uri, range)
end
---@type range
local val = {}
location('uri', val)
]]
