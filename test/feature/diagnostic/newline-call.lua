TEST_DIAGNOSTIC [[
local function f(x)
    return {}
end
local _ = f
(1).y
]] { 'newline-call' }

TEST_DIAGNOSTIC [[
local function f(x)
    return {}
end
local _ = f(1).y
]] {}

TEST_DIAGNOSTIC [[
local function f(x)
    return {}
end
local _ = f
(1)
]] {}
