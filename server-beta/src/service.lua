local client     = require 'pub.client'
local subprocess = require 'bee.subprocess'
local thread     = require 'bee.thread'
local task       = require 'task'
local utility    = require 'utility'

local m = {}
m.type = 'service'

function m:listenProto()
    subprocess.filemode(io.stdin,  'b')
    subprocess.filemode(io.stdout, 'b')
    io.stdin:setvbuf  'no'
    io.stdout:setvbuf 'no'
    coroutine.wrap(function ()
        while true do
            local proto = client:task('loadProto')
            log.debug('proto:', utility.dump(proto))
        end
    end)
end

function m:start()
    client:recruitBraves(4)
    self:listenProto()
end

return m
