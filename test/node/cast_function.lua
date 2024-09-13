do
    local a = ls.node.func()
    local b = ls.node.type 'function'

    assert(a >> b == true)
    assert(b >> a == true)
end

do
    local a = ls.node.func()
        : addParam('x', ls.node.type 'number')
    local b = ls.node.func()
        : addParam('x', ls.node.type 'number')

    assert(a >> b == true)
    assert(b >> a == true)
end

do
    local a = ls.node.func()
        : addParam('x', ls.node.type 'number')
    local b = ls.node.func()
        : addParam('x', ls.node.type 'boolean')

    assert(a >> b == false)
    assert(b >> a == false)
end

do
    local a = ls.node.func()
        : addParam('x', ls.node.type 'number')
    local b = ls.node.func()
        : addParam('x', ls.node.type 'integer')

    assert(a >> b == false)
    assert(b >> a == true)
end

do
    local a = ls.node.func()
        : addParam('x', ls.node.type 'number')
        : addParam('y', ls.node.type 'number')
    local b = ls.node.func()
        : addParam('x', ls.node.type 'number')

    assert(a >> b == true)
    assert(b >> a == false)
end

do
    local a = ls.node.func()
        : addParam('x', ls.node.type 'number')
        : addParam('y', ls.node.type 'boolean')
        : addVarargParam(ls.node.type 'string')
    local b = ls.node.func()
        : addParam('x', ls.node.type 'number')
        : addParam('y', ls.node.type 'boolean')

    assert(a >> b == true)
    assert(b >> a == true)
end

do
    local a = ls.node.func()
        : addParam('x', ls.node.type 'number')
        : addParam('y', ls.node.type 'boolean')
        : addVarargParam(ls.node.type 'string')
    local b = ls.node.func()
        : addParam('x', ls.node.type 'number')
        : addParam('y', ls.node.type 'boolean')
        : addVarargParam(ls.node.type 'string')

    assert(a >> b == true)
    assert(b >> a == true)
end

do
    local a = ls.node.func()
        : addParam('x', ls.node.type 'number')
        : addParam('y', ls.node.type 'boolean')
        : addVarargParam(ls.node.type 'string')
    local b = ls.node.func()
        : addParam('x', ls.node.type 'number')
        : addParam('y', ls.node.type 'boolean')
        : addVarargParam(ls.node.type 'boolean')

    assert(a >> b == false)
    assert(b >> a == false)
end

do
    local a = ls.node.func()
        : addParam('x', ls.node.type 'number')
        : addVarargParam(ls.node.type 'string')
    local b = ls.node.func()
        : addParam('x', ls.node.type 'number')

    assert(a >> b == true)
    assert(b >> a == true)
end

do
    local a = ls.node.func()
        : addParam('x', ls.node.type 'number')
        : addVarargParam(ls.node.type 'string')
    local b = ls.node.func()
        : addParam('x', ls.node.type 'number')
        : addParam('y', ls.node.type 'string')

    assert(a >> b == true)
    assert(b >> a == true)
end

do
    local a = ls.node.func()
        : addParam('x', ls.node.type 'number')
        : addVarargParam(ls.node.type 'string')
    local b = ls.node.func()
        : addVarargParam(ls.node.type 'string')

    assert(a >> b == false)
    assert(b >> a == false)
end
