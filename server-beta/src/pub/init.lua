local pub = require 'pub.pub'

pub.on('log', function (params, brave)
    log.raw(brave.id, params.level, params.msg, params.src, params.line)
end)

return pub
