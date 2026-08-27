print('[feature.diagnostic.newfield-call] 测试中...')

TEST_DIAGNOSTIC [[
local Foo = 1
local Bar = 1
local _ = {
    Foo
    (Bar)
}
]] { 'newfield-call' }

TEST_DIAGNOSTIC [[
local Foo = 1
local Bar = 1
local _ = {
    Foo(Bar)
}
]] {}

TEST_DIAGNOSTIC [[
local Foo = 1
local Bar = 1
local _ = {
    Foo,
    (Bar)
}
]] {}

print('[feature.diagnostic.newfield-call] 测试完毕')