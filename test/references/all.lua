local core  = require 'core.reference'
local files = require 'files'

local function catch_target(script)
    local list = {}
    local cur = 1
    while true do
        local start, finish  = script:find('<[!?].-[!?]>', cur)
        if not start then
            break
        end
        list[#list+1] = { start + 2, finish - 2 }
        cur = finish + 1
    end
    return list
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
    files.removeAll()
    local expect = catch_target(script)
    local start  = script:find('<[?~]')
    local finish = script:find('[?~]>')
    local pos = (start + finish) // 2 + 1
    local new_script = script:gsub('<[!?~]', '  '):gsub('[!?~]>', '  ')
    files.setText('', new_script)

    local results = core('', pos)
    if results then
        local positions = {}
        for i, result in ipairs(results) do
            positions[i] = { result.target.start, result.target.finish }
        end
        assert(founded(expect, positions))
    else
        assert(#expect == 0)
    end
end

TEST [[
---@class A
local a = {}
a.<?x?> = 1

---@return A
local function f() end

local b = f()
return b.<!x!>
]]

TEST [[
---@class A
local a = {}
a.<?x?> = 1

---@return table
---@return A
local function f() end

local a, b = f()
return a.x, b.<!x!>
]]

TEST [[
local <?mt?> = {}
function <!mt!>:x()
    <!self!>:x()
end
]]

TEST [[
local mt = {}
function mt:<?x?>()
    self:<!x!>()
end
]]

TEST [[
---@class Dog
local mt = {}
function mt:<?eat?>()
end

---@class Master
local mt2 = {}
function mt2:init()
    ---@type Dog
    local foo = self:doSomething()
    ---@type Dog
    self.dog = getDog()
end
function mt2:feed()
    self.dog:<!eat!>()
end
function mt2:doSomething()
end
]]

-- 泛型的反向搜索
TEST [[
---@class Dog
local <?Dog?> = {}

---@generic T
---@param type1 T
---@return T
function foobar(type1)
end

local <!v1!> = foobar(<!Dog!>)
]]

TEST [[
---@class Dog
local Dog = {}
function Dog:<?eat?>()
end

---@generic T
---@param type1 T
---@return T
function foobar(type1)
    return {}
end

local v1 = foobar(Dog)
v1:<!eat!>()
]]

TEST [[
---@class Dog
local Dog = {}
function Dog:<?eat?>()
end

---@class Master
local Master = {}

---@generic T
---@param type1 string
---@param type2 T
---@return T
function Master:foobar(type1, type2)
    return {}
end

local v1 = Master:foobar("", Dog)
v1.<!eat!>()
]]

TEST [[
---@class A
local <?A?>

---@generic T
---@param self T
---@return T
function m.f(self) end

local <!b!> = m.f(<!A!>)
]]

TEST [[
---@class A
local <?A?>

---@generic T
---@param self T
---@return T
function m:f() end

local <!b!> = m.f(<!A!>)
]]

TEST [[
---@class A
local <?A?>

---@generic T
---@param self T
---@return T
function <!A!>.f(self) end

local <!b!> = <!A!>:f()
]]

TEST [[
---@class A
local <?A?>

---@generic T
---@param self T
---@return T
function <!A!>:f() end

local <!b!> = <!A!>:f()
]]

TEST [[
local function f()
    return <~<!function~> ()
    end!>
end

local <!f2!> = f()
]]

TEST [[
local function f()
    return nil, <~<!function~> ()
    end!>
end

local _, <!f2!> = f()
]]
