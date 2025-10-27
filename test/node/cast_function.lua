do
    local a = test.scope.node.func()
    local b = test.scope.node.type 'function'

    assert(a >> b == true)
    assert(b >> a == true)
end

do
    local a = test.scope.node.func()
        : addParamDef('x', test.scope.node.type 'number')
    local b = test.scope.node.func()
        : addParamDef('x', test.scope.node.type 'number')

    assert(a >> b == true)
    assert(b >> a == true)
end

do
    local a = test.scope.node.func()
        : addParamDef('x', test.scope.node.type 'number')
    local b = test.scope.node.func()
        : addParamDef('x', test.scope.node.type 'boolean')

    assert(a >> b == false)
    assert(b >> a == false)
end

do
    local a = test.scope.node.func()
        : addParamDef('x', test.scope.node.type 'number')
    local b = test.scope.node.func()
        : addParamDef('x', test.scope.node.type 'integer')

    assert(a >> b == false)
    assert(b >> a == true)
end

do
    local a = test.scope.node.func()
        : addParamDef('x', test.scope.node.type 'number')
        : addParamDef('y', test.scope.node.type 'number')
    local b = test.scope.node.func()
        : addParamDef('x', test.scope.node.type 'number')

    assert(a >> b == true)
    assert(b >> a == false)
end

do
    local a = test.scope.node.func()
        : addParamDef('x', test.scope.node.type 'number')
        : addParamDef('y', test.scope.node.type 'boolean')
        : addVarargParamDef(test.scope.node.type 'string')
    local b = test.scope.node.func()
        : addParamDef('x', test.scope.node.type 'number')
        : addParamDef('y', test.scope.node.type 'boolean')

    assert(a >> b == true)
    assert(b >> a == true)
end

do
    local a = test.scope.node.func()
        : addParamDef('x', test.scope.node.type 'number')
        : addParamDef('y', test.scope.node.type 'boolean')
        : addVarargParamDef(test.scope.node.type 'string')
    local b = test.scope.node.func()
        : addParamDef('x', test.scope.node.type 'number')
        : addParamDef('y', test.scope.node.type 'boolean')
        : addVarargParamDef(test.scope.node.type 'string')

    assert(a >> b == true)
    assert(b >> a == true)
end

do
    local a = test.scope.node.func()
        : addParamDef('x', test.scope.node.type 'number')
        : addParamDef('y', test.scope.node.type 'boolean')
        : addVarargParamDef(test.scope.node.type 'string')
    local b = test.scope.node.func()
        : addParamDef('x', test.scope.node.type 'number')
        : addParamDef('y', test.scope.node.type 'boolean')
        : addVarargParamDef(test.scope.node.type 'boolean')

    assert(a >> b == false)
    assert(b >> a == false)
end

do
    local a = test.scope.node.func()
        : addParamDef('x', test.scope.node.type 'number')
        : addVarargParamDef(test.scope.node.type 'string')
    local b = test.scope.node.func()
        : addParamDef('x', test.scope.node.type 'number')

    assert(a >> b == true)
    assert(b >> a == true)
end

do
    local a = test.scope.node.func()
        : addParamDef('x', test.scope.node.type 'number')
        : addVarargParamDef(test.scope.node.type 'string')
    local b = test.scope.node.func()
        : addParamDef('x', test.scope.node.type 'number')
        : addParamDef('y', test.scope.node.type 'string')

    assert(a >> b == false)
    assert(b >> a == true)
end

do
    local a = test.scope.node.func()
        : addParamDef('x', test.scope.node.type 'number')
        : addVarargParamDef(test.scope.node.type 'string')
    local b = test.scope.node.func()
        : addVarargParamDef(test.scope.node.type 'string')

    assert(a >> b == false)
    assert(b >> a == false)
end
