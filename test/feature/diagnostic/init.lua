---@param script string
---@return fun(expects: string[]|fun(results: Feature.Diagnostic[]))
function TEST_DIAGNOSTIC(script)
    script = script:gsub('\n$', '')
    local results, catched = TEST_FRAME(script, function ()
        local file = ls.file.get(test.fileUri)
        if file then
            ls.file.setClientText(test.fileUri, file.serverText, file.clientVersion + 1)
        end
        return ls.feature.diagnostic(test.fileUri)
    end)
    results = results or {}
    local marks = (catched and catched['?']) or {}

    return function (expects)
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
        if type(expects) == 'function' then
            expects(results)
            return
        end
        local codes = {}
        for i, diag in ipairs(results) do
            codes[i] = diag.code
        end
        assert(#codes == #expects, ('expected %d diagnostics, actual %d\nexpected codes:\n%s\nactual codes:\n%s')
            :format(#expects, #codes, table.concat(expects, '\n'), table.concat(codes, '\n')))
        for i, code in ipairs(expects) do
            assert(codes[i] == code, ('expected diag[%d] code `%s`, actual `%s`'):format(i, code, tostring(codes[i])))
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
