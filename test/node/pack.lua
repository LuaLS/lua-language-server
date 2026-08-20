local rt = test.scope.rt

do
    local tuple = rt.tuple { rt.INTEGER, rt.STRING }
    local f = rt.func()
        : addReturnDef(nil, rt.spread(tuple))

    lt.assertEquals(f.returnsPack:viewAsList(), 'integer, string')
end

do
    local f = rt.func()
        : addReturnDef(nil, rt.spread(rt.array(rt.STRING)))

    lt.assertEquals(f.returnsPack:viewAsList(), 'string?...')
end

do
    --[[
    ---@generic T: any[]
    ---@param ...T any
    ---@return T
    ]]
    local T = rt.generic('T', rt.array(rt.ANY))
    local f = rt.func()
        : addTypeParam(T)
        : addVarargParamDef(rt.pack(T))
        : addReturnDef(nil, T)

    local map = f:makeGenericMap { rt.value(1), rt.STRING }
    lt.assertEquals(map[T]:view(), '[1, string]')

    local resolved = f:resolveGeneric(map)
    ---@cast resolved Node.Function
    lt.assertEquals(resolved:getReturn(1):view(), '[1, string]')
end

do
    local T = rt.generic('T', rt.array(rt.ANY))
    local f = rt.func()
        : addTypeParam(T)
        : addVarargParamDef(rt.pack(T))
        : addReturnDef(nil, T)

    local map = f:makeGenericMap {}
    lt.assertEquals(map[T]:view(), '[nil]')
end

do
    --[[
    ---@generic T: any[]
    ---@param t T
    ---@return ...T
    ]]
    local T = rt.generic('T', rt.array(rt.ANY))
    local f = rt.func()
        : addTypeParam(T)
        : addParamDef('t', T)
        : addReturnDef(nil, rt.spread(T))

    local map = f:makeGenericMap { rt.tuple { rt.INTEGER, rt.STRING } }
    local resolved = f:resolveGeneric(map)
    ---@cast resolved Node.Function
    lt.assertEquals(resolved.returnsPack:viewAsList(), 'integer, string')
    lt.assertEquals(resolved:getReturn(2):view(), 'string')
end

do
    local t = rt.intersection {
        rt.tuple { rt.INTEGER, rt.STRING },
        rt.table { n = rt.INTEGER },
    }

    lt.assertEquals(t:get(1):view(), 'integer')
    lt.assertEquals(t:get(2):view(), 'string')
    lt.assertEquals(t:get('n'):view(), 'integer')
end
