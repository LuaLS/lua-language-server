---@param script string
---@return fun(items: table[])
function TEST_COMPLETION(script)
    local results = TEST_FRAME(script, function (catched)
        return ls.feature.completion(test.fileUri, catched['?'][1][1])
    end)

    return function (expects)
        assert(Match(results, expects))
    end
end
