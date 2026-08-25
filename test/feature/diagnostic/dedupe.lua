local function assertNoDuplicatePosition(results)
    local seen = {}
    for _, diag in ipairs(results) do
        local key = diag.start .. ':' .. diag.finish
        assert(not seen[key], 'duplicate position: ' .. key)
        seen[key] = true
    end
end

TEST_DIAGNOSTIC [[
local x = 1
]] { 'unused-local' } (function (results)
    assertNoDuplicatePosition(results)
    assert(#results == 1, 'expected 1 diagnostic, actual ' .. #results)
end)

TEST_DIAGNOSTIC [[
if true then
    x = 1
]] (nil) (function (results)
    assertNoDuplicatePosition(results)
end)

TEST_DIAGNOSTIC [[
<?while true do
end?>
]] { 'empty-block' } (function (results)
    assertNoDuplicatePosition(results)
    assert(#results == 1, 'expected 1 diagnostic, actual ' .. #results)
    assert(results[1].code == 'empty-block', results[1].code)
end)
