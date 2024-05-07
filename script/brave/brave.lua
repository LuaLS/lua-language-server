local channel = require 'bee.channel'
local select = require 'bee.select'

local function channel_init(chan)
    local selector = select.create()
    selector:event_add(chan:fd(), select.SELECT_READ)
    return { selector, chan }
end

local function channel_bpop(ctx)
    local selector, chan = ctx[1], ctx[2]
    for _ in selector:wait() do
        local r = table.pack(chan:pop())
        if r[1] == true then
            return table.unpack(r, 2)
        end
    end
end

local taskPad = channel_init(channel.query('taskpad'))
local waiter  = channel.query('waiter')

---@class pub_brave
local m = {}
m.type = 'brave'
m.ability = {}
m.queue = {}

--- 注册成为勇者
function m.register(id, privatePad)
    m.id = id

    if #m.queue > 0 then
        for _, info in ipairs(m.queue) do
            waiter:push(m.id, info.name, info.params)
        end
    end
    m.queue = nil

    m.start(privatePad)
end

--- 注册能力
function m.on(name, callback)
    m.ability[name] = callback
end

--- 报告
function m.push(name, params)
    if m.id then
        waiter:push(m.id, name, params)
    else
        m.queue[#m.queue+1] = {
            name   = name,
            params = params,
        }
    end
end

--- 开始找工作
function m.start(privatePad)
    local reqPad = privatePad and channel_init(channel.query('req:' .. privatePad)) or taskPad
    local resPad = privatePad and channel.query('res:' .. privatePad) or waiter
    m.push('mem', collectgarbage 'count')
    while true do
        local name, id, params = channel_bpop(reqPad)
        local ability = m.ability[name]
        -- TODO
        if not ability then
            resPad:push(m.id, id)
            log.error('Brave can not handle this work: ' .. name)
            goto CONTINUE
        end
        local ok, res = xpcall(ability, log.error, params)
        if ok then
            resPad:push(m.id, id, res)
        else
            resPad:push(m.id, id)
        end
        m.push('mem', collectgarbage 'count')
        ::CONTINUE::
    end
end

return m
