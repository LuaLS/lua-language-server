local rt = test.scope.rt

do
    local x = rt.alias('X')
        : setCustomValue(function (self)
            return rt.value 'custom X'
        end)

    assert(rt.type('X'):view() == 'X')
    assert(rt.type('X').value:view() == '"custom X"')
end

do
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

    assert(t1:view() == '{ x: "10", y: "20" }')

    local t2 = rt.call('Options', { t1 })

    assert(t2:view() == 'Options<{ x: "10", y: "20" }>')
    assert(t2.value:view() == '{ x?: "10" | nil, y?: "20" | nil }')
end

do
    local playground = ls.custom.playground(test.scope)
    do
        local _ENV = playground.env

        
    end

    local t1 = rt.table {
        [ 'x' ] = rt.value '10',
        [ 'y' ] = rt.value '20',
    }

    assert(t1:view() == '{ x: "10", y: "20" }')

    local t2 = rt.call('Options', { t1 })

    assert(t2:view() == 'Options<{ x: "10", y: "20" }>')
    assert(t2.value:view() == '{ x?: "10" | nil, y?: "20" | nil }')
end
