local fs = require 'bee.filesystem'
local subprocess = require 'bee.subprocess'

ROOT = fs.current_path()
package.path = (ROOT / 'src' / '?.lua'):string()
     .. ';' .. (ROOT / 'src' / '?' / 'init.lua'):string()

local function runTest(root)
    local exe = root / 'bin' / 'lua-language-server'
    local test = root / 'test' / 'main.lua'
    local lua = subprocess.spawn {
        exe,
        test,
        '-E',
        stdout = true,
        stderr = true,
    }
    for line in lua.stdout:lines 'l' do
        print(line)
    end
    lua:wait()
    local err = lua.stderr:read 'a'
    if err ~= '' then
        error(err)
    end
end

runTest(ROOT)
