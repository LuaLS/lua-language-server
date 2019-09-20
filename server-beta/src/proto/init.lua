local proto   = require 'proto.proto'
local util    = require 'utility'

proto.on('initialize', function (params)
    log.debug(util.dump(params))
end)

return proto
