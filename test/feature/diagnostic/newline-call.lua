print('[feature.diagnostic.newline-call] 测试中...')

TEST_DIAGNOSTIC [[
local function f(x)
    return { y = 1 }
end
local _ = f
({ y = 1 }).y
]] { 'newline-call' }

TEST_DIAGNOSTIC [[
local function f(x)
    return { y = 1 }
end
local _ = f({ y = 1 }).y
]] {}

TEST_DIAGNOSTIC [[
local function f(x)
    return { y = 1 }
end
local _ = f
({ y = 1 })
]] {}

print('[feature.diagnostic.newline-call] 测试完毕')