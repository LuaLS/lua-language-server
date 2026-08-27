print('[feature.diagnostic.converter] 测试中...')

local converter = require 'feature.diagnostic.converter'

TEST_FRAME([[
break
]], function ()
    local document = ls.scope.findDocument(test.fileUri)
    assert(document)
    ---@diagnostic disable-next-line: await-in-sync
    local diagnostics = ls.feature.diagnostic(test.fileUri)
    local items = converter.convert(document, diagnostics, 'utf-8')

    assert(#items == 1, 'expected 1 item, actual ' .. #items)
    local item = items[1]
    assert(item.code == 'break-outside', tostring(item.code))
    assert(item.severity == ls.spec.DiagnosticSeverity.Error, tostring(item.severity))
    assert(item.source == 'Lua', tostring(item.source))
    assert(item.range.start.line == 0, tostring(item.range.start.line))
    assert(item.range.start.character == 0, tostring(item.range.start.character))
    assert(item.range['end'].line == 0, tostring(item.range['end'].line))
    assert(item.range['end'].character == 5, tostring(item.range['end'].character))
end)

TEST_FRAME([[
local x = 1
if true then
    x = 2
]], function ()
    local document = ls.scope.findDocument(test.fileUri)
    assert(document)
    ---@diagnostic disable-next-line: await-in-sync
    local diagnostics = ls.feature.diagnostic(test.fileUri)
    local items = converter.convert(document, diagnostics, 'utf-8')

    local found
    for _, item in ipairs(items) do
        if item.code == 'miss-end' then
            found = item
            break
        end
    end
    assert(found, 'miss-end not found')
    assert(found.relatedInformation, 'miss-end should have relatedInformation')
    assert(#found.relatedInformation == 1, 'expected 1 related, actual ' .. #found.relatedInformation)
    local rel = found.relatedInformation[1]
    assert(rel.location.uri == test.fileUri, tostring(rel.location.uri))
end)

print('[feature.diagnostic.converter] 测试完毕')