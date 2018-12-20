local thread = require 'bee.thread'
local errlog = thread.channel 'errlog'
local taskId = 0
local idlePool = {}
local runningList = {}

local function createTask()
    taskId = taskId + 1
    local id = taskId
    local requestName  = 'request'  .. tostring(id)
    local responseName = 'response' .. tostring(id)
    thread.newchannel(requestName)
    thread.newchannel(responseName)
    local buf = ([[
package.cpath  = %q
package.path   = %q
local thread   = require 'bee.thread'
local request  = thread.channel(%q)
local response = thread.channel(%q)
local errlog   = thread.channel 'errlog'

local function task()
    local dump, upvalues = request:bpop()
    local f, err = load(dump, '=request', 'b')
    if not f then
        errlog:push(err)
        return
    end
    for i, value in ipairs(upvalues) do
        debug.setupvalue(f, i+1, value)
    end
    local results = table.pack(pcall(f))
    local ok = table.remove(results, 1)
    if not ok then
        local err = table.remove(results, 1)
        errlog:push(err)
        return
    end
    results.n = results.n - 1
    response:push(results)
end

while true do
    task()
end
]]):format(package.cpath, package.path, requestName, responseName)
    log.debug('Create thread, id: ', id)
    return {
        id       = id,
        thread   = thread.thread(buf),
        request  = thread.channel(requestName),
        response = thread.channel(responseName),
    }
end

local function call(func, callback)
    local task = table.remove(idlePool)
    if not task then
        task = createTask()
    end
    local upvalues = {}
    local upId = 2 -- 跳过第一个上值 _ENV
    while true do
        local k, v = debug.getupvalue(func, upId)
        if not k then
            break
        end
        upvalues[#upvalues+1] = v
        upId = upId + 1
    end
    local dump = string.dump(func)
    runningList[task.id] = {
        task     = task,
        callback = callback,
    }
    task.request:push(dump, upvalues)
end

local function onTick()
    local ok, msg = errlog:pop()
    if ok then
        log.error(msg)
    end
    for id, running in pairs(runningList) do
        local ok, results = running.task.response:pop()
        if ok then
            runningList[id] = nil
            idlePool[#idlePool+1] = running.task
            xpcall(running.callback, log.debug, table.unpack(results))
        end
    end
end

return {
    onTick = onTick,
    call   = call,
}
