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
    assert(fcall.returns:select(1):view() == 'number[]')
    assert(fcall.returns:select(2):view() == 'string[]')
end

do
    node:reset()
    --[[
    ---@alias F fun(x: any): 1
    ---@alias F fun(x: number): 2
    ---@alias F<T: string> fun(x: T): 3
    ]]

    node.alias('F', nil, node.func()
        : addParamDef('x', node.ANY)
        : addReturnDef(nil, node.value(1))
    )
    node.alias('F', nil, node.func()
        : addParamDef('x', node.NUMBER)
        : addReturnDef(nil, node.value(2))
    )
    local T = node.generic('T', node.STRING)
    node.alias('F', nil, node.func()
        : addTypeParam(T)
        : addParamDef('x', T)
        : addReturnDef(nil, node.value(3))
    )

    local r1 = node.fcall(node.type 'F', { node.value(true) })
    local r2 = node.fcall(node.type 'F', { node.value(123) } )
    local r3 = node.fcall(node.type 'F', { node.value('hello') } )

    assert(r1.value:view() == '1')
    assert(r2.value:view() == '2')
    assert(r3.value:view() == '3')
end
