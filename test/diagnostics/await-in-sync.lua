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
---@param cb fun()
local function f(cb)
    return cb
end

---@async
local function af()
    return nil
end

f(<!af!>)
]]

TEST [[
---@param cb async fun()
local function f(cb)
    return cb
end

---@async
local function af()
    return nil
end

f(af)
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
local function f(cb)
    cb()
end

---@async
local function af()
    f(function () ---@async
        return nil
    end)
end

return af
]]

TEST [[
local _ = type(function () ---@async
    return nil
end)
]]
