local fs = require 'bee.filesystem'
ROOT = fs.current_path()
package.path = (ROOT / 'src' / '?.lua'):string()
     .. ';' .. (ROOT / 'src' / '?' / 'init.lua'):string()

log = require 'log'
log.init(ROOT, ROOT / 'log' / 'test.log')
log.info('Lua Lsp startup, root: ', ROOT)

local dbg = require 'debugger'
dbg:io 'listen:0.0.0.0:546858'
dbg:start()

require 'utility'
require 'global_protect'
local service = require 'service'
local session = service()

session:listen()
