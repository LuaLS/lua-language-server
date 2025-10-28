do
    local a = test.scope.rt.func()
    local b = test.scope.rt.type 'function'

    assert(a >> b == true)
    assert(b >> a == true)
end

do
    local a = test.scope.rt.func()
        : addParamDef('x', test.scope.rt.type 'number')
    local b = test.scope.rt.func()
        : addParamDef('x', test.scope.rt.type 'number')

    assert(a >> b == true)
    assert(b >> a == true)
end

do
    local a = test.scope.rt.func()
        : addParamDef('x', test.scope.rt.type 'number')
    local b = test.scope.rt.func()
        : addParamDef('x', test.scope.rt.type 'boolean')

    assert(a >> b == false)
    assert(b >> a == false)
end

do
    local a = test.scope.rt.func()
        : addParamDef('x', test.scope.rt.type 'number')
    local b = test.scope.rt.func()
        : addParamDef('x', test.scope.rt.type 'integer')

    assert(a >> b == false)
    assert(b >> a == true)
end

do
    local a = test.scope.rt.func()
        : addParamDef('x', test.scope.rt.type 'number')
        : addParamDef('y', test.scope.rt.type 'number')
    local b = test.scope.rt.func()
        : addParamDef('x', test.scope.rt.type 'number')

    assert(a >> b == true)
    assert(b >> a == false)
end

do
    local a = test.scope.rt.func()
        : addParamDef('x', test.scope.rt.type 'number')
        : addParamDef('y', test.scope.rt.type 'boolean')
        : addVarargParamDef(test.scope.rt.type 'string')
    local b = test.scope.rt.func()
        : addParamDef('x', test.scope.rt.type 'number')
        : addParamDef('y', test.scope.rt.type 'boolean')

    assert(a >> b == true)
    assert(b >> a == true)
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

    assert(a >> b == true)
    assert(b >> a == true)
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

    assert(a >> b == false)
    assert(b >> a == false)
end

do
    local a = test.scope.rt.func()
        : addParamDef('x', test.scope.rt.type 'number')
        : addVarargParamDef(test.scope.rt.type 'string')
    local b = test.scope.rt.func()
        : addParamDef('x', test.scope.rt.type 'number')

    assert(a >> b == true)
    assert(b >> a == true)
end

do
    local a = test.scope.rt.func()
        : addParamDef('x', test.scope.rt.type 'number')
        : addVarargParamDef(test.scope.rt.type 'string')
    local b = test.scope.rt.func()
        : addParamDef('x', test.scope.rt.type 'number')
        : addParamDef('y', test.scope.rt.type 'string')

    assert(a >> b == false)
    assert(b >> a == true)
end

do
    local a = test.scope.rt.func()
        : addParamDef('x', test.scope.rt.type 'number')
        : addVarargParamDef(test.scope.rt.type 'string')
    local b = test.scope.rt.func()
        : addVarargParamDef(test.scope.rt.type 'string')

    assert(a >> b == false)
    assert(b >> a == false)
end
