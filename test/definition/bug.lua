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

TEST [[
---@class Foo
Foo = {}
function Foo:Constructor()
    self.<!bar1!> = 1
end

---@class Foo2: Foo
Foo2 = {}
function Foo2:Constructor()
end

---@type Foo2
local v
v.<?bar1?>
]]
