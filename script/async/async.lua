local thread = require 'bee.thread'
local errlog = thread.channel 'errlog'

local TaskId = 0
local IdlePool = {}
local RunningList = {}
local GCInfo = {}

thread.newchannel 'gc'

local function createTask(name)
    TaskId = TaskId + 1
    GCInfo[TaskId] = false
    local id = TaskId
    local requestName  = 'request'  .. tostring(id)
    local responseName = 'response' .. tostring(id)
    thread.newchannel(requestName)
    thread.newchannel(responseName)
    local buf = ([[
ID             = %d
package.cpath  = %q
package.path   = %q
local thread   = require 'bee.thread'
local request  = thread.channel(%q)
local response = thread.channel(%q)
local errlog   = thread.channel 'errlog'
local gc       = thread.channel 'gc'

local function task()
    local dump, path, arg = request:bpop()
    local env = setmetatable({
        IN  = request,
        OUT = response,
        ERR = errlog,
        GC  = gc,
    }, { __index = _ENV })
    local f, err = load(dump, '@'..path, 't', env)
    if not f then
        errlog:push(err .. '\n' .. dump)
        return
    end
    local result = f(arg)
    response:push(result)
end

while true do
    local ok, result = xpcall(task, debug.traceback)
    if not ok then
        errlog:push(result)
    end
    collectgarbage()
    gc:push(ID, collectgarbage 'count')
end
]]):format(id, package.cpath, package.path, requestName, responseName)
    log.debug('Create thread, id: ', id, 'task: ', name)
    return {
        id       = id,
        thread   = thread.thread(buf),
        request  = thread.channel(requestName),
        response = thread.channel(responseName),
    }
end

local function run(name, arg, callback)
    local path = ROOT / 'script' / 'async' / (name .. '.lua')
    local dump = io.load(path)
    if not dump then
        error(('找不到[%s]'):format(name))
    end
    local task = table.remove(IdlePool)
    if not task then
        task = createTask(name)
    end
    RunningList[task.id] = {
        task     = task,
        callback = callback,
    }
    task.request:push(dump, path:string(), arg)
    -- TODO 线程回收后禁止外部再使用通道
    return task.request, task.response
end

local function callback(id, running)
    if running.callback then
        while true do
            local results = table.pack(running.task.response:pop())
            if not results[1] then
                break
            end
            -- TODO 封装成对象
            local suc, destroy = xpcall(running.callback, log.error, table.unpack(results, 2))
            if not suc or destroy then
                RunningList[id] = nil
                IdlePool[#IdlePool+1] = running.task
                break
            end
        end
    end
end

local function checkGC()
    local gc = thread.channel 'gc'
    while true do
        local ok, id, count = gc:pop()
        if not ok then
            break
        end
        GCInfo[id] = count
    end
end

local function onTick()
    local ok, msg = errlog:pop()
    if ok then
        log.error(msg)
    end
    for id, running in pairs(RunningList) do
        callback(id, running)
    end
    checkGC()
end

return {
    onTick = onTick,
    run    = run,
    info   = GCInfo,
}
