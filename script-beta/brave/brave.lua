local thread = require 'bee.thread'

---@class pub_brave
local m = {}
m.type = 'brave'
m.ability = {}
m.queue = {}

--- 注册成为勇者
function m.register(id)
    m.taskpad = thread.channel('taskpad' .. id)
    m.waiter  = thread.channel('waiter'  .. id)
    m.id      = id

    if #m.queue > 0 then
        for _, info in ipairs(m.queue) do
            m.waiter:push(info.name, info.params)
        end
    end
    m.queue = nil

    m.start()
end

--- 注册能力
function m.on(name, callback)
    m.ability[name] = callback
end

--- 报告
function m.push(name, params)
    if m.waiter then
        m.waiter:push(name, params)
    else
        m.queue[#m.queue+1] = {
            name   = name,
            params = params,
        }
    end
end

--- 开始找工作
function m.start()
    m.push('mem', collectgarbage 'count')
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
        local ok, res = xpcall(ability, log.error, params)
        if ok then
            m.waiter:push(id, res)
        else
            m.waiter:push(id)
        end
        m.push('mem', collectgarbage 'count')
        ::CONTINUE::
    end
end

return m
