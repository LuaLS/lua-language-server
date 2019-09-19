local boss       = require 'boss'
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
            local proto = boss.task('loadProto')
            log.debug('proto:', utility.dump(proto))
        end
    end)
end

function m.listenPub()
    task.create(function ()
        while true do
            boss.checkDead()
            boss.recieve()
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
    boss.recruitBraves(4)
    task.setErrorHandle(log.error)
    m.listenProto()
    m.listenPub()

    m.startTimer()
end

return m
