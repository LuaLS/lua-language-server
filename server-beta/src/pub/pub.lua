local thread  = require 'bee.thread'
local utility = require 'utility'
local task    = require 'task'

local errLog  = thread.channel 'errlog'
local type    = type

local braveTemplate = [[
package.path  = %q
package.cpath = %q

log         = require 'brave.log'
local brave = require 'brave'
brave.register(%d)
]]

---@class pub
local m = {}
m.type = 'pub'
m.braves = {}
m.ability = {}
m.taskList = {}

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
                id
            )),
            taskList = {},
            counter  = utility.counter(),
            currentTask = nil,
            memory   = 0,
        }
    end
end

--- 勇者是否有空
function m.isIdle(brave)
    return next(brave.taskList) == nil
end

--- 给勇者推送任务
function m.pushTask(brave, name, params)
    local taskID = brave.counter()
    brave.taskpad:push(name, taskID, params)
    return task.wait(function (waker)
        brave.taskList[taskID] = waker
    end)
end

--- 从勇者处接收任务反馈
function m.popTask(brave, id, result)
    local waker = brave.taskList[id]
    if not waker then
        log.warn(('Brave pushed unknown task result: # %d => [%d]'):format(brave.id, id))
        return
    end
    brave.taskList[id] = nil
    m.checkWaitingTask(brave)
    waker(result)
end

--- 从勇者处接收报告
function m.popReport(brave, name, params)
    local abil = m.ability[name]
    if not abil then
        log.warn(('Brave pushed unknown report: # %d => %q'):format(brave.id, name))
        return
    end
    abil(params, brave)
end

--- 发布任务
---@parma name string
function m.task(name, params)
    for _, brave in ipairs(m.braves) do
        if m.isIdle(brave) then
            return m.pushTask(brave, name, params)
        end
    end
    -- 如果所有勇者都在战斗，那么把任务缓存到队列里
    -- 当有勇者提交任务反馈后，尝试把按顺序将堆积任务
    -- 交给该勇者
    m.taskList[#m.taskList+1] = function (brave)
        return m.pushTask(brave, name, params)
    end
end

--- 检查堆积任务
function m.checkWaitingTask(brave)
    if #m.taskList == 0 then
        return
    end
    -- 如果勇者还有其他活要忙，那么让他继续忙去吧
    if next(brave.taskList) then
        return
    end
    local waiting = table.remove(m.taskList, 1)
    waiting(brave)
end

--- 接收反馈
---|返回接收到的反馈数量
---@return integer
function m.recieve()
    for _, brave in ipairs(m.braves) do
        local suc, id, result = brave.waiter:pop()
        if not suc then
            goto CONTINUE
        end
        if type(id) == 'string' then
            m.popReport(brave, id, result)
        else
            m.popTask(brave, id, result)
        end
        task.sleep(0)
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

function m.listen()
    task.create(function ()
        while true do
            m.checkDead()
            m.recieve()
            task.sleep(0)
        end
    end)
end

return m
