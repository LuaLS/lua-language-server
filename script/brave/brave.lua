local channel = require 'bee.channel'
local epoll   = require 'bee.epoll'

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

    reqPad = channel.query(taskChName)
    resPad = channel.query(replyChName)

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
    local epfd <close> = assert(epoll.create(16))
    epfd:event_add(reqPad:fd(), epoll.EPOLLIN)

    m.push('mem', collectgarbage 'count')
    while true do
        for _, event in epfd:wait() do
            if event & epoll.EPOLLIN ~= 0 then
                local ok, name, id, params = reqPad:pop()
                if ok then
                    local ability = m.ability[name]
                    if not ability then
                        resPad:push(id)
                        log.error('Brave can not handle this work: ' .. name)
                        goto CONTINUE
                    end
                    local suc, res = xpcall(ability, log.error, params)
                    if suc then
                        resPad:push(id, res)
                    else
                        resPad:push(id)
                    end
                    m.push('mem', collectgarbage 'count')
                    ::CONTINUE::
                end
            end
        end
    end
end

return m
