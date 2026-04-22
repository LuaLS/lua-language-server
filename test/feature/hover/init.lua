---@diagnostic disable: await-in-sync

---@class Test.Hover.Result
---@field value string?
---@field items Feature.Hover.Item[]

---@param script string
---@return fun(expects: string|string[]|nil|fun(result: Test.Hover.Result))
function TEST_HOVER(script)
    script = script:gsub('\n$', '')
    ---@type Test.Hover.Result
    local result = TEST_FRAME(script, function (catched)
        local hover = ls.feature.hover(test.fileUri, catched['?'][1][1])
        if not hover then
            return {
                value = nil,
                items = {},
            }
        end
        return {
            value = hover.value,
            items = hover.items or {},
        }
    end) or {
        value = nil,
        items = {},
    }

    return function (expects)
        if type(expects) == 'function' then
            expects(result)
            return
        end
        if expects == nil then
            assert(result.value == nil, 'expected nil hover value')
            return
        end
        local labels = ls.util.map(result.items, function (item)
            return item.label
        end)
        if type(expects) == 'string' then
            expects = expects:gsub('^[\r\n]*(.-)[\r\n]*$', '%1')
            assert(labels[1] == expects, ('expected first label:\n%s\nactual:\n%s'):format(expects, tostring(labels[1])))
            return
        end
        assert(#labels == #expects, ('expected %d labels, actual %d'):format(#expects, #labels))
        for i, label in ipairs(expects) do
            label = label:gsub('^[\r\n]*(.-)[\r\n]*$', '%1')
            assert(labels[i] == label, ('expected label[%d]:\n%s\nactual:\n%s'):format(i, label, tostring(labels[i])))
        end
    end
end

test.require 'test.feature.hover.basic'
