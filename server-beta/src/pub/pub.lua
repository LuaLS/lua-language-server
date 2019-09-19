local thread  = require 'bee.thread'
local taskpad = require 'pub.taskpad'
local waiter  = require 'pub.waiter'
local brave   = require 'pub.brave'

---@class pub
local m = {}
m.type = 'pub'
m.waiters  = {}
m.taskPads = {}
m.braves   = {}

--- 创建公告板，空闲的勇者会从公告板上领取任务
function m:createTaskPads(num)
    for _ = 1, num do
        local n = #self.taskPads + 1
        self.taskPads[n] = taskpad('task' .. n)
    end
end

--- 雇佣看板娘，完成任务的勇者会到看板娘处交付任务
function m:hireWaiters(num)
    for _ = 1, num do
        local n = #self.waiters + 1
        self.waiters[n] = waiter('waiter' .. n)
    end
end

--- 招募勇者，勇者会从公告板上领取任务，完成任务后到看板娘处交付任务
function m:recruitBraves(num)
    for _ = 1, num do
        local n = #self.braves + 1
        self.braves[n] = brave('brave' .. n)
    end
end

function m:build()
    thread.newchannel 'task0'
    thread.newchannel 'bulletin'
    thread.newchannel 'log'

    self.taskPads[0]  = taskpad 'task0'
    self.waiters[0]   = waiter 'waiter0'
    self.bulletin     = thread.channel 'bulletin'
    self.log          = thread.channel 'log'
end

return m
