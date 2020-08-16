local files  = require 'files'
local config = require 'config'
local vm     = require 'vm'
local guide  = require 'parser.guide'

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
        local result = vm.getType(source)
        assert(wanted == result)
    end
end

config.config.runtime.version = 'Lua 5.4'

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

TEST 'function' [[
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

TEST 'table' [[
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

-- 不根据调用者的输入参数来推测
--TEST 'number' [[
--local function x(a)
--    return <?a?>
--end
--x(1)
--]]

TEST 'table' [[
setmetatable(<?b?>)
]]

TEST 'function' [[
string.<?sub?>()
]]

TEST 'function' [[
(''):<?sub?>()
]]

-- 不根据对方函数内的使用情况来推测
--TEST 'number' [[
--local function x(a)
--    _ = a + 1
--end
--local b
--x(<?b?>)
--]]

--TEST 'number' [[
--local function x(a, ...)
--    local _, <?b?>, _ = ...
--end
--x(nil, 'xx', 1, true)
--]]

-- 引用不跨越参数
--TEST 'number' [[
--local function x(a, ...)
--    return true, 'ss', ...
--end
--local _, _, _, <?b?>, _ = x(nil, true, 1, 'yy')
--]]

-- 暂不支持这些特殊情况，之后用其他语法定义
--TEST 'integer' [[
--for <?i?> in ipairs(t) do
--end
--]]
--
--TEST 'any' [[
--local <?x?> = next()
--]]
