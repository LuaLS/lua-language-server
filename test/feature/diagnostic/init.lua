local metaBuilder = require 'scope.meta-builder'
local metaUri = metaBuilder.compile('Lua 5.4', 'auto', 'utf-8')
test.metaUris = {}
do
    local files = ls.afs.getChilds(metaUri)
    if files then
        for _, uri in ipairs(files) do
            if ls.util.stringEndWith(uri, '.lua') then
                local text = ls.afs.read(uri)
                if text then
                    ls.file.setServerText(uri, text)
                    test.metaUris[#test.metaUris+1] = uri
                end
            end
        end
    end
    table.sort(test.metaUris)
end

---@param script string
---@return fun(codes: string[]?): fun(callback: fun(results: Feature.Diagnostic[])?)
function TEST_DIAGNOSTIC(script)
    script = script:gsub('\n$', '')
    local results, catched = TEST_FRAME(script, function ()
        local file = ls.file.get(test.fileUri)
        if file then
            ls.file.setClientText(test.fileUri, file.serverText, file.clientVersion + 1)
        end
        ---@diagnostic disable-next-line: await-in-sync
        return ls.feature.diagnostic(test.fileUri)
    end)
    results = results or {}
    local marks = (catched and catched['?']) or {}

    return function (codes)
        if codes ~= nil then
            local actual = {}
            for i, diag in ipairs(results) do
                actual[i] = diag.code
            end
            if #codes == 0 then
                assert(#actual == 0, ('expected 0 diagnostics, actual %d\nactual codes:\n%s')
                    :format(#actual, table.concat(actual, '\n')))
            else
                for _, code in ipairs(codes) do
                    if code:sub(1, 1) == '-' then
                        local name = code:sub(2)
                        for _, a in ipairs(actual) do
                            assert(a ~= name, ('unexpected diagnostic `%s`\nactual codes:\n%s')
                                :format(name, table.concat(actual, '\n')))
                        end
                    else
                        local found = false
                        for _, a in ipairs(actual) do
                            if a == code then
                                found = true
                                break
                            end
                        end
                        assert(found, ('expected diagnostic `%s`, not found\nactual codes:\n%s')
                            :format(code, table.concat(actual, '\n')))
                    end
                end
            end
        end
        if #marks > 0 then
            for _, mark in ipairs(marks) do
                local found = false
                for _, diag in ipairs(results) do
                    if diag.start == mark[1] and diag.finish == mark[2] then
                        found = true
                        break
                    end
                end
                assert(found, ('no diagnostic at range [%d, %d]'):format(mark[1], mark[2]))
            end
        end
        return function (callback)
            if callback then
                callback(results)
            end
        end
    end
end

test.require 'test.feature.diagnostic.syntax'
test.require 'test.feature.diagnostic.config'
test.require 'test.feature.diagnostic.disable'
test.require 'test.feature.diagnostic.converter'
test.require 'test.feature.diagnostic.push'
test.require 'test.feature.diagnostic.pull'
test.require 'test.feature.diagnostic.empty-block'
test.require 'test.feature.diagnostic.unused-local'
test.require 'test.feature.diagnostic.redundant-return'
test.require 'test.feature.diagnostic.code-after-break'
test.require 'test.feature.diagnostic.duplicate-index'
test.require 'test.feature.diagnostic.duplicate-doc-param'
test.require 'test.feature.diagnostic.unbalanced-assignments'
test.require 'test.feature.diagnostic.unknown-diag-code'
test.require 'test.feature.diagnostic.lowercase-global'
test.require 'test.feature.diagnostic.redundant-value'
test.require 'test.feature.diagnostic.count-down-loop'
test.require 'test.feature.diagnostic.undefined-doc-param'
test.require 'test.feature.diagnostic.close-non-object'
test.require 'test.feature.diagnostic.newline-call'
test.require 'test.feature.diagnostic.newfield-call'
test.require 'test.feature.diagnostic.undefined-field'
test.require 'test.feature.diagnostic.undefined-global'
test.require 'test.feature.diagnostic.deprecated'
test.require 'test.feature.diagnostic.need-check-nil'
test.require 'test.feature.diagnostic.dedupe'
test.require 'test.feature.diagnostic.semantic'
