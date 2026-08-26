TEST_DIAGNOSTIC [[
---@return number
local function f()
    return <?'str'?>
end
f()
]] { 'return-type-mismatch' }

TEST_DIAGNOSTIC [[
---@return number
local function f()
    return 1
end
f()
]] { '-return-type-mismatch' }

TEST_DIAGNOSTIC [[
---@return number
---@return string
local function f()
    return 1, <?{}?>
end
f()
]] { 'return-type-mismatch' }
