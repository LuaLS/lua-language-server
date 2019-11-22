local currentPath = debug.getinfo(1, 'S').source:sub(2)
local rootPath = currentPath:gsub('[/\\]*[^/\\]-$', '')
dofile(rootPath .. '/platform.lua')
local fs = require 'bee.filesystem'
ROOT = fs.path(rootPath)
LANG = LANG or 'en-US'

collectgarbage('generational', 10, 50)

log = require 'log'
log.init(ROOT, ROOT / 'log' / 'service.log')
log.info('Lua Lsp startup, root: ', ROOT)
log.debug('ROOT:', ROOT:string())

--loadfile(rootPath .. '/debugger.lua')'wait'
dofile(rootPath .. '/debugger.lua')

local service = require 'service'
service.start()
