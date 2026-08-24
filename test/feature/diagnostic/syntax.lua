TEST_DIAGNOSTIC [[
local _ = 1
]] {}

TEST_DIAGNOSTIC [[
<?break?>
]] (function (results)
    assert(#results == 1, 'expected 1 diagnostic, actual ' .. #results)
    local diag = results[1]
    assert(diag.code == 'break-outside', diag.code)
    assert(diag.level == ls.spec.DiagnosticSeverity.Error, tostring(diag.level))
    assert(diag.message == '<break> not inside a loop.', diag.message)
    assert(diag.data == 'syntax', tostring(diag.data))
end)

TEST_DIAGNOSTIC [[
local _ =<??>
]] { 'miss-exp' }

TEST_DIAGNOSTIC [[
if true then
    x = 1
]] (function (results)
    assert(#results >= 1, 'expected at least one diagnostic for missing end')
    local found = false
    for _, diag in ipairs(results) do
        if diag.code == 'miss-end' then
            found = true
            assert(diag.message == 'Miss corresponding `end`.', diag.message)
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
]] (function (results)
    assert(#results == 1, 'expected 1 diagnostic, actual ' .. #results)
    assert(results[1].code == 'err-esc', results[1].code)
    assert(results[1].message == 'Invalid escape sequence.', results[1].message)
end)

TEST_DIAGNOSTIC [[
local function f()
    return 1
end
]] {}
