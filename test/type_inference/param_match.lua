
TEST 'boolean' [[
---@overload fun(x: number, y: number):string
---@overload fun(x: number):number
---@return boolean
local function f() end

local <?n1?> = f()
local n2 = f(0)
local n3 = f(0, 0)
]]

TEST 'number' [[
---@overload fun(x: number, y: number):string
---@overload fun(x: number):number
---@return boolean
local function f() end

local n1 = f()
local <?n2?> = f(0)
local n3 = f(0, 0)
]]

TEST 'string' [[
---@overload fun(x: number, y: number):string
---@overload fun(x: number):number
---@return boolean
local function f() end

local n1 = f()
local n2 = f(0)
local <?n3?> = f(0, 0)
]]

TEST 'boolean' [[
---@overload fun():boolean
---@param x integer
---@return number
function f(x)
end

local <?x?> = f()
]]

TEST 'number' [[
---@overload fun():boolean
---@param x integer
---@return number
function f(x)
end

local <?x?> = f(1)
]]

TEST 'boolean' [[
---@overload fun():boolean
---@param x integer
---@return number
function f(x)
end

function r0()
    return
end

local <?x?> = f(r0())
]]

TEST 'number' [[
---@overload fun():boolean
---@param x integer
---@return number
function f(x)
end

function r1()
    return 1
end

local <?x?> = f(r1())
]]

TEST 'boolean' [[
---@overload fun():boolean
---@param x integer
---@return number
function f(x)
end

---@type fun()
local r0

local <?x?> = f(r0())
]]

TEST 'number' [[
---@overload fun():boolean
---@param x integer
---@return number
function f(x)
end

---@type fun():integer
local r1

local <?x?> = f(r1())
]]

TEST '1' [[
---@overload fun(a: 'x'): 1
---@overload fun(a: 'y'): 2
local function f(...) end

local <?r?> = f('x')
]]

TEST '2' [[
---@overload fun(a: 'x'): 1
---@overload fun(a: 'y'): 2
local function f(...) end

local <?r?> = f('y')
]]

TEST '1' [[
---@overload fun(a: boolean): 1
---@overload fun(a: number): 2
local function f(...) end

local <?r?> = f(true)
]]

TEST '2' [[
---@overload fun(a: boolean): 1
---@overload fun(a: number): 2
local function f(...) end

local <?r?> = f(10)
]]

TEST '1' [[
---@overload fun(a: string): 1
---@overload fun(a: 'y'): 2
local function f(...) end

local <?r?> = f('x')
]]

TEST '2' [[
---@overload fun(a: string): 1
---@overload fun(a: 'y'): 2
local function f(...) end

local <?r?> = f('y')
]]

TEST '1' [[
---@overload fun(a: string): 1
---@overload fun(a: 'y'): 2
local function f(...) end

local v = 'x'
local <?r?> = f(v)
]]

TEST '2' [[
---@overload fun(a: string): 1
---@overload fun(a: 'y'): 2
local function f(...) end

local v = 'y'
local <?r?> = f(v)
]]

TEST 'number' [[
---@overload fun(a: 1, c: fun(x: number))
---@overload fun(a: 2, c: fun(x: string))
local function f(...) end

f(1, function (<?a?>) end)
]]

TEST 'string' [[
---@overload fun(a: 1, c: fun(x: number))
---@overload fun(a: 2, c: fun(x: string))
local function f(...) end

f(2, function (<?a?>) end)
]]

TEST 'any' [[
---@overload fun(a: 1)
---@overload fun(a: 2)
local function f(...) end

f(1, function (<?a?>) end)
]]
