local thread = require 'bee.thread'

---@class pub_brave
local m = {}
m.type = 'pub.brave'
m.ability = {}

--- 注册成为勇者
function m.register(id)
    m.taskpad = thread.channel('taskpad' .. id)
    m.waiter  = thread.channel('waiter'  .. id)
    m.id      = id
    m.start()
end

--- 注册能力
function m.on(name, callback)
    m.ability[name] = callback
end

--- 报告
function m.push(name, params)
    m.waiter:push(name, params)
end

--- 开始找工作
function m.start()
    while true do
        local suc, name, id, params = m.taskpad:pop()
        if not suc then
            -- 找不到工作的勇者，只好睡觉
            thread.sleep(0.001)
            goto CONTINUE
        end
        local ability = m.ability[name]
        -- TODO
        if not ability then
            m.waiter:push(id)
            log.error('Brave can not handle this work: ' .. name)
            goto CONTINUE
        end
        local suc, res = xpcall(ability, log.error, params)
        if not suc then
            m.waiter:push(id)
            goto CONTINUE
        end
        m.waiter:push(id, res)
        ::CONTINUE::
    end
end

return m
