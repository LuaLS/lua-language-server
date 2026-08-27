local rt = test.scope.rt
local testIndex = _G.TEST_INDEX

testIndex [[
    global answer = 42
    local copy = answer
    function named(...args)
        return args[1], args.n, ...
    end
]]

lt.assertEquals(rt:globalGet('answer').value:view(), '42')

do
    TEST_INDEX [[
        global x
        x = 'outer'
        ---@alias G0 $x

        do
            local _ENV = { x = 'inner' }
            ---@alias G1 $x
            global y = 'inner'
        end
        ---@alias G2 $x
    ]]

    lt.assertEquals(rt.type('G0').value:view(), "'outer'")
    lt.assertEquals(rt.type('G1').value:view(), "'inner'")
    lt.assertEquals(rt.type('G2').value:view(), "'outer'")
    lt.assertEquals(rt:globalGet('y'):isDefined(), false)
end
