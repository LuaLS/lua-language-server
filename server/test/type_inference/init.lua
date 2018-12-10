local parser = require 'parser'
local matcher = require 'matcher'

rawset(_G, 'TEST', true)

function TEST(res)
    return function (script)
        local start  = script:find('<?', 1, true)
        local finish = script:find('?>', 1, true)
        local pos = (start + finish) // 2 + 1
        local new_script = script:gsub('<[!?]', '  '):gsub('[!?]>', '  ')
        local ast = parser:ast(new_script)
        assert(ast)
        local results = matcher.compile(ast)
        assert(results)
        matcher.typeInference(results)
        local result = matcher.findResult(results, pos)
        assert(result)
        local var = result.var
        assert(var)
        assert(var.group)
        assert(var.group.type == res)
    end
end

TEST 'string' [[
local <?var?> = '111'
]]

TEST 'boolean' [[
local <?var?> = true
]]

TEST 'number' [[
local <?var?> = 1
]]
