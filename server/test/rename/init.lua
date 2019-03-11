local core = require 'core'
local parser  = require 'parser'
local buildVM = require 'vm'

local function catch_target(script)
    local list = {}
    local cur = 1
    while true do
        local start, finish  = script:find('<[!?].-[!?]>', cur)
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

function TEST(newName)
    return function (script)
        local target = catch_target(script)
        local start  = script:find('<?', 1, true)
        local finish = script:find('?>', 1, true)
        local pos = (start + finish) // 2 + 1
        local new_script = script:gsub('<[!?]', '  '):gsub('[!?]>', '  ')
        local ast = parser:ast(new_script)
        assert(ast)
        local vm = buildVM(ast)
        assert(vm)

        local positions = core.rename(vm, pos, newName)
        if positions then
            assert(founded(target, positions))
        else
            assert(#target == 0)
        end
    end
end

TEST 'b' [[
local <?a?> = 1
]]

TEST 'b' [[
local <?a?> = 1
<!a!> = 2
<!a!> = <!a!>
]]

TEST 'b' [[
t.<?a?> = 1
a = t.<!a!>
]]

TEST 'b' [[
t[<!'a'!>] = 1
a = t.<?a?>
]]

TEST 'b' [[
:: <?a?> ::
goto <!a!>
]]

TEST 'b' [[
local function f(<!a!>)
    return <?a?>
end
]]
