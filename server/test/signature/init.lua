local parser = require 'parser'
local core = require 'core'
local buildVM = require 'vm'

rawset(_G, 'TEST', true)

function TEST(script)
    return function (expect)
        local pos = script:find('@', 1, true)
        local new_script = script:gsub('@', '')
        local ast = parser:ast(new_script)
        local vm = buildVM(ast)
        assert(vm)
        local hovers = core.signature(vm, pos)
        if hovers then
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

x(@
]]
{
    label = "function x(a: any, b: any)",
    arg = {12, 17},
}

TEST [[
local function x(a, b)
end

x(@)
]]
{
    label = "function x(a: any, b: any)",
    arg = {12, 17},
}

TEST [[
local function x(a, b)
end

x(xxx@)
]]
{
    label = "function x(a: any, b: any)",
    arg = {12, 17},
}

TEST [[
local function x(a, b)
end

x(xxx, @)
]]
{
    label = "function x(a: any, b: any)",
    arg = {20, 25},
}

TEST [[
function mt:f(a)
end

mt:f(@
]]
{
    label = 'function mt:f(a: any)',
    arg = {15, 20},
}

TEST [[
(''):sub(@
]]
{
    label = [[
function *string:sub(i: integer [, j: integer(-1)])
  -> string
]],
    arg = {22, 31},
}

TEST [[
(''):sub(1)@
]]
(nil)
