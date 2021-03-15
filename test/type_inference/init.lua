local files  = require 'files'
local config = require 'config'
local vm     = require 'vm'
local guide  = require 'core.guide'

rawset(_G, 'TEST', true)

local function getSource(pos)
    local ast = files.getAst('')
    return guide.eachSourceContain(ast.ast, pos, function (source)
        if source.type == 'local'
        or source.type == 'getlocal'
        or source.type == 'setlocal'
        or source.type == 'setglobal'
        or source.type == 'getglobal'
        or source.type == 'field'
        or source.type == 'method' then
            return source
        end
    end)
end

function TEST(wanted)
    return function (script)
        files.removeAll()
        local start  = script:find('<?', 1, true)
        local finish = script:find('?>', 1, true)
        local pos = (start + finish) // 2 + 1
        local newScript = script:gsub('<[!?]', '  '):gsub('[!?]>', '  ')
        files.setText('', newScript)
        local source = getSource(pos)
        assert(source)
        local result = vm.getInferType(source, 0)
        assert(wanted == result)
    end
end

TEST 'string' [[
local <?var?> = '111'
]]

TEST 'boolean' [[
local <?var?> = true
]]

TEST 'integer' [[
local <?var?> = 1
]]

TEST 'number' [[
local <?var?> = 1.0
]]

TEST 'string' [[
local var = '111'
t.<?x?> = var
]]

TEST 'string' [[
local <?var?>
var = '111'
]]

TEST 'string' [[
local var
var = '111'
print(<?var?>)
]]

TEST 'function' [[
function <?xx?>()
end
]]

TEST 'function' [[
local function <?xx?>()
end
]]

TEST 'function' [[
local xx
<?xx?> = function ()
end
]]

TEST 'table' [[
local <?t?> = {}
]]

TEST 'any' [[
<?x?>()
]]

TEST 'table' [[
<?t?>.x = 1
]]

TEST 'boolean' [[
<?x?> = not y
]]

TEST 'integer' [[
<?x?> = #y
]]

TEST 'number' [[
<?x?> = - y
]]

TEST 'integer' [[
<?x?> = ~ y
]]

TEST 'integer' [[
local a = true
local b = 1
<?x?> = a and b
]]

TEST 'integer' [[
local a = false
local b = 1
<?x?> = a or b
]]

TEST 'boolean' [[
<?x?> = a == b
]]

TEST 'integer' [[
<?x?> = a << b
]]

TEST 'string' [[
<?x?> = a .. b
]]

TEST 'number' [[
<?x?> = a + b
]]

TEST 'tablelib' [[
<?table?>()
]]

TEST 'string' [[
<?x?> = _VERSION
]]

TEST 'function' [[
return ('x').<?sub?>
]]

TEST 'function' [[
<?x?> = ('x').sub
]]

TEST 'function' [[
<?x?> = _VERSION.sub
]]

TEST 'table' [[
<?x?> = setmetatable({})
]]

TEST 'integer' [[
local function x()
    return 1
end
<?y?> = x()
]]

TEST 'integer|nil' [[
local function x()
    return 1
    return nil
end
<?y?> = x()
]]

TEST 'any' [[
local function x()
    return a
    return nil
end
<?y?> = x()
]]

TEST 'integer' [[
local function x()
    return 1
end
_, <?y?> = pcall(x)
]]

TEST 'integer' [[
function x()
    return 1
end
_, <?y?> = pcall(x)
]]

TEST 'oslib' [[
local <?os?> = require 'os'
]]

TEST 'string|table' [[
local y = #<?x?>
]]

TEST 'integer' [[
local y = <?x?> << 0
]]

TEST 'integer' [[
local function f(<?a?>, b)
    return a << b
end
]]

TEST 'string' [[
local function f()
    return string.sub()
end

local <?x?> = f()
]]

-- 不根据调用者的输入参数来推测
--TEST 'number' [[
--local function x(a)
--    return <?a?>
--end
--x(1)
--]]

--TEST 'table' [[
--setmetatable(<?b?>)
--]]

TEST 'function' [[
string.<?sub?>()
]]

TEST 'function' [[
(''):<?sub?>()
]]

-- 不根据对方函数内的使用情况来推测
TEST 'any' [[
local function x(a)
    _ = a + 1
end
local b
x(<?b?>)
]]

TEST 'any' [[
local function x(a, ...)
    local _, <?b?>, _ = ...
end
x(nil, 'xx', 1, true)
]]

-- 引用不跨越参数
TEST 'any' [[
local function x(a, ...)
    return true, 'ss', ...
end
local _, _, _, <?b?>, _ = x(nil, true, 1, 'yy')
]]

-- TODO 暂不支持这些特殊情况，之后用其他语法定义
--TEST 'integer' [[
--for <?i?> in ipairs(t) do
--end
--]]

TEST 'any' [[
local <?x?> = next()
]]

TEST 'any' [[
local a, b
function a()
    return b()
end
function b()
    return a()
end
local <?x?> = a()
]]

TEST 'class' [[
---@class class
local <?x?>
]]

TEST 'string' [[
---@type string
local <?x?>
]]

