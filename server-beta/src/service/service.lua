local pub        = require 'pub'
local thread     = require 'bee.thread'
local task       = require 'task'
local timer      = require 'timer'
local proto      = require 'proto'

local m = {}
m.type = 'service'

function m.listenPub()
    task.create(function ()
        while true do
            pub.checkDead()
            pub.recieve()
            task.sleep(0)
        end
    end)
end

function m.startTimer()
    local last = os.clock()
    while true do
        thread.sleep(0.001)
        local current = os.clock()
        local delta = current - last
        last = current
        timer.update(delta)
    end
end

function m.start()
    pub.recruitBraves(4)
    task.setErrorHandle(log.error)
    proto.listen()
    m.listenPub()

    m.startTimer()
end

return m
