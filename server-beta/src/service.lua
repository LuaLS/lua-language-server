local client     = require 'pub.client'
local subprocess = require 'bee.subprocess'
local thread     = require 'bee.thread'
local task       = require 'task'
local utility    = require 'utility'
local timer      = require 'timer'

local m = {}
m.type = 'service'

function m.listenProto()
    subprocess.filemode(io.stdin,  'b')
    subprocess.filemode(io.stdout, 'b')
    io.stdin:setvbuf  'no'
    io.stdout:setvbuf 'no'
    task.create(function ()
        while true do
            local proto = client.task('loadProto')
            log.debug('proto:', utility.dump(proto))
        end
    end)
end

function m.startTimer()
    local last = os.clock()
    while true do
        thread.sleep(0.01)
        local current = os.clock()
        local delta = current - last
        last = current
        m.update(delta)
    end
end

function m.start()
    client.recruitBraves(4)
    m.listenProto()

    m.startTimer()
end

return m
