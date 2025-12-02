local thread     = require 'bee.thread'
local channelMod = require 'bee.channel'
local selectMod  = require 'bee.select'

local reqPad
local resPad

---@class pub_brave
local m = {}
m.type = 'brave'
m.ability = {}
m.queue = {}

--- 注册成为勇者
---@param id integer
---@param taskChName string
---@param replyChName string
function m.register(id, taskChName, replyChName)
    m.id = id

    reqPad = channelMod.query(taskChName)
    resPad = channelMod.query(replyChName)

    assert(reqPad, 'task channel not found: ' .. taskChName)
    assert(resPad, 'reply channel not found: ' .. replyChName)

    if #m.queue > 0 then
        for _, info in ipairs(m.queue) do
            resPad:push(info.name, info.params)
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
    if m.id and resPad then
        resPad:push(name, params)
    else
        m.queue[#m.queue+1] = {
            name   = name,
            params = params,
        }
    end
end

--- 开始找工作
function m.start()
    local selector = selectMod.create()
    selector:event_add(reqPad:fd(), selectMod.SELECT_READ)

    m.push('mem', collectgarbage 'count')
    while true do
        -- 使用 select 实现阻塞等待
        local name, id, params
        while true do
            local ok, n, i, p = reqPad:pop()
            if ok then
                name, id, params = n, i, p
                break
            end
            selector:wait(-1)
        end

        local ability = m.ability[name]
        -- TODO
        if not ability then
            resPad:push(id)
            log.error('Brave can not handle this work: ' .. name)
            goto CONTINUE
        end
        local ok, res = xpcall(ability, log.error, params)
        if ok then
            resPad:push(id, res)
        else
            resPad:push(id)
        end
        m.push('mem', collectgarbage 'count')
        ::CONTINUE::
    end
end

return m
