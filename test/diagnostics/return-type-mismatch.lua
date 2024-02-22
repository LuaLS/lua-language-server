TEST [[
---@return number
function F()
    return <!true!>
end
]]

TEST [[
---@return number?
function F()
    return 1
end
]]

TEST [[
---@return number?
function F()
    return nil
end
]]

TEST [[
---@return number, number
local function f()
    return 1, 1
end

---@return number, boolean
function F()
    return <!f()!>
end
]]

TEST [[
---@return boolean, number
local function f()
    return true, 1
end

---@return number, boolean
function F()
    return <!f()!>
end
]]

TEST [[
---@return boolean, number?
local function f()
    return true, 1
end

---@return number, boolean
function F()
    return 1, f()
end
]]

TEST [[
---@return number, number?
local function f()
    return 1, 1
end

---@return number, boolean, number
function F()
    return 1, <!f()!>
end
]]

TEST [[
---@class A
---@field x number?

---@return number
function F()
    ---@type A
    local t
    return t.x
end
]]

TEST [[
---@class A
---@field x number?
local t = {}

---@return number
function F()
    return t.x
end
]]

TEST [[
---@param ... number
local function f(...)
end

f(nil)
]]

TEST [[
---@return number
function F()
    local n = 0
    if true then
        n = 1
    end
    return n
end
]]

TEST [[
---@param x boolean
---@return number
---@overload fun(): boolean
local function f(x)
    if x then
        return 1
    else
        return false
    end
end
]]

TEST [[
---@param x boolean
---@return number
---@overload fun()
local function f(x)
    if x then
        return 1
    else
        return
    end
end
]]

TEST [[
---@param x boolean
---@return number
---@overload fun()
local function f(x)
    if x then
        return 1
    end
end
]]

TEST [[
---@param x boolean
---@return number
---@overload fun(): boolean, boolean
local function f(x)
    if x then
        return 1
    else
        return false, false
    end
end
]]

TEST [[
---@type fun():number
local function f()
    return <!true!>
end
]]
