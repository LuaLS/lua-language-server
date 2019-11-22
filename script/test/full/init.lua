local buildVM = require 'vm'
local parser  = require 'parser'

rawset(_G, 'TEST', true)

function TEST(script)
    local ast = parser:parse(script, 'lua', 'Lua 5.3')
    assert(ast)
    local vm, err = buildVM(ast)
    assert(vm, err)
    return vm
end

require 'full.normal'
require 'full.example'
require 'full.dirty'
