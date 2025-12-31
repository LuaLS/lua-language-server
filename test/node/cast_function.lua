do
    local a = test.scope.rt.func()
    local b = test.scope.rt.type 'function'

    lt.assertEquals(a >> b, true)
    lt.assertEquals(b >> a, true)
end

do
    local a = test.scope.rt.func()
        : addParamDef('x', test.scope.rt.type 'number')
    local b = test.scope.rt.func()
        : addParamDef('x', test.scope.rt.type 'number')

    lt.assertEquals(a >> b, true)
    lt.assertEquals(b >> a, true)
end

do
    local a = test.scope.rt.func()
        : addParamDef('x', test.scope.rt.type 'number')
    local b = test.scope.rt.func()
        : addParamDef('x', test.scope.rt.type 'boolean')

    lt.assertEquals(a >> b, false)
    lt.assertEquals(b >> a, false)
end

do
    local a = test.scope.rt.func()
        : addParamDef('x', test.scope.rt.type 'number')
    local b = test.scope.rt.func()
        : addParamDef('x', test.scope.rt.type 'integer')

    lt.assertEquals(a >> b, false)
    lt.assertEquals(b >> a, true)
end

do
    local a = test.scope.rt.func()
        : addParamDef('x', test.scope.rt.type 'number')
        : addParamDef('y', test.scope.rt.type 'number')
    local b = test.scope.rt.func()
        : addParamDef('x', test.scope.rt.type 'number')

    lt.assertEquals(a >> b, true)
    lt.assertEquals(b >> a, false)
end

do
    local a = test.scope.rt.func()
        : addParamDef('x', test.scope.rt.type 'number')
        : addParamDef('y', test.scope.rt.type 'boolean')
        : addVarargParamDef(test.scope.rt.type 'string')
    local b = test.scope.rt.func()
        : addParamDef('x', test.scope.rt.type 'number')
        : addParamDef('y', test.scope.rt.type 'boolean')

    lt.assertEquals(a >> b, true)
    lt.assertEquals(b >> a, true)
end

do
    local a = test.scope.rt.func()
        : addParamDef('x', test.scope.rt.type 'number')
        : addParamDef('y', test.scope.rt.type 'boolean')
        : addVarargParamDef(test.scope.rt.type 'string')
    local b = test.scope.rt.func()
        : addParamDef('x', test.scope.rt.type 'number')
        : addParamDef('y', test.scope.rt.type 'boolean')
        : addVarargParamDef(test.scope.rt.type 'string')

    lt.assertEquals(a >> b, true)
    lt.assertEquals(b >> a, true)
end

do
    local a = test.scope.rt.func()
        : addParamDef('x', test.scope.rt.type 'number')
        : addParamDef('y', test.scope.rt.type 'boolean')
        : addVarargParamDef(test.scope.rt.type 'string')
    local b = test.scope.rt.func()
        : addParamDef('x', test.scope.rt.type 'number')
        : addParamDef('y', test.scope.rt.type 'boolean')
        : addVarargParamDef(test.scope.rt.type 'boolean')

    lt.assertEquals(a >> b, false)
    lt.assertEquals(b >> a, false)
end

do
    local a = test.scope.rt.func()
        : addParamDef('x', test.scope.rt.type 'number')
        : addVarargParamDef(test.scope.rt.type 'string')
    local b = test.scope.rt.func()
        : addParamDef('x', test.scope.rt.type 'number')

    lt.assertEquals(a >> b, true)
    lt.assertEquals(b >> a, true)
end

do
    local a = test.scope.rt.func()
        : addParamDef('x', test.scope.rt.type 'number')
        : addVarargParamDef(test.scope.rt.type 'string')
    local b = test.scope.rt.func()
        : addParamDef('x', test.scope.rt.type 'number')
        : addParamDef('y', test.scope.rt.type 'string')

    lt.assertEquals(a >> b, false)
    lt.assertEquals(b >> a, true)
end

do
    local a = test.scope.rt.func()
        : addParamDef('x', test.scope.rt.type 'number')
        : addVarargParamDef(test.scope.rt.type 'string')
    local b = test.scope.rt.func()
        : addVarargParamDef(test.scope.rt.type 'string')

    lt.assertEquals(a >> b, false)
    lt.assertEquals(b >> a, false)
end
