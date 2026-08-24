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
