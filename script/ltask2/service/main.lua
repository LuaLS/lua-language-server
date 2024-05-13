local fs = require 'bee.filesystem'
local args = ...

ROOT     = fs.path(args.ROOT)
LOGPATH  = args.LOGPATH
METAPATH = args.METAPATH
LOGLEVEL = args.LOGLEVEL

require 'tracy'

---@diagnostic disable-next-line: lowercase-global
log = require 'log'
log.init(ROOT, fs.path(LOGPATH) / 'service.log')
if LOGLEVEL then
    log.level = tostring(LOGLEVEL):lower()
end

local _, service = xpcall(require, log.error, 'service')
service.start()
