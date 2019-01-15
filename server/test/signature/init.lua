local parser = require 'parser'
local core = require 'core'

rawset(_G, 'TEST', true)

function TEST(script)
    return function (expect)
        local pos = script:find('@', 1, true)
        local new_script = script:gsub('@', '')
        local ast = parser:ast(new_script)
        local vm = core.vm(ast)
        assert(vm)
        local hovers = core.signature(vm, pos)
        if hovers then
            local hover = hovers[#hovers]

            local label = hover.label:gsub('^[\r\n]*(.-)[\r\n]*$', '%1'):gsub('\r\n', '\n')
            expect.label = expect.label:gsub('^[\r\n]*(.-)[\r\n]*$', '%1'):gsub('\r\n', '\n')
            local arg = hover.argLabel

            assert(expect.label == label)
            assert(expect.arg == arg)
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
    arg = 'a: any'
}

TEST [[
local function x(a, b)
end

x(@)
]]
{
    label = "function x(a: any, b: any)",
    arg = 'a: any'
}

TEST [[
local function x(a, b)
end

x(xxx@)
]]
{
    label = "function x(a: any, b: any)",
    arg = 'a: any'
}

TEST [[
local function x(a, b)
end

x(xxx, @)
]]
{
    label = "function x(a: any, b: any)",
    arg = 'b: any'
}

TEST [[
function mt:f(a)
end

mt:f(@
]]
{
    label = 'function mt:f(a: any)',
    arg = 'a: any'
}

TEST [[
(''):sub(@
]]
{
    label = [[
function *string:sub(i: integer [, j: integer(-1)])
  -> string
]],
    arg = 'i: integer'
}

TEST [[
(''):sub(1)@
]]
(nil)
