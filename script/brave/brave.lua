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
            m.waiter:push(m.id, info.name, info.params)
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
        m.waiter:push(m.id, name, params)
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
        local name, id, params = m.taskpad:bpop()
        local ability = m.ability[name]
        -- TODO
        if not ability then
            m.waiter:push(m.id, id)
            log.error('Brave can not handle this work: ' .. name)
            goto CONTINUE
        end
        local ok, res = xpcall(ability, log.error, params)
        if ok then
            m.waiter:push(m.id, id, res)
        else
            m.waiter:push(m.id, id)
        end
        m.push('mem', collectgarbage 'count')
        ::CONTINUE::
    end
end

return m
