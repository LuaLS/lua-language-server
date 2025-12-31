local rt = test.scope.rt

do
    rt:reset()
    local x = rt.alias('X')
        : setCustomValue(function (self)
            return rt.value 'custom X'
        end)

    assert(rt.type('X'):view() == 'X')
    assert(rt.type('X').value:view() == '"custom X"')
end

do
    rt:reset()
    local T = rt.generic('T')
    local o = rt.alias('Options', { T })
        : setCustomValue(function (self, args)
            local v = args[1]
            if #v.keys == 0 then
                return v
            end
            local t = rt.table()
            for _, key in ipairs(v.keys) do
                t = t:addField(rt.field(key, v:get(key), true))
            end

            return t
        end)

    local t1 = rt.table {
        [ 'x' ] = rt.value '10',
        [ 'y' ] = rt.value '20',
    }

    assert(t1:view() == [[
{
    x: "10",
    y: "20",
}]])

    local t2 = rt.call('Options', { t1 })

    assert(t2:view() == [[
{
    x?: "10" | nil,
    y?: "20" | nil,
}]])
end

do
    rt:reset()
    local playground = ls.custom.playground(test.scope)
    do
        local _ENV = playground.env

        _ENV.alias('Options')
            : param('T')
            : onValue(function (c)
                local v = c.args[1]
                if #v.keys == 0 then
                    return v
                end
                local t = c.table()
                for _, key in ipairs(v.keys) do
                    t = t:addField(c.field(key, v:get(key), true))
                end

                return t
            end)
    end

    local t1 = rt.table {
        [ 'x' ] = rt.value '10',
        [ 'y' ] = rt.value '20',
    }

    assert(t1:view() == [[
{
    x: "10",
    y: "20",
}]])

    local t2 = rt.call('Options', { t1 })

    assert(t2:view() == [[
{
    x?: "10" | nil,
    y?: "20" | nil,
}]])
end

do
    rt:reset()
    local playground = ls.custom.playground(test.scope)
    do
        local _ENV = playground.env

        _ENV.alias('Options')
            : param('T')
            : onValue(function (c)
                local v = c.args[1]
                if #v.keys == 0 then
                    return v
                end
                local t = c.table()
                for _, key in ipairs(v.keys) do
                    t = t:addField(c.field(key, v:get(key), true))
                end

                return t
            end)
    end

    local c = rt.class('XXX')
        : addField(rt.field('x', rt.value '10'))
        : addField(rt.field('y', rt.value '20'))

    assert(rt.type 'XXX'.value:view() == [[
{
    x: "10",
    y: "20",
}]])

    local t2 = rt.call('Options', { rt.type 'XXX' })

    assert(t2:view() == [[
{
    x?: "10" | nil,
    y?: "20" | nil,
}]])

    c:addField(rt.field('z', rt.value '30'))

    assert(rt.type 'XXX'.value:view() == [[
{
    x: "10",
    y: "20",
    z: "30",
}]])
    assert(t2.value:view() == [[
{
    x?: "10" | nil,
    y?: "20" | nil,
    z?: "30" | nil,
}]])
end

do
    rt:reset()
    local playground = ls.custom.playground(test.scope)
    do
        local _ENV = playground.env

        _ENV.alias('Test')
            : onValue(function (c)
                local res = c.type('XXX'):get('x')
                return res
            end)
    end

    local t = rt.type 'Test'

    assert(t:view() == 'Test')
    assert(t.value:view() == 'never')

    do
        local _ <close> = rt.alias('XXX', nil, rt.table {
            x = rt.value(123),
        })
        assert(t.value:view() == '123')
    end

    do
        local _ <close> = rt.alias('XXX', nil, rt.table {
            x = rt.value(345),
        })
        assert(t.value:view() == '345')
    end

    assert(t.value:view() == 'never')
end

do
    rt:reset()

    assert(rt.type('Test'):view() == 'Test')
    assert(rt.type('Test').value:view() == 'Test')

    local playground = ls.custom.playground(test.scope)
    do
        local _ENV = playground.env

        _ENV.alias('Test')
            : onValue(function (c)
                return c.value(1)
            end)
    end

    assert(rt.type('Test').value:view() == '1')

    playground:dispose()

    assert(rt.type('Test').value:view() == 'Test')
end
