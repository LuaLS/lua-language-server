TEST_DIAGNOSTIC [[
local _ = {
    foo
    (bar)
}
]] { 'newfield-call' }

TEST_DIAGNOSTIC [[
local _ = {
    foo(bar)
}
]] {}

TEST_DIAGNOSTIC [[
local _ = {
    foo,
    (bar)
}
]] {}
