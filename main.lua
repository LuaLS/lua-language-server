local fs        = require 'bee.filesystem'

---@class LuaLS
luals = {}

luals.util    = require 'tools.utility'
luals.inspect = require 'tools.inspect'
luals.json    = require 'tools.json'
package.loaded['json'] = luals.json
require 'tools.json-beautify'
require 'tools.jsonc'
require 'tools.json-edit'

--语言服务器自身的状态
---@class LuaLS.Runtime
luals.runtime = require 'runtime.lua'

local currentPath = debug.getinfo(1, 'S').source:sub(2)
local rootPath    = currentPath:gsub('[/\\]*[^/\\]-$', '')
rootPath = (rootPath == '' and '.' or rootPath)
ROOT     = fs.path(util.expandPath(rootPath))
LOGPATH  = LOGPATH  and util.expandPath(LOGPATH)  or (ROOT:string() .. '/log')
METAPATH = METAPATH and util.expandPath(METAPATH) or (ROOT:string() .. '/meta')

---@diagnostic disable-next-line: deprecated
debug.setcstacklimit(200)
collectgarbage('generational', 10, 50)
--collectgarbage('incremental', 120, 120, 0)

---@diagnostic disable-next-line: lowercase-global
log = require 'log'
log.init(ROOT, fs.path(LOGPATH) / 'service.log')
if LOGLEVEL then
    log.level = tostring(LOGLEVEL):lower()
end

log.info('Lua Lsp startup, root: ', ROOT)
log.info('ROOT:', ROOT:string())
log.info('LOGPATH:', LOGPATH)
log.info('METAPATH:', METAPATH)
log.info('VERSION:', version.getVersion())

require 'tracy'

xpcall(dofile, log.debug, (ROOT / 'debugger.lua'):string())

require 'cli'

local _, service = xpcall(require, log.error, 'service')

service.start()
