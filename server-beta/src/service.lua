local pub    = require 'pub'
local thread = require 'bee.thread'

local m = {}
m.type = 'service'

function m:start()
    pub:build()
    pub:createTaskPads(4)
    pub:hireWaiters(4)
    pub:recruitBraves(4)
end

return m
