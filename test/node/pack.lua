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

do
    local tbl = rt.table {
        [rt.value(1)] = rt.INTEGER,
        [rt.value(2)] = rt.STRING,
        n             = rt.INTEGER,
    }
    local list = rt.list({ rt.spread(tbl) })
    lt.assertEquals(list:viewAsList(), 'integer, string')
    lt.assertEquals(list.min, 2)
end

do
    local T = rt.generic 'T'
    local paramVar = rt.variable '...'
    paramVar:addType(rt.pack(T))
    local inter = rt.intersection { T, rt.table { n = rt.INTEGER } }
    local f = rt.func()
        : addVarargParamDef(paramVar)
        : addReturnDef(nil, inter)

    lt.assertEquals(inter.value.kind, 'intersection')

    local map = f:makeGenericMap { rt.value(1), rt.STRING }
    lt.assertEquals(map[T]:view(), '[1, string]')

    local resolved = inter:resolveGeneric(map)
    lt.assertEquals(resolved:view(), [[{
    [1]: 1,
    [2]: string,
    n: integer,
}]])
end

do
    local T = rt.generic('T', rt.array(rt.ANY))
    local paramVar = rt.variable '...'
    paramVar:addType(rt.pack(T))
    local f = rt.func()
        : addVarargParamDef(paramVar)
        : addReturnDef(nil, rt.intersection { T, rt.table { n = rt.INTEGER } })

    local map = f:makeGenericMap { rt.value(1), rt.STRING }
    lt.assertEquals(map[T]:view(), '[1, string]')

    local resolved = f:resolveGeneric(map)
    ---@cast resolved Node.Function
    lt.assertEquals(resolved.returnsDef[1].value.kind, 'intersection')
end

do
    lt.assertEquals((rt.TRUE | rt.FALSE):view(), 'boolean')
    lt.assertEquals((rt.FALSE | rt.BOOLEAN):view(), 'boolean')
end

do
    local R = rt.generic('R', rt.array(rt.ANY))
    local o1 = rt.func()
        : addParamDef('f', rt.func()
            : addReturnDef(nil, rt.spread(R)))
        : addReturnDef(nil, rt.TRUE)
        : addReturnDef(nil, rt.spread(R))
    local o2 = rt.func()
        : addParamDef('f', rt.func())
        : addReturnDef(nil, rt.FALSE)
        : addReturnDef(nil, rt.STRING)

    local u = o1 | o2
    lt.assertEquals(u:view(), '(fun(f: fun():...R):(true, ...R)) | (fun(f: fun()):(false, string))')
end

do
    local R = rt.generic('R', rt.array(rt.ANY))
    local inner = rt.func()
        : addReturnDef(nil, rt.INTEGER)
        : addReturnDef(nil, rt.STRING)
    local sig = rt.func()
        : addParamDef('f', rt.func()
            : addReturnDef(nil, rt.spread(R)))
        : addReturnDef(nil, rt.TRUE)
        : addReturnDef(nil, rt.spread(R))

    local map = sig:makeGenericMap { inner }
    lt.assertEquals(map[R]:view(), '[integer, string]')

    local resolved = sig:resolveGeneric(map)
    ---@cast resolved Node.Function
    lt.assertEquals(resolved.returnsPack:viewAsList(), 'true, integer, string')
end

do
    local T = rt.generic('T', rt.array(rt.ANY))
    local f = rt.func()
        : addTypeParam(T)
        : addParamDef('t', T)
        : addReturnDef(nil, rt.spread(T))

    local arg = rt.variable 't'
    arg:setStaticValue(rt.table {
        [rt.value(1)] = rt.INTEGER,
        [rt.value(2)] = rt.STRING,
    })

    local fcall = rt.fcall(f, { arg })
    lt.assertEquals(fcall.value:viewAsList(), 'integer, string')
end
