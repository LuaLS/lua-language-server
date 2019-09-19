local thread  = require 'bee.thread'
local utility = require 'utility'
local task    = require 'task'
local type    = require 'type'

local braveTemplate = [[
package.path  = %q
package.cpath = %q

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
        log.info('Create pub brave:', id)
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
    local co = coroutine.running()
    brave.taskpad:push(name, taskID, params)
    brave.taskList[taskID] = co
    return coroutine.yield(co)
end

--- 从勇者处接收任务反馈
function m.popTask(brave, id, params)
    local co = brave.taskList[id]
    if not co then
        log.warn(('Brave pushed unknown task result: [%d] => [%d]'):format(brave.id, id))
        return
    end
    brave.taskList[id] = nil
    coroutine.resume(co, params)
end

--- 发布任务
---@parma name string
function m.task(name, params)
    local _, main = coroutine.running()
    if main then
        error('不能在主线程中发布任务')
    end
    for _, brave in ipairs(m.braves) do
        if m.isIdle(brave) then
            return m.pushTask(brave, name, params)
        end
    end
end

--- 接收反馈
function m.recieve()
    local _, main = coroutine.running()
    if main then
        error('不能在主线程中接收反馈')
    end
    for _, brave in ipairs(m.braves) do
        local suc, id, result
        if not suc then
            goto CONTINUE
        end
        ::CONTINUE::
    end
end

return m
