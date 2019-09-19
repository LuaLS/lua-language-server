local thread = require 'bee.thread'

---@class pub_brave
local mt = {}
mt.__index = mt
mt.type = 'pub.brave'

return function (name)
    log.info('Create pub brave:', name)
    thread.newchannel(name)
    local brave = setmetatable({
        channel = thread.channel(name),
    }, mt)
    return brave
end
