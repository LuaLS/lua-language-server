TEST_DIAGNOSTIC [[
local function f()
    return <?x?>
end
f()
]] { 'undefined-global' }

TEST_DIAGNOSTIC [[
---@type number
X = 1
local function f()
    return X
end
f()
]] {}

TEST_DIAGNOSTIC [[
X = 1
local function f()
    return X
end
f()
]] {}

TEST_DIAGNOSTIC [[
local function f()
    print(1)
end
f()
]] {}

TEST_DIAGNOSTIC [[
local function f()
    return <?x?>
end
f()
]] { 'undefined-global', '-undefined-field' }