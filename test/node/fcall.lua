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
    lt.assertEquals(r:view(), 'boolean')
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
    lt.assertEquals(r:view(), 'number[]')
    lt.assertEquals(fcall.returns:select(1):view(), 'number[]')
    lt.assertEquals(fcall.returns:select(2):view(), 'string[]')
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

    lt.assertEquals(r1.value:view(), '1')
    lt.assertEquals(r2.value:view(), '2')
    lt.assertEquals(r3.value:view(), '3')
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

    local fcall = rt.fcall(f, {})
    local r = fcall.value
    lt.assertEquals(r:view(), '1')
end

do
    rt:reset()
    --[[
    local function f()
        return 1, 2
        return 3, 4
    end

    local x = f()
    ]]
    local f = rt.func()
        : addReturnList(rt.list { rt.value(1), rt.value(2) })
        : addReturnList(rt.list { rt.value(3), rt.value(4) })

    local fcall = rt.fcall(f, {})
    local r1 = fcall:select(1)
    lt.assertEquals(r1:view(), '1 | 3')
    local r2 = fcall:select(2)
    lt.assertEquals(r2:view(), '2 | 4')
end

do -- 方案1
    rt:reset()
    --[[
    ---@overload fun(x: number): 'number'
    ---@overload fun(x: string): 'string'
    ---@overload fun(x: boolean): 'boolean'
    ---@overload fun(x: table): 'table'
    local function type(x) end

    type(123) --> "number"
    type('hello') --> "string"
    type(true) --> "boolean"
    type({}) --> "table"
    type(X) --> "number" | "string" | "boolean" | "table"
    ]]

    local f = rt.variable 'type'
    f:setCurrentValue(rt.union {
        rt.func()
            : addParamDef('x', rt.NUMBER)
            : addReturnDef(nil, rt.value('number')),
        rt.func()
            : addParamDef('x', rt.STRING)
            : addReturnDef(nil, rt.value('string')),
        rt.func()
            : addParamDef('x', rt.BOOLEAN)
            : addReturnDef(nil, rt.value('boolean')),
        rt.func()
            : addParamDef('x', rt.TABLE)
            : addReturnDef(nil, rt.value('table')),
        }
    )

    lt.assertEquals(rt.fcall(f, { rt.value(123) }):simplify():view(), '"number"')
    lt.assertEquals(rt.fcall(f, { rt.value('hello') }):simplify():view(), '"string"')
    lt.assertEquals(rt.fcall(f, { rt.value(true) }):simplify():view(), '"boolean"')
    lt.assertEquals(rt.fcall(f, { rt.table {} }):simplify():view(), '"table"')
    lt.assertEquals(rt.fcall(f, { rt.variable 'X' }):simplify():view(), '"number" | "string" | "boolean" | "table"')
end

do -- 方案2
    rt:reset()
    --[[
    ---@alias TypeViewMap {
    ---    [number]: 'number',
    ---    [string]: 'string',
    ---    [boolean]: 'boolean',
    ---    [table]: 'table',
    ---}
    
    ---@generic T
    ---@param x T
    ---@return TypeViewMap[T]
    local function type(x) end

    type(123) --> "number"
    type('hello') --> "string"
    type(true) --> "boolean"
    type({}) --> "table"
    type(X) --> "number" | "string" | "boolean" | "table"
    ]]

    local map = rt.alias 'TypeViewMap'
    map:setValue(rt.table()
        : addField(rt.field(rt.NUMBER, rt.value('number')))
        : addField(rt.field(rt.STRING, rt.value('string')))
        : addField(rt.field(rt.BOOLEAN, rt.value('boolean')))
        : addField(rt.field(rt.TABLE, rt.value('table')))
    )

    local T = rt.generic 'T'
    local f = rt.func()
        : addTypeParam(T)
        : addParamDef('x', T)
        : addReturnDef(nil, rt.index(rt.type 'TypeViewMap', T))

    lt.assertEquals(rt.fcall(f, { rt.value(123) }):simplify():view(), '"number"')
    lt.assertEquals(rt.fcall(f, { rt.value('hello') }):simplify():view(), '"string"')
    lt.assertEquals(rt.fcall(f, { rt.value(true) }):simplify():view(), '"boolean"')
    lt.assertEquals(rt.fcall(f, { rt.table {} }):simplify():view(), '"table"')
    lt.assertEquals(rt.fcall(f, { rt.variable 'X' }):simplify():view(), '"number" | "string" | "boolean" | "table"')
end

do -- 方案3
    rt:reset()
    --[[
    ---@alias TypeView<T> {
    ---    [number]: 'number',
    ---    [string]: 'string',
    ---    [boolean]: 'boolean',
    ---    [table]: 'table',
    ---}[T]
    
    ---@generic T
    ---@param x T
    ---@return TypeView<T>
    local function type(x) end

    type(123) --> "number"
    type('hello') --> "string"
    type(true) --> "boolean"
    type({}) --> "table"
    type(X) --> "number" | "string" | "boolean" | "table"
    ]]

    local T1 = rt.generic 'T'
    local view = rt.alias 'TypeView'
    view:addTypeParam(T1)
    view:setValue(rt.index(rt.table()
        : addField(rt.field(rt.NUMBER, rt.value('number')))
        : addField(rt.field(rt.STRING, rt.value('string')))
        : addField(rt.field(rt.BOOLEAN, rt.value('boolean')))
        : addField(rt.field(rt.TABLE, rt.value('table')))
    , T1))

    local T2 = rt.generic 'T'
    local f = rt.func()
        : addTypeParam(T2)
        : addParamDef('x', T2)
        : addReturnDef(nil, rt.call('TypeView', { T2 }))

    lt.assertEquals(rt.fcall(f, { rt.value(123) }):simplify():view(), '"number"')
    lt.assertEquals(rt.fcall(f, { rt.value('hello') }):simplify():view(), '"string"')
    lt.assertEquals(rt.fcall(f, { rt.value(true) }):simplify():view(), '"boolean"')
    lt.assertEquals(rt.fcall(f, { rt.table {} }):simplify():view(), '"table"')
    lt.assertEquals(rt.fcall(f, { rt.variable 'X' }):simplify():view(), '"number" | "string" | "boolean" | "table"')
end
