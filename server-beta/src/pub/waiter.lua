local thread = require 'bee.thread'

---@class pub_waiter
local mt = {}
mt.__index = mt
mt.type = 'pub.waiter'

return function (name)
    log.info('Create pub waiter:', name)
    thread.newchannel(name)
    local waiter = setmetatable({
        channel = thread.channel(name),
    }, mt)
    return waiter
end
