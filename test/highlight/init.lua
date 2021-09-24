local core  = require 'core.highlight'
local files = require 'files'
local catch = require 'catch'

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
    files.removeAll()
    local newScript, catched = catch(script, '!')
    files.setText('', newScript)
    for _, enter in ipairs(catched['!']) do
        local start, finish = enter[1], enter[2]
        local pos = (start + finish) // 2
        local positions = core('', pos)
        local results = {}
        for _, position in ipairs(positions) do
            results[#results+1] = { position.start, position.finish }
        end
        assert(founded(catched['!'], results))
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
