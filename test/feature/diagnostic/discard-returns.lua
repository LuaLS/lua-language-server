print('[feature.diagnostic.discard-returns] 测试中...')

TEST_DIAGNOSTIC [[
---@nodiscard
local function f()
    return 1
end

<?f()?>
]] { 'discard-returns' }

TEST_DIAGNOSTIC [[
---@nodiscard
local function f()
    return 1
end

X = f()
]] { '-discard-returns' }

TEST_DIAGNOSTIC [[
---@nodiscard
local function f()
    return 1
end

local x = f()
]] { '-discard-returns' }

TEST_DIAGNOSTIC [[
---@nodiscard
local function f()
    return 1
end

return f()
]] { '-discard-returns' }

TEST_DIAGNOSTIC [[
---@nodiscard
local function f()
    return 1
end

do
    <?f()?>
end
]] { 'discard-returns' }

TEST_DIAGNOSTIC [[
---@nodiscard
local function f()
    return 1
end

if 1 == 1 then
    <?f()?>
end
]] { 'discard-returns' }

TEST_DIAGNOSTIC [[
---@nodiscard
local function f()
    return 1
end

if f() then
end
]] { '-discard-returns' }

TEST_DIAGNOSTIC [[
---@nodiscard
local function f()
    return 1
end

while f() do
end
]] { '-discard-returns' }

TEST_DIAGNOSTIC [[
---@nodiscard
local function f()
    return 1
end

repeat
until f()
]] { '-discard-returns' }

TEST_DIAGNOSTIC [[
---@nodiscard
local function f()
    return 1
end

for i = 1, f() do
end
]] { '-discard-returns' }

TEST_DIAGNOSTIC [[
---@nodiscard
local function f()
    return 1
end

local function g(cb)
    cb()
end

g(function ()
    <?f()?>
end)
]] { 'discard-returns' }

TEST_DIAGNOSTIC [[
local function f()
    return 1
end

f()
]] { '-discard-returns' }

print('[feature.diagnostic.discard-returns] 测试完毕')