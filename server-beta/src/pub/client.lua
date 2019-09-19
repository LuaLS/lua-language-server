local thread  = require 'bee.thread'

local braveTemplate = [[
package.path  = %q
package.cpath = %q

local brave = require 'pub.brave'
brave:register(%d)
]]

---@class pub_client
local m = {}
m.type = 'pub.client'
m.braves = {}

--- 招募勇者，勇者会从公告板上领取任务，完成任务后到看板娘处交付任务
function m:recruitBraves(num)
    for _ = 1, num do
        local id = #self.braves + 1
        log.info('Create pub brave:', id)
        thread.newchannel('taskpad' .. id)
        thread.newchannel('waiter'  .. id)
        self.braves[id] = {
            taskpad = thread.channel('taskpad' .. id),
            waiter  = thread.channel('waiter'  .. id),
            thread  = thread.thread(braveTemplate:format(
                package.path,
                package.cpath,
                id
            )),
        }
    end
end

--- 发布任务
function m:task()

end

return m
