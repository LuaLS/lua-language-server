TEST [[
function F()
    <!coroutine.yield!>()
end
]]

TEST [[
---@async
function F()
    coroutine.yield()
end
]]

TEST [[
---@type async fun()
local f

function F()
    <!f!>()
end
]]

TEST [[
---@type async fun()
local f

---@async
function F()
    f()
end
]]

TEST [[
local function f(cb)
    cb()
end

return function()
    <!f>(function () ---@async
        return nil
    end)
end
]]

TEST [[
local function f(cb)
    pcall(cb)
end

return function()
    <!f!>(function () ---@async
        return nil
    end)
end
]]

TEST [[
---@param c any
local function f(c)
    return c
end

return function ()
    f(function () ---@async
        return nil
    end)
end
]]

TEST [[
---@param ... any
local function f(...)
    return ...
end

return function ()
    f(function () ---@async
        return nil
    end)
end
]]

TEST [[
---@vararg any
local function f(...)
    return ...
end

return function ()
    f(function () ---@async
        return nil
    end)
end
]]

TEST [[
local function f(...)
    return ...
end

return function ()
    f(function () ---@async
        return nil
    end)
end
]]

TEST [[
local function f(...)
    return ...
end

return function ()
    f(function () ---@async
        return nil
    end)
end
]]

TEST [[
local function f(cb)
    cb()
end

local function af()
    <!f!>(function () ---@async
        return nil
    end)
end

return af
]]

TEST [[
---@alias AsyncGenericFunc<T> async fun(): T

---@type AsyncGenericFunc<string>
local f

function F()
    <!f!>()
end
]]

TEST [[
---@alias AsyncGenericFunc<T> async fun(x: T)

---@type AsyncGenericFunc<integer>
local f

---@async
function F()
    f(1)
end
]]

TEST [[
---@alias AsyncGenericFunc<T> async fun(): T

---@class AsyncGenericHolder
---@field run AsyncGenericFunc<string>

---@type AsyncGenericHolder
local holder

function F()
    <!holder.run!>()
end
]]

TEST [[
---@alias AsyncGenericFunc<T> async fun(): T

---@type AsyncGenericFunc<string>
local function f()
    return 'x'
end

function F()
    <!f!>()
end
]]
