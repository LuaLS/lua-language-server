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

TEST [[
function _(...)
    function _()
        print(<?...?>)
    end
end
]]

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
