local proto   = require 'proto.proto'
local util    = require 'utility'
local cap     = require 'proto.capability'

proto.on('initialize', function (params)
    log.debug(util.dump(params))
    return {
        capabilities = cap.initer,
    }
end)

proto.on('initialized', function (params)
    return true
end)

proto.on('exit', function ()
    log.info('Server exited.')
    os.exit(true)
end)

proto.on('shutdown', function ()
    log.info('Server shutdown.')
    return true
end)

proto.on('textDocument/hover', function ()
    return {
        contents = {
            value = 'Hello loli!',
            kind  = 'markdown',
        }
    }
end)

return proto
