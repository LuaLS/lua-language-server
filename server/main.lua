local currentPath = debug.getinfo(1, 'S').source:sub(2)
local rootPath = currentPath:gsub('[^/\\]-$', '')
package.cpath = rootPath .. 'bin/?.so'
      .. ';' .. rootPath .. 'bin/?.dll'
package.path  = rootPath .. 'src/?.lua'
      .. ';' .. rootPath .. 'src/?/init.lua'

local fs = require 'bee.filesystem'
ROOT = fs.path(rootPath)
LANG = LANG or 'en-US'

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
