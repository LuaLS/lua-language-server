local parser = require 'parser'
local matcher = require 'matcher'

rawset(_G, 'TEST', true)

function TEST(script)
    return function (expect)
        local pos = script:find('@', 1, true)
        local new_script = script:gsub('@', '')
        local ast = parser:ast(new_script)
        local vm = matcher.vm(ast)
        assert(vm)
        local results = matcher.signature(vm, pos)
        assert(results)
        local result = results[#results]

        local label = result.label:gsub('^[\r\n]*(.-)[\r\n]*$', '%1'):gsub('\r\n', '\n')
        expect.label = expect.label:gsub('^[\r\n]*(.-)[\r\n]*$', '%1'):gsub('\r\n', '\n')
        local arg = result.arg.label

        assert(expect.label == label)
        assert(expect.arg == arg)
    end
end

TEST [[
local function x(a, b)
end

x(@
]]
{
    label = "function x(a: any, b: any)",
    arg = 'a: any'
}
