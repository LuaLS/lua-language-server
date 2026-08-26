TEST_DIAGNOSTIC [[
---@deprecated use bar instead
local function foo()
end

local function f()
    <?foo?>()
end
f()
]] { 'deprecated' }

TEST_DIAGNOSTIC [[
---@deprecated
local function foo()
end

foo()
]] { 'deprecated' }

TEST_DIAGNOSTIC [[
local function foo()
end

foo()
]] { '-deprecated' }

TEST_DIAGNOSTIC [[
---@deprecated
local x = 1
local function f()
    print(<?x?>)
end
f()
]] { 'deprecated' }

TEST_DIAGNOSTIC [[
---@deprecated
X = 1
local function f()
    print(<?X?>)
end
f()
]] { 'deprecated' }
