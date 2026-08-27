print('[feature.diagnostic.redundant-return] 测试中...')

TEST_DIAGNOSTIC [[
local function _()
    <?return?>
end
]] { 'redundant-return' }

TEST_DIAGNOSTIC [[
local function _()
    return 1
end
]] {}

TEST_DIAGNOSTIC [[
local function _()
end
]] {}

TEST_DIAGNOSTIC [[
local function _()
    if true then
        return
    end
end
]] {}

TEST_DIAGNOSTIC [[
local function _()
    if true then
        return 1
    end
end
]] {}

print('[feature.diagnostic.redundant-return] 测试完毕')