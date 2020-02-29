local core = require 'core'
local parser  = require 'parser'
local buildVM = require 'vm'

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
    if #targets ~= #results then
        return false
    end
    for _, target in ipairs(targets) do
        for _, result in ipairs(results) do
            if target[1] == result[1] and target[2] == result[2] then
                goto NEXT
            end
        end
        do return false end
        ::NEXT::
    end
    return true
end

function TEST(script)
    local target = catch_target(script)
    local start  = script:find('<?', 1, true)
    local finish = script:find('?>', 1, true)
    local pos = (start + finish) // 2 + 1
    local new_script = script:gsub('<[!?]', '  '):gsub('[!?]>', '  ')
    local ast = parser:parse(new_script, 'lua', 'Lua 5.3')
    assert(ast)
    local vm = buildVM(ast)
    assert(vm)

    local positions = core.definition(vm, pos, 'definition')
    if positions then
        assert(founded(target, positions))
    else
        assert(#target == 0)
    end
end

require 'definition.set'
require 'definition.local'
require 'definition.arg'
require 'definition.function'
require 'definition.table'
require 'definition.method'
require 'definition.label'
require 'definition.bug'
require 'definition.emmy'
