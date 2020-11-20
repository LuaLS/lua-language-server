local thread  = require 'bee.thread'
local utility = require 'utility'
local await   = require 'await'
local timer   = require 'timer'

local errLog  = thread.channel 'errlog'
local type    = type
local counter = utility.counter()

local braveTemplate = [[
package.path  = %q
package.cpath = %q
DEVELOP = %s
DBGPORT = %d
DBGWAIT = %s

collectgarbage 'generational'

log         = require 'brave.log'

xpcall(dofile, log.error, %q)
local brave = require 'brave'
brave.register(%d)
]]

---@class pub
local m = {}
m.type = 'pub'
m.braves = {}
m.ability = {}
m.taskQueue = {}

--- 注册酒馆的功能
function m.on(name, callback)
    m.ability[name] = callback
end

--- 招募勇者，勇者会从公告板上领取任务，完成任务后到看板娘处交付任务
---@param num integer
function m.recruitBraves(num)
    for _ = 1, num do
        local id = #m.braves + 1
        log.info('Create brave:', id)
        thread.newchannel('taskpad' .. id)
        thread.newchannel('waiter'  .. id)
        m.braves[id] = {
            id      = id,
            taskpad = thread.channel('taskpad' .. id),
            waiter  = thread.channel('waiter'  .. id),
            thread  = thread.thread(braveTemplate:format(
                package.path,
                package.cpath,
                DEVELOP,
                DBGPORT or 11412,
                DBGWAIT or 'nil',
                (ROOT / 'debugger.lua'):string(),
                id
            )),
            taskMap = {},
            currentTask = nil,
            memory   = 0,
        }
    end
end

--- 勇者是否有空
function m.isIdle(brave)
    return next(brave.taskMap) == nil
end

--- 给勇者推送任务
function m.pushTask(brave, info)
    if info.removed then
        return false
    end
    brave.taskpad:push(info.name, info.id, info.params)
    brave.taskMap[info.id] = info
    --log.info(('Push task %q(%d) to # %d, queue length %d'):format(info.name, info.id, brave.id, #m.taskQueue))
    return true
end

--- 从勇者处接收任务反馈
function m.popTask(brave, id, result)
    local info = brave.taskMap[id]
    if not info then
        log.warn(('Brave pushed unknown task result: # %d => [%d]'):format(brave.id, id))
        return
    end
    brave.taskMap[id] = nil
    --log.info(('Pop task %q(%d) from # %d'):format(info.name, info.id, brave.id))
    m.checkWaitingTask(brave)
    if not info.removed then
        info.removed = true
        if info.callback then
            xpcall(info.callback, log.error, result)
        end
    end
end

--- 从勇者处接收报告
function m.popReport(brave, name, params)
    local abil = m.ability[name]
    if not abil then
        log.warn(('Brave pushed unknown report: # %d => %q'):format(brave.id, name))
        return
    end
    xpcall(abil, log.error, params, brave)
end

--- 发布任务
---@parma name string
---@param params any
function m.awaitTask(name, params)
    local info = {
        id     = counter(),
        name   = name,
        params = params,
    }
    for _, brave in ipairs(m.braves) do
        if m.isIdle(brave) then
            if m.pushTask(brave, info) then
                return await.wait(function (waker)
                    info.callback = waker
                end)
            else
                return nil
            end
        end
    end
    -- 如果所有勇者都在战斗，那么把任务缓存到队列里
    -- 当有勇者提交任务反馈后，尝试把按顺序将堆积任务
    -- 交给该勇者
    m.taskQueue[#m.taskQueue+1] = info
    --log.info(('Add task %q(%d) in queue, length %d.'):format(name, info.id, #m.taskQueue))
    return await.wait(function (waker)
        info.callback = waker
    end)
end

--- 发布同步任务，如果任务进入了队列，会返回执行器
--- 通过 jumpQueue 可以插队
---@parma name string
---@param params any
---@param callback function
function m.task(name, params, callback)
    local info = {
        id       = counter(),
        name     = name,
        params   = params,
        callback = callback,
    }
    for _, brave in ipairs(m.braves) do
        if m.isIdle(brave) then
            m.pushTask(brave, info)
            return nil
        end
    end
    -- 如果所有勇者都在战斗，那么把任务缓存到队列里
    -- 当有勇者提交任务反馈后，尝试把按顺序将堆积任务
    -- 交给该勇者
    m.taskQueue[#m.taskQueue+1] = info
    --log.info(('Add task %q(%d) in queue, length %d.'):format(name, info.id, #m.taskQueue))
    return info
end

--- 插队
function m.jumpQueue(info)
    for i = 2, #m.taskQueue do
        if m.taskQueue[i] == info then
            m.taskQueue[i] = nil
            table.move(m.taskQueue, 1, i - 1, 2)
            m.taskQueue[1] = info
            return
        end
    end
end

--- 移除任务
function m.remove(info)
    info.removed = true
    for i = 1, #m.taskQueue do
        if m.taskQueue[i] == info then
            table.remove(m.taskQueue[i], i)
            return
        end
    end
end

--- 检查堆积任务
function m.checkWaitingTask(brave)
    if #m.taskQueue == 0 then
        return
    end
    -- 如果勇者还有其他活要忙，那么让他继续忙去吧
    if next(brave.taskMap) then
        return
    end
    while #m.taskQueue > 0 do
        local info = table.remove(m.taskQueue, 1)
        if m.pushTask(brave, info) then
            break
        end
    end
end

--- 接收反馈
---|返回接收到的反馈数量
---@return integer
function m.recieve()
    for _, brave in ipairs(m.braves) do
        while true do
            local suc, id, result = brave.waiter:pop()
            if not suc then
                goto CONTINUE
            end
            if type(id) == 'string' then
                m.popReport(brave, id, result)
            else
                m.popTask(brave, id, result)
            end
        end
        ::CONTINUE::
    end
end

--- 检查伤亡情况
function m.checkDead()
    while true do
        local suc, err = errLog:pop()
        if not suc then
            break
        end
        log.error('Brave is dead!: ' .. err)
    end
end

function m.step()
    m.checkDead()
    m.recieve()
end

return m
