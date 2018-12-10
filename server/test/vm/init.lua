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
