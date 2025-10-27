local node = test.scope.node

do
    node:reset()
    --[[
    (fun(x: number): boolean)(1)
    --> boolean
    ]]

    local f = node.func()
        : addParamDef('x', node.NUMBER)
        : addReturnDef(nil, node.BOOLEAN)

    local fcall = node.fcall(f, { node.value(1) })
    local r = fcall.value
    assert(r:view() == 'boolean')
end

do
    node:reset()
    --[[
    (fun<T1, T2>(x: T1, y: T2): T1[], T2[])(number, string)
    --> number[], string[]
    ]]

    local T1 = node.generic 'T1'
    local T2 = node.generic 'T2'
    local f = node.func()
        : addTypeParam(T1)
        : addTypeParam(T2)
        : addParamDef('x', T1)
        : addParamDef('y', T2)
        : addReturnDef(nil, node.array(T1))
        : addReturnDef(nil, node.array(T2))

    local fcall = node.fcall(f, { node.NUMBER, node.STRING })
    local r = fcall.value
    assert(r:view() == 'number[]')
    assert(fcall.returns:get(1):view() == 'number[]')
    assert(fcall.returns:get(2):view() == 'string[]')
end
