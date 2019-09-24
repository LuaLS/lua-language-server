local pub = require 'pub.pub'

pub.on('log', function (params, brave)
    log.raw(brave.id, params.level, params.msg, params.src, params.line)
end)

pub.on('mem', function (count, brave)
    brave.memory = count
end)

pub.on('proto', function (params)
    local proto = require 'proto'
    if params.method then
        proto.doMethod(params)
    else
        proto.doResponse(params)
    end
end)

return pub
