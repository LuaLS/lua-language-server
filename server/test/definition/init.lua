local matcher = require 'matcher'
local parser  = require 'parser'

rawset(_G, 'TEST', true)

local function catch_target(script)
    local list = {}
    local cur = 1
    while true do
        local start, finish  = script:find('<!.-!>', cur)
        if not start then
            break
        end
        list[#list+1] = { start + 2, finish - 2 }
        cur = finish + 1
    end
    return list
end

local function founded(targets, results)
    while true do
        local target = table.remove(targets)
        if not target then
            break
        end
        for i, result in ipairs(results) do
            if target[1] == result[1] and target[2] == result[2] then
                table.remove(results, i)
                goto CONTINUE
            end
        end
        do return false end
        ::CONTINUE::
    end
    if #results == 0 then
        return true
    else
        return false
    end
end

function TEST(script)
    local target = catch_target(script)
    local pos    = script:find('<?', 1, true) + 2
    local new_script = script:gsub('<[!?]', '  '):gsub('[!?]>', '  ')
    local ast, err = parser:ast(new_script)
    assert(ast)

    local suc, result = matcher.definition(ast, pos)
    assert(suc)
    assert(founded(target, result))
end

require 'definition.set'
require 'definition.local'
require 'definition.arg'
require 'definition.function'
require 'definition.table'
require 'definition.method'
require 'definition.bug'
