TEST_DIAGNOSTIC [[
---@return number
local function f()
    <?return?>
end
f()
]] { 'missing-return-value' }

TEST_DIAGNOSTIC [[
---@return number, number
local function f()
    <?return?> 1
end
f()
]] { 'missing-return-value' }

TEST_DIAGNOSTIC [[
---@return number?
local function f()
    return
end
f()
]] { '-missing-return-value' }

TEST_DIAGNOSTIC [[
---@return number
local function f()
    return 1
end
f()
]] { '-missing-return-value' }

TEST_DIAGNOSTIC [[
---@return ...
local function f()
    return
end
f()
]] { '-missing-return-value' }

TEST_DIAGNOSTIC [[
---@return boolean ok, string[] outputPaths, (string|nil)[]? errs
local function f()
    return true, {}
end
f()
]] { '-missing-return-value' }

TEST_DIAGNOSTIC [[
---@return boolean ok, string[] outputPaths, string[]? errs
local function f()
    return true, {}
end
f()
]] { '-missing-return-value' }

TEST_DIAGNOSTIC [[
---@return boolean ok, string[]? outputPaths, string[] errs
local function f()
    return true
end
f()
]] { 'missing-return-value' }

TEST_DIAGNOSTIC [[
---@return number
local function one() end

---@return number, number
local function f()
    return one()
end
f()
]] { 'missing-return-value' }

TEST_DIAGNOSTIC [[
---@return number, number
local function two() end

---@return number, number
local function f()
    return two()
end
f()
]] { '-missing-return-value' }

TEST_DIAGNOSTIC [[
---@return ... any
local function spread() end

local function wait(cb)
    return spread()
end

---@return string action
---@return integer index
local function f()
    return wait(function () end)
end
f()
]] { '-missing-return-value' }