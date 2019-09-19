local thread = require 'bee.thread'

---@class pub_taskpad
local mt = {}
mt.__index = mt
mt.type = 'pub.taskpad'

return function (name)
    log.info('Create pub task pad:', name)
    thread.newchannel(name)
    local taskpad = setmetatable({
        channel = thread.channel(name),
    }, mt)
    return taskpad
end
