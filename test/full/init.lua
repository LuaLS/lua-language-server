local parser  = require 'parser'

rawset(_G, 'TEST', true)

function TEST(script)
    local ast = parser:compile(script, 'lua', 'Lua 5.3')
    assert(ast)
    return ast
end

require 'full.normal'
require 'full.example'
require 'full.dirty'
require 'full.self'
