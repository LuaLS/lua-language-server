local core = require 'core.signature'
local files = require 'files'

rawset(_G, 'TEST', true)

function TEST(script)
    return function (expect)
        local pos = script:find('$', 1, true) - 1
        local new_script = script:gsub('%$', '')
        files.removeAll()
        files.setText('', new_script)
        local hovers = core('', pos)
        if hovers then
            assert(expect)
            local hover = hovers[#hovers]

            local label = hover.label:gsub('^[\r\n]*(.-)[\r\n]*$', '%1'):gsub('\r\n', '\n')
            expect.label = expect.label:gsub('^[\r\n]*(.-)[\r\n]*$', '%1'):gsub('\r\n', '\n')
            local arg = hover.params[hover.index].label

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
    label = "function x(a: any, b: any)",
    arg = {12, 17},
}

TEST [[
local function x(a, b)
end

x($)
]]
{
    label = "function x(a: any, b: any)",
    arg = {12, 17},
}

TEST [[
local function x(a, b)
end

x(xxx$)
]]
{
    label = "function x(a: any, b: any)",
    arg = {12, 17},
}

TEST [[
local function x(a, b)
end

x(xxx, $)
]]
{
    label = "function x(a: any, b: any)",
    arg = {20, 25},
}

TEST [[
function mt:f(a)
end

mt:f($
]]
{
    label = 'function mt:f(a: any)',
    arg = {15, 20},
}

TEST [[
local function x(a, b)
    return 1
end

x($
]]
{
    label = "function x(a: any, b: any)",
    arg = {12, 17},
}

TEST [[
local function x(a, ...)
    return 1
end

x(1, 2, 3, $
]]
{
    label = "function x(a: any, ...)",
    arg = {20, 22},
}

TEST [[
(''):sub($
]]
{
    label = [[
function string:sub(i: integer, j?: integer)
]],
    arg = {21, 30},
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
{
    label = [[
function f(a: any, b: any, c: any)
]],
    arg = {20, 25},
}

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
function zzzz(x: number, y: number)
]],
    arg = {15, 23},
}

TEST [[
('abc'):format(f($))
]]
(nil)

TEST [[
function Foo(param01, param02)

end

Foo($)
]]
{
    label = [[
function Foo(param01: any, param02: any)
]],
    arg = {14, 25},
}
