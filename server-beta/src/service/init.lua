local service = require 'service.service'
local proto   = require 'service.proto'
local util    = require 'utility'

proto.on('initialize', function (params)
    log.debug(util.dump(params))
end)

return service
