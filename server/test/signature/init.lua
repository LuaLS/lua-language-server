local parser = require 'parser'
local core = require 'core'
local buildVM = require 'vm'

rawset(_G, 'TEST', true)

function TEST(script)
    return function (expect)
        local pos = script:find('$', 1, true)
        local new_script = script:gsub('%$', '')
        local ast = parser:parse(new_script, 'lua', 'Lua 5.3')
        local vm = buildVM(ast)
        assert(vm)
        local hovers = core.signature(vm, pos)
        if hovers then
            assert(expect)
            local hover = hovers[#hovers]

            local label = hover.label:gsub('^[\r\n]*(.-)[\r\n]*$', '%1'):gsub('\r\n', '\n')
            expect.label = expect.label:gsub('^[\r\n]*(.-)[\r\n]*$', '%1'):gsub('\r\n', '\n')
            local arg = hover.argLabel

            assert(expect.label == label)
            assert(expect.arg[1] == arg[1])
            assert(expect.arg[2] == arg[2])
        else
            assert(expect == nil)
        end
    end
end

TEST [[
local function x(a, b)
end

x($
]]
{
    label = "x(a: any, b: any)",
    arg = {3, 8},
}

TEST [[
local function x(a, b)
end

x($)
]]
{
    label = "x(a: any, b: any)",
    arg = {3, 8},
}

TEST [[
local function x(a, b)
end

x(xxx$)
]]
{
    label = "x(a: any, b: any)",
    arg = {3, 8},
}

TEST [[
local function x(a, b)
end

x(xxx, $)
]]
{
    label = "x(a: any, b: any)",
    arg = {11, 16},
}

TEST [[
function mt:f(a)
end

mt:f($
]]
{
    label = 'mt:f(a: any)',
    arg = {6, 11},
}

TEST [[
(''):sub($
]]
{
    label = [[
*string:sub(i: integer [, j: integer(-1)])
]],
    arg = {13, 22},
}

TEST [[
(''):sub(1)$
]]
(nil)

TEST [[
local function f(a, b, c)
end

f(1, 'string$')
]]
(nil)

TEST [[
pcall(function () $ end)
]]
(nil)

TEST [[
table.unpack {$}
]]
(nil)

TEST [[
---@type fun(x: number, y: number):boolean
local zzzz
zzzz($)
]]
{
    label = [[
zzzz(x: number, y: number)
]],
    arg = {6, 14},
}

TEST [[
('abc'):format(f($))
]]
(nil)
