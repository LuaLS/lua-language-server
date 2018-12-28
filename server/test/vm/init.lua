local core = require 'core'
local parser  = require 'parser'

rawset(_G, 'TEST', true)

function TEST(script)
    local ast = parser:ast(script)
    assert(ast)
    local vm = core.vm(ast)
    assert(vm)
    local results = vm.results
    assert(results)
end

require 'vm.normal'
require 'vm.example'
require 'vm.dirty'
