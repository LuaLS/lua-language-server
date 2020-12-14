local pub    = require 'pub'
local thread = require 'bee.thread'
local await  = require 'await'
local timer  = require 'timer'
local proto  = require 'proto'
local vm     = require 'vm'
local util   = require 'utility'

local m = {}
m.type = 'service'

local function countMemory()
    local mems = {}
    local total  = 0
    mems[0] = collectgarbage 'count'
    total = total + collectgarbage 'count'
    for id, brave in ipairs(pub.braves) do
        mems[id] = brave.memory
        total = total + brave.memory
    end
    return total, mems
end

function m.reportMemoryCollect()
    local totalMemBefore = countMemory()
    local clock = os.clock()
    collectgarbage()
    local passed = os.clock() - clock
    local totalMemAfter, mems  = countMemory()

    local lines = {}
    lines[#lines+1] = '    --------------- Memory ---------------'
    lines[#lines+1] = ('        Total: %.3f(%.3f) MB'):format(totalMemAfter / 1000.0, totalMemBefore / 1000.0)
    for i = 0, #mems do
        lines[#lines+1] = ('        # %02d : %.3f MB'):format(i, mems[i] / 1000.0)
    end
    lines[#lines+1] = ('        Collect garbage takes [%.3f] sec'):format(passed)
    return table.concat(lines, '\n')
end

function m.reportMemory()
    local totalMem, mems = countMemory()

    local lines = {}
    lines[#lines+1] = '    --------------- Memory ---------------'
    lines[#lines+1] = ('        Total: %.3f MB'):format(totalMem / 1000.0)
    for i = 0, #mems do
        lines[#lines+1] = ('        # %02d : %.3f MB'):format(i, mems[i] / 1000.0)
    end
    return table.concat(lines, '\n')
end

function m.reportTask()
    local total     = 0
    local running   = 0
    local suspended = 0
    local normal    = 0
    local dead      = 0

    for co in pairs(await.coMap) do
        total = total + 1
        local status = coroutine.status(co)
        if status == 'running' then
            running = running + 1
        elseif status == 'suspended' then
            suspended = suspended + 1
        elseif status == 'normal' then
            normal = normal + 1
        elseif status == 'dead' then
            dead = dead + 1
        end
    end

    local lines = {}
    lines[#lines+1] = '    --------------- Coroutine ---------------'
    lines[#lines+1] = ('        Total:     %d'):format(total)
    lines[#lines+1] = ('        Running:   %d'):format(running)
    lines[#lines+1] = ('        Suspended: %d'):format(suspended)
    lines[#lines+1] = ('        Normal:    %d'):format(normal)
    lines[#lines+1] = ('        Dead:      %d'):format(dead)
    return table.concat(lines, '\n')
end

function m.reportCache()
    local total = 0
    local dead  = 0

    for cache in pairs(vm.cacheTracker) do
        total = total + 1
        if cache.dead then
            dead = dead + 1
        end
    end

    local lines = {}
    lines[#lines+1] = '    --------------- Cache ---------------'
    lines[#lines+1] = ('        Total: %d'):format(total)
    lines[#lines+1] = ('        Dead:  %d'):format(dead)
    return table.concat(lines, '\n')
end

function m.reportProto()
    local holdon  = 0
    local waiting = 0

    for _ in pairs(proto.holdon) do
        holdon = holdon + 1
    end
    for _ in pairs(proto.waiting) do
        waiting = waiting + 1
    end

    local lines = {}
    lines[#lines+1] = '    --------------- Proto ---------------'
    lines[#lines+1] = ('        Holdon:   %d'):format(holdon)
    lines[#lines+1] = ('        Waiting:  %d'):format(waiting)
    return table.concat(lines, '\n')
end

function m.report()
    local t = timer.loop(60.0, function ()
        local lines = {}
        lines[#lines+1] = ''
        lines[#lines+1] = '========= Medical Examination Report ========='
        lines[#lines+1] = m.reportMemory()
        lines[#lines+1] = m.reportTask()
        lines[#lines+1] = m.reportCache()
        lines[#lines+1] = m.reportProto()
        lines[#lines+1] = '=============================================='

        log.debug(table.concat(lines, '\n'))
    end)
    t:onTimer()
end

function m.startTimer()
    while true do
        ::CONTINUE::
        pub.step()
        if await.step() then
            goto CONTINUE
        end
        thread.sleep(0.001)
        timer.update()
    end
end

function m.start()
    util.enableCloseFunction()
    await.setErrorHandle(log.error)
    pub.recruitBraves(4)
    proto.listen()
    m.report()

    require 'provider'

    m.startTimer()
end

return m
