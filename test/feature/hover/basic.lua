TEST_HOVER [[
---@type integer
local x
print(x<??>)
]] 'local x: integer'

TEST_HOVER [[
---@type string|integer
local x
print(x<??>)
]] ({
    'local x: string',
    'local x: integer',
})

TEST_HOVER [[
local function <?x?>(a, b)
end
]] 'function x(a: any, b: any)'

TEST_HOVER [[
local <?function?> x(a, b)
end
]] 'function x(a: any, b: any)'

TEST_HOVER [[
local function x(a, b)
end
<?x?>()
]] 'function x(a: any, b: any)'

TEST_HOVER [[
local mt = {}
mt.__index = mt

function mt:init(a, b, c)
    return
end

local obj = setmetatable({}, mt)

obj:<?init?>(1, '测试')
]] '(method) mt:init(a: any, b: any, c: any)'

TEST_HOVER [[
local mt = {}
mt.__index = mt

function mt:init(a, b, c)
    return {}
end

local obj = setmetatable({}, mt)

obj:<?init?>(1, '测试')
]] [[
(method) mt:init(a: any, b: any, c: any)
  -> table
]]

TEST_HOVER [[
local mt = {}
mt.__index = mt

function mt:init(a, b, c)
    return {}
end

local obj = setmetatable({}, mt)

obj:init(1, '测试')
obj.<?init?>(obj, 1, '测试')
]] [[
(method) mt:init(a: any, b: any, c: any)
  -> table
]]

TEST_HOVER [[
function obj.xxx()
end

obj.<?xxx?>()
]] 'function obj.xxx()'

TEST_HOVER [[
obj.<?xxx?>()
]] '(global) obj.xxx: unknown'

TEST_HOVER [[
local <?x?> = 1
]] 'local x: integer = 1'

TEST_HOVER [[
<?x?> = 1
]] '(global) x: integer = 1'

TEST_HOVER [[
local t = {}
t.<?x?> = 1
]] '(field) t.x: integer = 1'

TEST_HOVER [[
t = {}
t.<?x?> = 1
]] '(global) t.x: integer = 1'

TEST_HOVER [[
t = {
    <?x?> = 1
}
]] '(field) x: integer = 1'

TEST_HOVER [[
local <?obj?> = {}
]] 'local obj: table'

TEST_HOVER [[
local function x(a, ...)
end

<?x?>(1, 2, 3, 4, 5, 6, 7)
]] 'function x(a: any, ...any)'

TEST_HOVER [[
local <?t?> = - 1000
]] 'local t: integer = -1000'

TEST_HOVER [[
local <?n?>
table.pack(n)
]] 'local n: unknown'

TEST_HOVER [[
local x = 1
local y = x
print(<?y?>)
]] 'local y: integer = 1'

TEST_HOVER [[
function a(v)
    return 'a'
end
local <?r?> = a(1)
]] 'local r: string = "a"'

TEST_HOVER [[
local function <?f?>()
    return nil, nil
end
]] [[
function f()
  1. nil
  2. nil
]]

TEST_HOVER [[
local function f()
    return nil
end
local <?x?> = f()
]] 'local x: nil'

TEST_HOVER [[
local function x()
    return y()
end

<?x?>()
]] [[
function x()
  -> any
]]

TEST_HOVER [[
local function f()
    return ...
end
local <?n?> = f()
]] 'local n: unknown'

TEST_HOVER [[
local <?n?> = table.unpack(t)
]] 'local n: unknown'

TEST_HOVER [[
function F(a)
end
function F(b)
end
function F(a)
end
<?F?>()
]] 'function F(a: any)'

TEST_HOVER [[
local mt = {}
mt.__index = {}

function mt:test(a, b)
    self:<?test?>()
end
]] '(method) mt:test(a: any, b: any)'
