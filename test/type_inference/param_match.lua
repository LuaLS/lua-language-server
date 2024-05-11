
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
