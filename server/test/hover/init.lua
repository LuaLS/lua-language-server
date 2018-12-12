local parser = require 'parser'
local matcher = require 'matcher'

rawset(_G, 'TEST', true)

function TEST(script)
    local start  = script:find('<?', 1, true)
    local finish = script:find('?>', 1, true)
    local pos = (start + finish) // 2 + 1
    local new_script = script:gsub('<[!?]', '  '):gsub('[!?]>', '  ')
    local ast = parser:ast(new_script)
    local vm = matcher.vm(ast)
    assert(vm)
    local result = matcher.hover(vm, pos)
    assert(result)
end

TEST [[
local function <?x?>(a, b)
end
]]

TEST [[
local function x(a, b)
end
<?x?>()
]]

TEST [[
local mt = {}
mt.__index = mt

function mt:init(a, b, c)
    return {}
end

local obj = setmetatable({}, mt)

obj:<?init?>(1, '测试')
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

TEST [[
function obj.xxx()
end

obj.<?xxx?>()
]]

TEST [[
obj.<?xxx?>()
]]
