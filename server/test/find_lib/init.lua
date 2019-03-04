local core    = require 'core'
local parser  = require 'parser'
local buildVM = require 'vm'

rawset(_G, 'TEST', true)

function TEST(fullkey)
    return function (script)
        local start  = script:find('<?', 1, true)
        local finish = script:find('?>', 1, true)
        local pos = (start + finish) // 2 + 1
        local new_script = script:gsub('<[!?]', '  '):gsub('[!?]>', '  ')
        local ast = parser:ast(new_script)
        assert(ast)
        local vm = buildVM(ast)
        assert(vm)
        local source = core.findSource(vm, pos)
        local _, name = core.findLib(source)
        assert(name == fullkey)
    end
end

TEST 'require' [[
<?require?> 'xxx'
]]

TEST 'require' [[
local <?req?> = require
]]

TEST 'require' [[
local req = require
local t = {
    xx = req,
}
t[<?'xx'?>]()
]]

TEST 'table' [[
<?table?>.unpack()
]]

TEST 'table' [[
local <?xx?> = require 'table'
]]

TEST 'table' [[
local rq = require
local lib = 'table'
local <?xx?> = rq(lib)
]]

TEST 'table.insert' [[
table.<?insert?>()
]]

TEST 'table.insert' [[
local t = table
t.<?insert?>()
]]

TEST 'table.insert' [[
local insert = table.insert
<?insert?>()
]]

TEST 'table.insert' [[
local t = require 'table'
t.<?insert?>()
]]

TEST 'table.insert' [[
require 'table'.<?insert?>()
]]

TEST '*string:sub' [[
local str = 'xxx'
str.<?sub?>()
]]

TEST '*string:sub' [[
local str = 'xxx'
str:<?sub?>(1, 1)
]]

TEST '*string:sub' [[
('xxx').<?sub?>()
]]

TEST 'bee::filesystem' [[
local <?fs?> = require 'bee.filesystem'
]]

TEST 'fs.current_path' [[
local filesystem = require 'bee.filesystem'

ROOT = filesystem.<?current_path?>()
]]

TEST(nil)[[
print(<?insert?>)
]]

TEST '_G' [[
local x = <?_G?>
]]
