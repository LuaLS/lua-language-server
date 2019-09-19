local client = require 'pub.client'
local thread = require 'bee.thread'

local m = {}
m.type = 'service'

function m:start()
    client:recruitBraves(4)
end

return m
