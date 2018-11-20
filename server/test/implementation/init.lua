local matcher = require 'matcher'

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

    local suc, result = matcher.implementation(new_script, pos)
    assert(suc)
    assert(founded(target, result))
end

require 'implementation.set'
require 'implementation.local'
require 'implementation.arg'
require 'implementation.function'
require 'implementation.if'
--require 'implementation.table'
require 'implementation.bug'
