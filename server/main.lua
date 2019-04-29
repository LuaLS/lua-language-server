local fs = require 'bee.filesystem'

-- ROOT = fs.current_path()
local function get_script_path()
   local str = debug.getinfo(2, "S").source:sub(2)
   return str:match("(.*/)")
end

-- construct fs.path
ROOT = fs.path(get_script_path())

LANG = LANG or 'en-US'

package.path = (ROOT / 'src' / '?.lua'):string()
     .. ';' .. (ROOT / 'src' / '?' / 'init.lua'):string()
package.cpath = (ROOT / 'bin' / '?.so' ):string()

--collectgarbage('generational')
collectgarbage("setpause", 100)
collectgarbage("setstepmul", 1000)

log = require 'log'
log.init(ROOT, ROOT / 'log' / 'service.log')
log.info('Lua Lsp startup, root: ', ROOT)
ac = {}

local function tryDebugger()
     local dbg = require 'debugger'
     dbg:io 'listen:127.0.0.1:11411'
     dbg:start()
     log.info('Debugger startup, listen port: 11411')
end

--pcall(tryDebugger)

require 'utility'
require 'global_protect'
local service = require 'service'
local session = service()

session:listen()
