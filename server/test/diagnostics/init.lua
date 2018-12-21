local matcher = require 'matcher'
local parser  = require 'parser'

rawset(_G, 'TEST', true)

local function catch_target(script)
    local list = {}
    local cur = 1
    local cut = 0
    while true do
        local start, finish  = script:find('<!.-!>', cur)
        if not start then
            break
        end
        list[#list+1] = { start - cut, finish - 4 - cut }
        cur = finish + 1
        cut = cut + 4
    end
    local new_script = script:gsub('<!(.-)!>', '%1')
    return new_script, list
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
    local new_script, target = catch_target(script)
    local ast = parser:ast(new_script)
    assert(ast)
    local lines = parser:lines(new_script)
    local vm = matcher.vm(ast)
    assert(vm)
    local datas = matcher.diagnostics(vm, lines, 'test')
    local results = {}
    for i, data in ipairs(datas) do
        results[i] = { data.start, data.finish }
    end

    if results[1] then
        if not founded(target, results) then
            error(('%s\n%s'):format(table.dump(target), table.dump(results)))
        end
    else
        assert(#target == 0)
    end
end

TEST [[
local <!x!>
]]

TEST [[
print(<!x!>)
print(log)
print(X)
print(Log)
print(_VERSION)
print(<!y!>)
print(z)
z = 1
]]

TEST [[
::<!LABEL!>::
]]

TEST [[
<!    !>
]]

TEST [[
x = 1<!  !>
]]

TEST [[
local x
print(x)
local <!x!>
print(x)
]]

TEST [[
local x
print(x)
local <!x!>
print(x)
local <!x!>
print(x)
]]

TEST [[
local x
print(x)
local x
print(x)
local x
print(x)
local x
print(x)
]]

TEST [[
local _
print(_)
local _
print(_)
local _ENV
print(_ENV)
]]

TEST [[
print(_G)
<!('string')!>:sub(1, 1)
]]

TEST [[
print(_G)
('string')
]]

TEST [[
local function x(a, b)
    return a, b
end
x(1, 2, <!3!>)
]]

TEST [[
instanceName = 1
instance = _G[instanceName]
]]

TEST [[
(''):sub(1, 2)
]]

-- TODO
--TEST [=[
--return [[   
--   
--]]
--]=]
