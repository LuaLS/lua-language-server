local rt = test.scope.rt

do
    local a = rt.func()
    local b = rt.type 'function'

    lt.assertEquals(a >> b, true)
    lt.assertEquals(b >> a, true)
end

do
    local a = rt.func()
        : addParamDef('x', rt.type 'number')
    local b = rt.func()
        : addParamDef('x', rt.type 'number')

    lt.assertEquals(a >> b, true)
    lt.assertEquals(b >> a, true)
end

do
    local a = rt.func()
        : addParamDef('x', rt.type 'number')
    local b = rt.func()
        : addParamDef('x', rt.type 'boolean')

    lt.assertEquals(a >> b, false)
    lt.assertEquals(b >> a, false)
end

do
    local a = rt.func()
        : addParamDef('x', rt.type 'number')
    local b = rt.func()
        : addParamDef('x', rt.type 'integer')

    lt.assertEquals(a >> b, true)
    lt.assertEquals(b >> a, false)
end

do
    local a = rt.func()
        : addParamDef('x', rt.type 'number')
        : addParamDef('y', rt.type 'number')
    local b = rt.func()
        : addParamDef('x', rt.type 'number')

    lt.assertEquals(a >> b, false)
    lt.assertEquals(b >> a, true)
end

-- vararg 不定参：观察逆变下行为
do
    local a = rt.func()
        : addParamDef('x', rt.type 'number')
        : addParamDef('y', rt.type 'boolean')
        : addVarargParamDef(rt.type 'string')
    local b = rt.func()
        : addParamDef('x', rt.type 'number')
        : addParamDef('y', rt.type 'boolean')

    lt.assertEquals(a >> b, true)
    lt.assertEquals(b >> a, true)
end

do
    local a = rt.func()
        : addParamDef('x', rt.type 'number')
        : addParamDef('y', rt.type 'boolean')
        : addVarargParamDef(rt.type 'string')
    local b = rt.func()
        : addParamDef('x', rt.type 'number')
        : addParamDef('y', rt.type 'boolean')
        : addVarargParamDef(rt.type 'string')

    lt.assertEquals(a >> b, true)
    lt.assertEquals(b >> a, true)
end

do
    local a = rt.func()
        : addParamDef('x', rt.type 'number')
        : addParamDef('y', rt.type 'boolean')
        : addVarargParamDef(rt.type 'string')
    local b = rt.func()
        : addParamDef('x', rt.type 'number')
        : addParamDef('y', rt.type 'boolean')
        : addVarargParamDef(rt.type 'boolean')

    lt.assertEquals(a >> b, false)
    lt.assertEquals(b >> a, false)
end

do
    local a = rt.func()
        : addParamDef('x', rt.type 'number')
        : addVarargParamDef(rt.type 'string')
    local b = rt.func()
        : addParamDef('x', rt.type 'number')

    lt.assertEquals(a >> b, true)
    lt.assertEquals(b >> a, true)
end

do
    local a = rt.func()
        : addParamDef('x', rt.type 'number')
        : addVarargParamDef(rt.type 'string')
    local b = rt.func()
        : addParamDef('x', rt.type 'number')
        : addParamDef('y', rt.type 'string')

    lt.assertEquals(a >> b, true)
    lt.assertEquals(b >> a, true)
end

do
    local a = rt.func()
        : addParamDef('x', rt.type 'number')
        : addVarargParamDef(rt.type 'string')
    local b = rt.func()
        : addVarargParamDef(rt.type 'string')

    lt.assertEquals(a >> b, false)
    lt.assertEquals(b >> a, false)
end
