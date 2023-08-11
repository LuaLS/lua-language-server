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
