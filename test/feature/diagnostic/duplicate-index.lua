TEST_DIAGNOSTIC [[
local _ = {
    <?a?> = 1,
    <?a?> = 2,
}
]] { 'duplicate-index', 'duplicate-index' }

TEST_DIAGNOSTIC [[
local _ = {
    a = 1,
    b = 2,
}
]] {}

TEST_DIAGNOSTIC [[
local _ = {
    [1] = 'a',
    [1] = 'b',
}
]] { 'duplicate-index', 'duplicate-index' }

TEST_DIAGNOSTIC [[
local _ = {
    [1] = 'a',
    'b',
}
]] { 'duplicate-index', 'duplicate-index' }

TEST_DIAGNOSTIC [[
local _ = {
    'a',
    'b',
}
]] {}