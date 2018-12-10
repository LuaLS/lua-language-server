local matcher = require 'matcher'
local parser  = require 'parser'

rawset(_G, 'TEST', true)

function TEST(script)
    local ast = parser:ast(script)
    assert(ast)
    local results = matcher.vm(ast)
    assert(results)
end

TEST [[
do
    x = 1
end
]]

TEST [[
return nil, 1, true, 'xx'
]]

TEST [[
return a
]]

TEST [[
retrun a.b:c(1, 2, ...)[1][name]
]]

TEST [[
return 1 + 1
]]

TEST [[
return -1
]]

TEST [[
return ...
]]

TEST [[
return function (a, b, ...)
end
]]

TEST [[
return {
    a = 1,
    b = {
        c = d,
        e = f,
    },
    g,
    h,
    1,
}
]]

TEST [[
::LABEL::
goto LABEL
goto NEXT
::NEXT::
]]

TEST [[
a, b, c = 1, 2, ...
]]
