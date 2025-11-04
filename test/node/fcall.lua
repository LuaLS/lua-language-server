local rt = test.scope.rt

do
    rt:reset()
    --[[
    (fun(x: number): boolean)(1)
    --> boolean
    ]]

    local f = rt.func()
        : addParamDef('x', rt.NUMBER)
        : addReturnDef(nil, rt.BOOLEAN)

    local fcall = rt.fcall(f, { rt.value(1) })
    local r = fcall.value
    assert(r:view() == 'boolean')
end

do
    rt:reset()
    --[[
    (fun<T1, T2>(x: T1, y: T2): T1[], T2[])(number, string)
    --> number[], string[]
    ]]

    local T1 = rt.generic 'T1'
    local T2 = rt.generic 'T2'
    local f = rt.func()
        : addTypeParam(T1)
        : addTypeParam(T2)
        : addParamDef('x', T1)
        : addParamDef('y', T2)
        : addReturnDef(nil, rt.array(T1))
        : addReturnDef(nil, rt.array(T2))

    local fcall = rt.fcall(f, { rt.NUMBER, rt.STRING })
    local r = fcall.value
    assert(r:view() == 'number[]')
    assert(fcall.returns:select(1):view() == 'number[]')
    assert(fcall.returns:select(2):view() == 'string[]')
end

do
    rt:reset()
    --[[
    ---@alias F fun(x: any): 1
    ---@alias F fun(x: number): 2
    ---@alias F<T: string> fun(x: T): 3
    ]]

    local _ = rt.type 'F'
    rt.alias('F', nil, rt.func()
        : addParamDef('x', rt.ANY)
        : addReturnDef(nil, rt.value(1))
    )
    rt.alias('F', nil, rt.func()
        : addParamDef('x', rt.NUMBER)
        : addReturnDef(nil, rt.value(2))
    )
    local T = rt.generic('T', rt.STRING)
    rt.alias('F', nil, rt.func()
        : addTypeParam(T)
        : addParamDef('x', T)
        : addReturnDef(nil, rt.value(3))
    )

    local r1 = rt.fcall(rt.type 'F', { rt.value(true) })
    local r2 = rt.fcall(rt.type 'F', { rt.value(123) } )
    local r3 = rt.fcall(rt.type 'F', { rt.value('hello') } )

    assert(r1.value:view() == '1')
    assert(r2.value:view() == '2')
    assert(r3.value:view() == '3')
end

do
    rt:reset()
    --[[
    local function f()
        return 1
    end

    local x = f()
    ]]
    local f = rt.func()
        : addReturnList(rt.list { rt.value(1) })
end
