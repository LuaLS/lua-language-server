local config = require "config"

TEST [[
local <!x!>
function _(x)
end
function _()
    <?x?>()
end
]]

TEST [[
function _(<!x!>)
    do return end
    <?x?>()
end
]]

TEST [[
local <!a!>
function a:b()
    a:b()
    <?self?>()
end
]]

--TEST [[
--function _(...)
--    function _()
--        print(<?...?>)
--    end
--end
--]]

TEST [[
local <!a!>
(<?a?> / b)()
]]

TEST [[
local <!args!>
io.load(root / <?args?>.source / 'API' / path)
]]

TEST [[
obj[#<?obj?>+1] = {}
]]

TEST [[
self = {
    results = {
        <!labels!> = {},
    }
}
self[self.results.<?labels?>] = lbl
]]

TEST [[
self.results = {
    <!labels!> = {},
}
self[self.results.<?labels?>] = lbl
]]

TEST [[
self.results.<!labels!> = {}
self[self.results.<?labels?>] = lbl
]]

TEST [[
local mt = {}
function mt:<!x!>()
end
mt:x()
mt:<?x?>()
]]

TEST [[
local function func(<!a!>)
    x = {
        xx(),
        <?a?>,
    }
end
]]

TEST [[
local <!x!>
local t = {
    ...,
    <?x?>,
}
]]

TEST [[
local a
local <!b!>
return f(), <?b?>
]]

TEST [[
local a = os.clock()
local <?<!b!>?> = os.clock()
]]

TEST [[
local mt = {}

function mt:<!add!>(a, b)
end

local function init()
    return mt
end

local t = init()
t:<?add?>()
]]

TEST [[
local mt = {}
mt.__index = mt

function mt:<!add!>(a, b)
end

local function init()
    return setmetatable({}, mt)
end

local t = init()
t:<?add?>()
]]

TEST [[
local t = {}
t.<!f1!> = 1
t.<!f2!> = t.f1

print(t.<?f2?>)
]]

TEST [[
local t = {}
t.<!f1!> = 1
t.<!f2!> = t.f1
t.<!f1!> = t.f2

print(t.<?f2?>)
]]

TEST [[
---@type string
string.xx = ''
string.xx:<?format?>()
]]

--TEST [[
-----@class Foo
--Foo = {}
--function Foo:Constructor()
--    self.<!bar1!> = 1
--end
--
-----@class Foo2: Foo
--Foo2 = {}
--function Foo2:Constructor()
--end
--
-----@type Foo2
--local v
--v.<?bar1?>
--]]

config.set('Lua.IntelliSense.traceLocalSet', true)
TEST [[
local A, B

function A:get1()
    local <!a!> = B:get()
    return <!a!>
end

function A:get2()
    local <!a!> = B:get()
    return <!a!>
end

function A:get3()
    local <!a!> = B:get()
    return <!a!>
end

function A:get4()
    local <!a!> = B:get()
    return <!a!>
end

function A:get5()
    local <!a!> = B:get()
    return <!a!>
end

function A:get6()
    local <!a!> = B:get()
    return <!a!>
end

function A:get7()
    local <!a!> = B:get()
    return <!a!>
end

function A:get8()
    local <!a!> = B:get()
    return <!a!>
end

function B:get()
    local <!b!>
    <!b!> = A:get1()
    <!b!> = A:get2()
    <!b!> = A:get3()
    <!b!> = A:get4()
    <!b!> = A:get5()
    <!b!> = A:get6()
    <!b!> = A:get7()
    <!b!> = A:get8()
    return <!b!>
end

local <!b!> = B:get()
print(<?b?>)
]]
config.set('Lua.IntelliSense.traceLocalSet', false)

TEST [[
g[a.b.c] = 1
print(g.<?x?>)
]]

TEST [[
local function f()
    return ''
end

local <?<!s!>?> = ''
]]

TEST [[
local t, a
local <!v!> = t[a]

t[a] = <?v?>
]]
