local fs = require 'bee.filesystem'
local args = ...

ROOT     = fs.path(args.ROOT)
LOGPATH  = args.LOGPATH
METAPATH = args.METAPATH

local _, service = xpcall(require, log.error, 'service')

service.start()
