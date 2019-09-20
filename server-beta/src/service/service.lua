local pub        = require 'pub'
local thread     = require 'bee.thread'
local task       = require 'task'
local timer      = require 'timer'
local proto      = require 'proto'

local m = {}
m.type = 'service'

function m.reportMemory()
    local mems = {}
    local totalMem = 0
    mems[0] = collectgarbage 'count'
    totalMem = totalMem + collectgarbage 'count'
    for id, brave in ipairs(pub.braves) do
        mems[id] = brave.memory
        totalMem = totalMem + brave.memory
    end

    local lines = {}
    lines[#lines+1] = '    --------------- Memory ---------------'
    lines[#lines+1] = ('        Total: %.3f MB'):format(totalMem / 1000.0)
    for i = 0, #mems do
        lines[#lines+1] = ('        # %02d : %.3f MB'):format(i, mems[i] / 1000.0)
    end
    return table.concat(lines, '\n')
end

function m.report()
    local t = timer.loop(60.0, function ()
        local lines = {}
        lines[#lines+1] = '========= Medical Examination Report ========='
        lines[#lines+1] = m.reportMemory()
        lines[#lines+1] = '=============================================='

        log.debug(table.concat(lines, '\n'))
    end)
    t:onTimer()
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
    pub.listen()
    m.report()

    m.startTimer()
end

return m
