local thread  = require 'bee.thread'
local taskpad = require 'pub.taskpad'
local waiter  = require 'pub.waiter'
local brave   = require 'pub.brave'

---@class pub
local m = {}
m.type = 'pub'

--- 委托人招募勇者，勇者会从公告板上领取任务，完成任务后到看板娘处交付任务
function m:recruitBraves(num)
    if self.mode ~= 'client' then
        error('只有委托人可以招募勇者')
    end
    for _ = 1, num do
        local n = #self.braves + 1
        self.braves[n] = brave(n)
    end
end

--- 委托人发布任务
function m:task()

end

--- 注册成为委托人
function m:registerClient()
    self.mode = 'client'
    self.braves = {}
end

--- 注册成为勇者
function m:registerBrave(id)
    self.mode = 'brave'
    self.taskpad = thread.channel('taskpad' .. id)
    self.waiter  = thread.channel('waiter'  .. id)
end

return m
