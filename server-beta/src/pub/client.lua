local thread  = require 'bee.thread'
local utility = require 'utility'
local task    = require 'task'

local errLog  = thread.channel 'errlog'
local type    = type

local braveTemplate = [[
package.path  = %q
package.cpath = %q

--log = require 'work.log'

local brave = require 'pub.brave'
brave.register(%d)
]]

---@class pub_client
local m = {}
m.type = 'pub.client'
m.braves = {}

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
        log.warn(('Brave pushed unknown task result: [%d] => [%d]'):format(brave.id, id))
        return
    end
    brave.taskList[id] = nil
    waker(result)
end

--- 从勇者处接收报告
function m.popReport(brave, name, params)
end

--- 发布任务
---@parma name string
function m.task(name, params)
    for _, brave in ipairs(m.braves) do
        if m.isIdle(brave) then
            return m.pushTask(brave, name, params)
        end
    end
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
            m.popTask(brave, id, result)
        else
            m.popReport(brave, id, result)
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

return m
