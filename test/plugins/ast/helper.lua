local helper = require 'plugins.astHelper'
local parser = require 'parser'

function Run(script, plugin)
    local state = parser.compile(script, "Lua", "Lua 5.4")
    plugin(state)
    parser.luadoc(state)
    return state
end

local function TestInsertDoc(script)
    local state = Run(script, function (state)
        local comment = assert(helper.buildComment("class", "AA", state.ast[1].start))
        helper.InsertDoc(state.ast, comment)
    end)
    assert(state.ast[1].bindDocs)
end

TestInsertDoc("A={}")

local function TestaddClassDoc(script)
    local state = Run(script, function (state)
        assert(helper.addClassDoc(state.ast, state.ast[1], "AA"))
    end)
    assert(state.ast[1].bindDocs)
end

TestaddClassDoc [[a={}]]

TestaddClassDoc [[local a={}]]

local function TestaddClassDocAtParam(script, index)
    index = index or 1
    local arg
    local state = Run(script, function (state)
        local func = state.ast[1].value
        local ok
        ok, arg = helper.addClassDocAtParam(state.ast, "AA", func, index)
        assert(ok)
    end)
    assert(arg.bindDocs)
end

TestaddClassDocAtParam [[
    function a(b) end
]]

local function TestaddParamTypeDoc(script, index)
    index = index or 1
    local func
    Run(script, function (state)
        func = state.ast[1].value
        assert(helper.addParamTypeDoc(state.ast, "string", func.args[index]))
    end)
    assert(func.args[index].bindDocs)
end

TestaddParamTypeDoc [[
    local function t(a)end
]]

TestaddParamTypeDoc([[
    local function t(a,b,c,d)end
]], 4)