TEST 'string[]' [[
---@type string[]
local <?x?>
]]

TEST 'string|table' [[
---@type string | table
local <?x?>
]]

TEST '"enum1"|"enum2"' [[
---@type '"enum1"' | '"enum2"'
local <?x?>
]]

TEST 'function' [[
---@type fun()
local <?x?>
]]

TEST 'table<string, number>' [[
---@type table<string, number>
local <?x?>
]]

TEST 'table' [[
self.<?t?>[#self.t+1] = {}
]]

TEST 'string' [[
---@type string[]
local x
local <?y?> = x[1]
]]

TEST 'string' [[
---@return string[]
local function f() end
local x = f()
local <?y?> = x[1]
]]

TEST 'table' [[
local <?t?>
print(t.sub())
]]

TEST 'string|table' [[
local <?t?>
print(t:sub())
]]

TEST 'string' [[
local <?t?>
print(t:sub())
print(t .. 'a')
]]

TEST 'string' [[
local <?t?>
print(#t)
print(t .. 'a')
]]

TEST 'table' [[
local t = {}
local <?v?> = setmetatable(t)
]]

TEST 'CCC' [[
---@class CCC

---@type table<string, CCC>
local t = {}

print(t.<?a?>)
]]

TEST '"aaa"|"bbb"' [[
---@type table<string, '"aaa"'|'"bbb"'>
local t = {}

print(t.<?a?>)
]]

TEST 'integer' [[
for <?i?> in ipairs() do
end
]]

TEST 'table<string, boolean>' [[
---@generic K, V
---@param t table<K, V>
---@return K
---@return V
local function next(t) end

---@type table<string, boolean>
local t
local k, v = next(<?t?>)
]]

TEST 'string' [[
---@generic K, V
---@param t table<K, V>
---@return K
---@return V
local function next(t) end

---@type table<string, boolean>
local t
local <?k?>, v = next(t)
]]

TEST 'boolean' [[
---@generic K, V
---@param t table<K, V>
---@return K
---@return V
local function next(t) end

---@type table<string, boolean>
local t
local k, <?v?> = next(t)
]]

TEST 'boolean' [[
---@generic K
---@type fun(arg: K):K
local f

local <?r?> = f(true)
]]

TEST 'string' [[
---@generic K, V
---@type fun(arg: table<K, V>):K, V
local f

---@type table<string, boolean>
local t

local <?k?>, v = f(t)
]]

TEST 'boolean' [[
---@generic K, V
---@type fun(arg: table<K, V>):K, V
local f

---@type table<string, boolean>
local t

local k, <?v?> = f(t)
]]

TEST 'function' [[
---@return fun()
local function f() end

local <?r?> = f()
]]

TEST 'table<string, boolean>' [[
---@return table<string, boolean>
local function f() end

local <?r?> = f()
]]

TEST 'string' [[
---@generic K, V
---@return fun(arg: table<K, V>):K, V
local function f() end

local f2 = f()

---@type table<string, boolean>
local t

local <?k?>, v = f2(t)
]]

TEST 'string' [[
---@generic T: table, K, V
---@param t T
---@return fun(table: table<K, V>, index: K):K, V
---@return T
---@return nil
local function pairs(t) end

local f = pairs(t)

---@type table<string, boolean>
local t

for <?k?>, v in f, t do
end
]]

TEST 'boolean' [[
---@generic T: table, K, V
---@param t T
---@return fun(table: table<K, V>, index: K):K, V
---@return T
---@return nil
local function pairs(t) end

local f = pairs(t)

---@type table<string, boolean>
local t

for k, <?v?> in f, t do
end
]]

TEST 'string' [[
---@generic T: table, K, V
---@param t T
---@return fun(table: table<K, V>, index: K):K, V
---@return T
---@return nil
local function pairs(t) end

---@type table<string, boolean>
local t

for <?k?>, v in pairs(t) do
end
]]

TEST 'boolean' [[
---@generic T: table, K, V
---@param t T
---@return fun(table: table<K, V>, index: K):K, V
---@return T
---@return nil
local function pairs(t) end

---@type table<string, boolean>
local t

for k, <?v?> in pairs(t) do
end
]]

TEST 'boolean' [[
---@generic T: table, V
---@param t T
---@return fun(table: V[], i?: integer):integer, V
---@return T
---@return integer i
local function ipairs(t) end

---@type boolean[]
local t

for _, <?v?> in ipairs(t) do
end
]]

TEST 'boolean' [[
---@generic T: table, K, V
---@param t T
---@return fun(table: table<K, V>, index: K):K, V
---@return T
---@return nil
local function pairs(t) end

---@type boolean[]
local t

for k, <?v?> in pairs(t) do
end
]]

TEST 'integer' [[
---@generic T: table, K, V
---@param t T
---@return fun(table: table<K, V>, index: K):K, V
---@return T
---@return nil
local function pairs(t) end

---@type boolean[]
local t

for <?k?>, v in pairs(t) do
end
]]

TEST 'E' [[
---@class A
---@class B: A
---@class C: B
---@class D: C

---@class E: D
local m

function m:f()
    return <?self?>
end
]]
