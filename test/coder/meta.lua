local rt = test.scope.rt

do
    TEST_INDEX [[
        ---@class A
        ---@field x number
        ---@field y number
        ---@field z number
    ]]

    lt.assertEquals(rt.type('A').value:view(), [[
{
    x: number,
    y: number,
    z: number,
}]])
end

do
    TEST_INDEX [[
        ---@class A
        A = {}

        A.x = 1
        A.y = 2
    ]]

    lt.assertEquals(rt.type('A').value:view(), [[
{
    x: 1,
    y: 2,
}]])
end

do
    TEST_INDEX [[
        ---@class A
        A.B = {}

        A.B.x = 1
        A.B.y = 2
    ]]

    lt.assertEquals(rt.type('A').value:view(), [[
{
    x: 1,
    y: 2,
}]])
end

do
   TEST_INDEX [[
        ---@class A
        local A = {}

        A.x = 1
        A.y = 2
    ]]

    lt.assertEquals(rt.type('A').value:view(), [[
{
    x: 1,
    y: 2,
}]])
end

do
    TEST_INDEX [[
        local A = {}

        ---@class A
        A.B = {}

        A.B.x = 1
        A.B.y = 2
    ]]

    lt.assertEquals(rt.type('A').value:view(), [[
{
    x: 1,
    y: 2,
}]])
end

do
    TEST_INDEX [[
        function type(o)
        end
    ]]

    lt.assertEquals(rt:globalGet('type').value:view(), 'fun(o: any)')
end

do
    TEST_INDEX [[
        ---@param o table
        ---@return string
        function type(o)
        end
    ]]

    lt.assertEquals(rt:globalGet('type').value:view(), 'fun(o: table):string')
end

do
    TEST_INDEX [[
        ---@param v any
        ---@narrow v
        function assert(v) end
    ]]

    local f = rt:globalGet('assert').value
    ---@cast f Node.Function
    local defs = f:getNarrowDefs()
    lt.assertEquals(#defs, 1)
    lt.assertEquals(defs[1].param, 'v')
    lt.assertEquals(defs[1].type, nil)
end

do
    TEST_INDEX [[
        ---@param v any
        ---@narrow v string
        function assertString(v) end
    ]]

    local f = rt:globalGet('assertString').value
    ---@cast f Node.Function
    local defs = f:getNarrowDefs()
    lt.assertEquals(#defs, 1)
    lt.assertEquals(defs[1].param, 'v')
    lt.assertEquals(defs[1].type:view(), 'string')
end
