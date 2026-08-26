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
            assert(#actual == #codes, ('expected %d diagnostics, actual %d\nexpected codes:\n%s\nactual codes:\n%s')
                :format(#codes, #actual, table.concat(codes, '\n'), table.concat(actual, '\n')))
            for i, code in ipairs(codes) do
                assert(actual[i] == code, ('expected diag[%d] code `%s`, actual `%s`'):format(i, code, tostring(actual[i])))
            end
        end
        if #marks > 0 then
            assert(#results == #marks, ('expected %d position marks, actual %d diagnostics'):format(#marks, #results))
            table.sort(marks, function (a, b)
                if a[1] == b[1] then
                    return a[2] < b[2]
                end
                return a[1] < b[1]
            end)
            for i, diag in ipairs(results) do
                local mark = marks[i]
                assert(diag.start == mark[1] and diag.finish == mark[2],
                    ('diag[%d] `%s` range mismatch: expected [%d, %d], actual [%d, %d]')
                        :format(i, diag.code, mark[1], mark[2], diag.start, diag.finish))
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
test.require 'test.feature.diagnostic.dedupe'
test.require 'test.feature.diagnostic.semantic'
