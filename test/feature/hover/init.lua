---@diagnostic disable: await-in-sync

---@param script string
---@return fun(expects: string|nil|fun(value: string?))
function TEST_HOVER(script)
    local value = TEST_FRAME(script, function (catched)
        local result = ls.feature.hover(test.fileUri, catched['?'][1][1])
        return result and result.value or nil
    end)

    return function (expects)
        if type(expects) == 'function' then
            expects(value)
            return
        end
        if expects == nil then
            assert(value == nil)
            return
        end
        assert(value == expects)
    end
end

test.require 'test.feature.hover.basic'
