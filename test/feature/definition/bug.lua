TEST_DEF [[
local <!x!>
function _(x)
end
function _()
    <?x?>()
end
]]

TEST_DEF [[
function _(<!x!>)
    do return end
    <?x?>()
end
]]

TEST_DEF [[
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

TEST_DEF [[
local <!a!>
(<?a?> / b)()
]]

TEST_DEF [[
local <!args!>
io.load(root / <?args?>.source / 'API' / path)
]]

TEST_DEF [[
obj[#<?obj?>+1] = {}
]]

TEST_DEF [[
self = {
    <!results!> = {}
}
self[self.<?results?>] = lbl
]]

TEST_DEF [[
self = {
    results = {
        <!labels!> = {},
    }
}
self[self.results.<?labels?>] = lbl
]]

TEST_DEF [[
self.results = {
    <!labels!> = {},
}
self[self.results.<?labels?>] = lbl
]]

TEST_DEF [[
self.results.<!labels!> = {}
self[self.results.<?labels?>] = lbl
]]

TEST_DEF [[
local mt = {}
function mt:<!x!>()
end
mt:x()
mt:<?x?>()
]]

TEST_DEF [[
local function func(<!a!>)
    x = {
        xx(),
        <?a?>,
    }
end
]]

TEST_DEF [[
local <!x!>
local t = {
    ...,
    <?x?>,
}
]]

TEST_DEF [[
local a
local <!b!>
return f(), <?b?>
]]

TEST_DEF [[
local a = os.clock()
local <?<!b!>?> = os.clock()
]]

TEST_DEF [[
local mt = {}

function mt:<!add!>(a, b)
end

local function init()
    return mt
end

local t = init()
t:<?add?>()
]]

TEST_DEF [[
--!include setmetatable
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

TEST_DEF [[
local t = {}
t.f1 = 1
t.<!f2!> = t.f1

print(t.<?f2?>)
]]

TEST_DEF [[
local t = {}
t.f1 = 1
t.<!f2!> = t.f1
t.f1 = t.f2

print(t.<?f2?>)
]]

TEST_DEF [[
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

TEST_DEF [[
local A, B

function A:get1()
    local a = B:get()
    return a
end

function A:get2()
    local a = B:get()
    return a
end

function A:get3()
    local a = B:get()
    return a
end

function A:get4()
    local a = B:get()
    return a
end

function A:get5()
    local a = B:get()
    return a
end

function A:get6()
    local a = B:get()
    return a
end

function A:get7()
    local a = B:get()
    return a
end

function A:get8()
    local a = B:get()
    return a
end

function B:get()
    local b
    b = A:get1()
    b = A:get2()
    b = A:get3()
    b = A:get4()
    b = A:get5()
    b = A:get6()
    b = A:get7()
    b = A:get8()
    return b
end

local <!b!> = B:get()
print(<?b?>)
]]

TEST_DEF [[
g[a.b.c] = 1
print(g.<?x?>)
]]

TEST_DEF [[
local function f()
    return ''
end

local <?<!s!>?> = ''
]]

TEST_DEF [[
local t, a
local <!v!> = t[a]

t[a] = <?v?>
]]
