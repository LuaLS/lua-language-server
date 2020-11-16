local core  = require 'core.highlight'
local files = require 'files'

local function catch_target(script)
    local list = {}
    local cur = 1
    while true do
        local start, finish  = script:find('<[!?].-[!?]>', cur)
        if not start then
            break
        end
        list[#list+1] = {
            start  = start + 2,
            finish = finish - 2,
        }
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
    for _, enter in ipairs(target) do
        local start, finish = enter.start, enter.finish
        files.removeAll()
        local pos = (start + finish) // 2 + 1
        local new_script = script:gsub('<[!?~]', '  '):gsub('[!?~]>', '  ')
        files.setText('', new_script)

        local positions = core('', pos)
        if positions then
            assert(founded(target, positions))
        else
            assert(#target == 0)
        end
    end
end

TEST [[
local <!a!> = 1
]]

TEST [[
local <!a!> = 1
<!a!> = 2
<!a!> = <!a!>
]]

TEST [[
t.<!a!> = 1
a = t.<!a!>
]]

TEST [[
<!a!> = <!a!>
<!a!> = <!a!>
]]

TEST [[
t = {
    [<!"a"!>] = 1,
    <!a!> = 1,
}
t[<!'a'!>] = 1
a = t.<!a!>
]]

TEST [[
:: <!a!> ::
goto <!a!>
]]

TEST [[
local function f(<!a!>)
    return <!a!>
end
]]

TEST [[
local s = <!'asd/gadasd.fad.zxczg'!>
]]

TEST [[
local b = <!true!>
]]

TEST [[
local n = <!nil!>
]]

TEST [[
local n = <!1.2354!>
]]

TEST [[
local <!function!> f () <!end!>
]]

TEST [[
<!function!> f () <!end!>
]]

TEST [[
return <!function!> () <!end!>
]]

TEST [[
<!if!> true <!then!>
<!elseif!> true <!then!>
<!elseif!> true <!then!>
<!else!>
<!end!>
]]

TEST [[
<!for!> _ <!in!> _ <!do!>
<!end!>
]]

TEST [[
<!for!> i = 1, 10 <!do!>
<!end!>
]]

TEST [[
<!while!> true <!do!>
<!end!>
]]

TEST [[
<!repeat!>
<!until!> true
]]

TEST [[
<!do!>
<!end!>
]]

TEST [[
<!TEST1!> = 1
TEST2 = 2
]]
