local fs = require 'bee.filesystem'
local ENV, ARG = ...

for k, v in pairs(ARG) do
    _G[k] = v
end

ROOT     = fs.path(ENV.ROOT)
LOGPATH  = ENV.LOGPATH
METAPATH = ENV.METAPATH
LOGLEVEL = ENV.LOGLEVEL

require 'tracy'

---@diagnostic disable-next-line: lowercase-global
log = require 'log'
log.init(ROOT, fs.path(LOGPATH) / 'service.log')
if LOGLEVEL then
    log.level = tostring(LOGLEVEL):lower()
end

local version = require 'version'

log.info('Lua Lsp master startup, root: ', ROOT)
log.info('ROOT:', ROOT:string())
log.info('LOGPATH:', LOGPATH)
log.info('METAPATH:', METAPATH)
log.info('VERSION:', version.getVersion())

local _, service = xpcall(require, log.error, 'service')
service.start()
