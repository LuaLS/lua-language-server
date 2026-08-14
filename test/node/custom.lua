local rt = test.scope.rt

do
    rt:reset()
    local x = rt.alias('X')
        : setCustomValue(function (self)
            return rt.value 'custom X'
        end)

    lt.assertEquals(rt.type('X'):view(), 'X')
    lt.assertEquals(rt.type('X').value:view(), '"custom X"')
end

do
    rt:reset()
    local T = rt.generic('T')
    local o = rt.alias('Partial', { T })
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

    lt.assertEquals(t1:view(), [[
{
    x: "10",
    y: "20",
}]])

    local t2 = rt.call('Partial', { t1 })

    lt.assertEquals(t2:view(), [[
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

        _ENV.alias('Partial')
            : define(function (c)
                c.param('T')
            end)
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

    lt.assertEquals(t1:view(), [[
{
    x: "10",
    y: "20",
}]])

    local t2 = rt.call('Partial', { t1 })

    lt.assertEquals(t2:view(), [[
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

        _ENV.alias('Partial')
            : define(function (c)
                c.param('T')
            end)
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

    lt.assertEquals(rt.type 'XXX'.value:view(), [[
{
    x: "10",
    y: "20",
}]])

    local t2 = rt.call('Partial', { rt.type 'XXX' })

    lt.assertEquals(t2:view(), [[
{
    x?: "10" | nil,
    y?: "20" | nil,
}]])

    c:addField(rt.field('z', rt.value '30'))

    lt.assertEquals(rt.type 'XXX'.value:view(), [[
{
    x: "10",
    y: "20",
    z: "30",
}]])
    lt.assertEquals(t2.value:view(), [[
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

    lt.assertEquals(t:view(), 'Test')
    lt.assertEquals(t.value:view(), 'never')

    do
        local _ <close> = rt.alias('XXX', nil, rt.table {
            x = rt.value(123),
        })
        lt.assertEquals(t.value:view(), '123')
    end

    do
        local _ <close> = rt.alias('XXX', nil, rt.table {
            x = rt.value(345),
        })
        lt.assertEquals(t.value:view(), '345')
    end

    lt.assertEquals(t.value:view(), 'never')
end

do
    rt:reset()

    lt.assertEquals(rt.type('Test'):view(), 'Test')
    lt.assertEquals(rt.type('Test').value:view(), 'Test')

    local playground = ls.custom.playground(test.scope)
    do
        local _ENV = playground.env

        _ENV.alias('Test')
            : onValue(function (c)
                return c.value(1)
            end)
    end

    lt.assertEquals(rt.type('Test').value:view(), '1')

    playground:dispose()

    lt.assertEquals(rt.type('Test').value:view(), 'Test')
end

do
    -- value 为 type A：求值后修改 type A（class），之前求得的 value 重新求值
    rt:reset()
    local playground = ls.custom.playground(test.scope)
    do
        local _ENV = playground.env
        _ENV.alias('ModName')
            : define(function (c)
                c.setValue(c.type 'A')
            end)
    end

    local mod = rt.call('ModName', {})
    lt.assertEquals(mod.value:view(), 'A')
    lt.assertEquals(mod.value.value:view(), 'A')

    rt.class('A')
        : addField(rt.field('x', rt.value(123)))
    lt.assertEquals(mod.value.value:view(), '{ x: 123 }')

    playground:dispose()
end

do
    -- value 为 type A：求值后通过 alias 覆盖 A 的值，之前求得的 value 重新求值
    rt:reset()
    local playground = ls.custom.playground(test.scope)
    do
        local _ENV = playground.env
        _ENV.alias('ModName')
            : define(function (c)
                c.setValue(c.type 'A')
            end)
    end

    local mod = rt.call('ModName', {})
    lt.assertEquals(mod.value:view(), 'A')
    lt.assertEquals(mod.value.value:view(), 'A')

    do
        local aliasA <close> = rt.alias('A', nil, rt.table {
            y = rt.value(456),
        })
        lt.assertEquals(mod.value.value:view(), '{ y: 456 }')
    end

    lt.assertEquals(mod.value.value:view(), 'A')

    playground:dispose()
end
