local thread = require 'bee.thread'

---@class pub_brave
local m = {}
m.type = 'pub.brave'

--- 注册成为勇者
function m.register(id)
    m.taskpad = thread.channel('taskpad' .. id)
    m.waiter  = thread.channel('waiter'  .. id)
    m.start()
end

--- 开始找工作
function m.start()
    while true do
        local suc, name, id, params = m.taskpad:pop()
        if not suc then
            -- 找不到工作的勇者，只好睡觉
            thread.sleep(0.01)
        end
        local result = require(name)(params)
        m.waiter:push(id, result)
    end
end

return m
