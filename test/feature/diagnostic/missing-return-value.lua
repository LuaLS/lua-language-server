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