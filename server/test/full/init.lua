local buildVM = require 'vm'
local parser  = require 'parser'

rawset(_G, 'TEST', true)

function TEST(script)
    local ast = parser:ast(script)
    assert(ast)
    local vm = buildVM(ast)
    assert(vm)
end

require 'full.normal'
require 'full.example'
require 'full.dirty'
