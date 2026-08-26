TEST_DIAGNOSTIC [[
local _ = 1
]] {}

TEST_DIAGNOSTIC [[
<?break?>
]] { 'break-outside' } (function (results)
    assert(#results == 1, 'expected 1 diagnostic, actual ' .. #results)
    local diag = results[1]
    assert(diag.code == 'break-outside', diag.code)
    assert(diag.level == ls.spec.DiagnosticSeverity.Error, tostring(diag.level))
    assert(diag.data == 'syntax', tostring(diag.data))
end)

TEST_DIAGNOSTIC [[
local _ =<??>
]] { 'miss-exp' }

TEST_DIAGNOSTIC [[
if true then
    x = 1
]] (nil) (function (results)
    assert(#results >= 1, 'expected at least one diagnostic for missing end')
    local found = false
    for _, diag in ipairs(results) do
        if diag.code == 'miss-end' then
            found = true
        end
    end
    assert(found, 'miss-end not found')
end)

TEST_DIAGNOSTIC [[
local x = 1
x = 2
return x
]] {}

TEST_DIAGNOSTIC [[
local _ = "a\qb"
]] { 'err-esc' } (function (results)
    assert(#results == 1, 'expected 1 diagnostic, actual ' .. #results)
    assert(results[1].code == 'err-esc', results[1].code)
end)

TEST_DIAGNOSTIC [[
local function _()
    return 1
end
]] {}
