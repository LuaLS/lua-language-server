local parser = require 'parser'
local core = require 'core'

rawset(_G, 'TEST', true)

function TEST(res)
    return function (script)
        local start  = script:find('<?', 1, true)
        local finish = script:find('?>', 1, true)
        local pos = (start + finish) // 2 + 1
        local new_script = script:gsub('<[!?]', '  '):gsub('[!?]>', '  ')
        local ast = parser:ast(new_script)
        local vm = core.vm(ast)
        assert(vm)
        local result = core.findResult(vm, pos)
        assert(result)
        assert(res == result.value:getType())
    end
end

TEST 'string' [[
local <?var?> = '111'
]]

TEST 'boolean' [[
local <?var?> = true
]]

TEST 'number' [[
local <?var?> = 1
]]

TEST 'string' [[
local var = '111'
t.<?x?> = var
]]

TEST 'string' [[
local <?var?>
var = '111'
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
local <?xx?>
xx = function ()
end
]]

TEST 'table' [[
local <?t?> = {}
]]

TEST 'table' [[
local <?t?>
t = {}
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

TEST 'number' [[
local a = true
local b = 1
<?x?> = a and b
]]

TEST 'number' [[
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
<?x?> = _VERSION.sub
]]

TEST 'table' [[
<?x?> = setmetatable({})
]]

TEST 'number' [[
local function x()
    return 1
end
<?y?> = x()
]]

TEST 'number' [[
local function x(a)
    return <?a?>
end
x(1)
]]

TEST 'table' [[
setmetatable(<?b?>)
]]

TEST 'number' [[
local function x(a)
    _ = a + 1
end
local b
x(<?b?>)
]]

TEST 'number' [[
local function x(a, ...)
    local _, <?b?>, _ = ...
end
x(nil, 'xx', 1, true)
]]

TEST 'number' [[
local function x(a, ...)
    return true, 'ss', ...
end
local _, _, _, <?b?>, _ = x(nil, true, 1, 'yy')
]]

TEST 'integer' [[
for <?i?> in ipairs(t) do
end
]]

TEST 'nil' [[
local <?x?> = next()
]]
