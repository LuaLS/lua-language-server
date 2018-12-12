local parser = require 'parser'
local matcher = require 'matcher'

rawset(_G, 'TEST', true)

function TEST(script)
    return function (expect)
        local start  = script:find('<?', 1, true)
        local finish = script:find('?>', 1, true)
        local pos = (start + finish) // 2 + 1
        local new_script = script:gsub('<[!?]', '  '):gsub('[!?]>', '  ')
        local ast = parser:ast(new_script)
        local vm = matcher.vm(ast)
        assert(vm)
        local result = matcher.hover(vm, pos)
        assert(result)
        expect = expect:gsub('^[\r\n]*(.-)[\r\n]*$', '%1')
        result = result:gsub('```lua', ''):gsub('```', ''):gsub('^[\r\n]*(.-)[\r\n]*$', '%1')
        assert(expect == result)
    end
end

TEST [[
local function <?x?>(a, b)
end
]]
"function x(a: any, b: any)"

TEST [[
local function x(a, b)
end
<?x?>()
]]
"function x(a: any, b: any)"

TEST [[
local mt = {}
mt.__index = mt

function mt:init(a, b, c)
    return {}
end

local obj = setmetatable({}, mt)

obj:<?init?>(1, '测试')
]]
[[
function mt:init(a: number, b: string, c: any)
  -> table
]]

TEST [[
local mt = {}
mt.__index = mt

function mt:init(a, b, c)
    return {}
end

local obj = setmetatable({}, mt)

obj:init(1, '测试')
obj.<?init?>(obj, 1, '测试')
]]
[[
function mt.init(self: table, a: number, b: string, c: any)
  -> table
]]

TEST [[
function obj.xxx()
end

obj.<?xxx?>()
]]
"function obj.xxx()"

TEST [[
obj.<?xxx?>()
]]
"function obj.xxx()"

TEST [[
local <?x?> = 1
]]
"local: number"

TEST [[
<?x?> = 1
]]
"global: number"

TEST [[
local t = {}
t.<?x?> = 1
]]
"local field: number"

TEST [[
t = {}
t.<?x?> = 1
]]
"global field: number"

TEST [[
local mt = {}
mt.__name = 'class'

local <?obj?> = setmetatable({}, mt)
]]
"local: *class"

TEST [[
local mt = {}
mt.name = 'class'
mt.__index = mt

local <?obj?> = setmetatable({}, mt)
]]
"local: *class"

TEST [[
local mt = {}
mt.TYPE = 'class'
mt.__index = mt

local <?obj?> = setmetatable({}, mt)
]]
"local: *class"

TEST [[
local mt = {}
mt.Class = 'class'
mt.__index = mt

local <?obj?> = setmetatable({}, mt)
]]
"local: *class"
