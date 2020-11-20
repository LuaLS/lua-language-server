local currentPath = debug.getinfo(1, 'S').source:sub(2)
local rootPath = currentPath:gsub('[/\\]*[^/\\]-$', '')
loadfile((rootPath == '' and '.' or rootPath) .. '/platform.lua')('script')
local fs = require 'bee.filesystem'
ROOT = fs.path(rootPath)
LANG = LANG or 'en-US'

debug.setcstacklimit(200)
collectgarbage('generational', 10, 100)
--collectgarbage('incremental', 120, 120, 0)

log = require 'log'
log.init(ROOT, ROOT / 'log' / 'service.log')
log.info('Lua Lsp startup, root: ', ROOT)
log.debug('ROOT:', ROOT:string())

xpcall(dofile, log.debug, rootPath .. '/debugger.lua')

local service = require 'service'

-- TODO
--ALL_DEEP = true
service.start()
