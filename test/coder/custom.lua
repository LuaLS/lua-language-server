local rt = test.scope.rt

do
    TEST_INDEX [=[
--[[@@@
alias 'Test'
    : param('T')
    : onValue(function (c)
        return c.array(c.args[1])
    end)
]]
    ]=]

    local v = rt.call('Test', { rt.value(10) })

    assert(v:view() == '10[]')
end

do
    TEST_INDEX [=[
--[[@@@
alias 'Test'
    : param('T')
    : onValue(function (c)
        return c.array(c.args[1])
    end)
]]
    ]=]

    local v = rt.call('Test', { rt.value(10) | rt.value(20) })

    assert(v:view() == '(10 | 20)[]')
end

do
    TEST_INDEX [=[
--[[@@@
alias 'Test'
    : param('T')
    : onValue(function (c)
        return c.args[1]:every(function (node)
            return c.array(node)
        end)
    end)
]]
    ]=]

    local v = rt.call('Test', { rt.value(10) | rt.value(20) })

    assert(v:view() == '10[] | 20[]')
end
