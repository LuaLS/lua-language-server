local thread  = require 'bee.thread'
local channel = require 'bee.channel'
local select = require 'bee.select'
local utility = require 'utility'
local await   = require 'await'

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

local taskPad = channel.create 'taskpad'
local waiter  = channel_init(channel.create 'waiter')
local type    = type
local counter = utility.counter()

local braveTemplate = [[
package.path  = %q
package.cpath = %q
DEVELOP = %s
DBGPORT = %d
DBGWAIT = %s

collectgarbage 'generational'

log = require 'brave.log'

xpcall(dofile, log.error, %q)
local brave = require 'brave'
brave.register(%d, %q)
]]

---@class pub
local m     = {}
m.type      = 'pub'
m.braves    = {}
m.ability   = {}
m.taskQueue = {}
m.taskMap   = {}
m.prvtPad   = {}

--- 注册酒馆的功能
function m.on(name, callback)
    m.ability[name] = callback
end

--- 招募勇者，勇者会从公告板上领取任务，完成任务后到看板娘处交付任务
---@param num integer
---@param privatePad string?
function m.recruitBraves(num, privatePad)
    for _ = 1, num do
        local id = #m.braves + 1
        log.debug('Create brave:', id)
        m.braves[id] = {
            id      = id,
            thread  = thread.create(braveTemplate:format(
                package.path,
                package.cpath,
                DEVELOP,
                DBGPORT or 11412,
                DBGWAIT or 'nil',
                (ROOT / 'debugger.lua'):string(),
                id,
                privatePad
            )),
            taskMap = {},
            currentTask = nil,
            memory   = 0,
        }
    end
    if privatePad and not m.prvtPad[privatePad] then
        m.prvtPad[privatePad] = {
            req = channel.create('req:' .. privatePad),
            res = channel.create('res:' .. privatePad),
        }
    end
end

--- 给勇者推送任务
function m.pushTask(info)
    if info.removed then
        return false
    end
    if m.prvtPad[info.name] then
        m.prvtPad[info.name].req:push(info.name, info.id, info.params)
    else
        taskPad:push(info.name, info.id, info.params)
    end
    m.taskMap[info.id] = info
    return true
end

--- 从勇者处接收任务反馈
function m.popTask(brave, id, result)
    local info = m.taskMap[id]
    if not info then
        log.warn(('Brave pushed unknown task result: # %d => [%d]'):format(brave.id, id))
        return
    end
    m.taskMap[id] = nil
    if not info.removed then
        info.removed = true
        if info.callback then
            xpcall(info.callback, log.error, result)
        end
    end
end

--- 从勇者处接收报告
function m.popReport(brave, name, params)
    local abil = m.ability[name]
    if not abil then
        log.warn(('Brave pushed unknown report: # %d => %q'):format(brave.id, name))
        return
    end
    xpcall(abil, log.error, params, brave)
end

--- 发布任务
---@param name string
---@param params any
---@return any
---@async
function m.awaitTask(name, params)
    local info = {
        id     = counter(),
        name   = name,
        params = params,
    }
    if m.pushTask(info) then
        return await.wait(function (waker)
            info.callback = waker
        end)
    else
        return false
    end
end

--- 发布同步任务，如果任务进入了队列，会返回执行器
--- 通过 jumpQueue 可以插队
---@param name string
---@param params any
---@param callback? function
function m.task(name, params, callback)
    local info = {
        id       = counter(),
        name     = name,
        params   = params,
        callback = callback,
    }
    return m.pushTask(info)
end

function m.reciveFromPad(pad)
    local suc, id, name, result = pad:pop()
    if not suc then
        return false
    end
    if type(name) == 'string' then
        m.popReport(m.braves[id], name, result)
    else
        m.popTask(m.braves[id], name, result)
    end
    return true
end

--- 接收反馈
function m.recieve(block)
    if block then
        local id, name, result = channel_bpop(waiter)
        if type(name) == 'string' then
            m.popReport(m.braves[id], name, result)
        else
            m.popTask(m.braves[id], name, result)
        end
    else
        while true do
            local ok
            if m.reciveFromPad(waiter[2]) then
                ok = true
            end
            for _, pad in pairs(m.prvtPad) do
                if m.reciveFromPad(pad.res) then
                    ok = true
                end
            end

            if not ok then
                break
            end
        end
    end
end

--- 检查伤亡情况
function m.checkDead()
    while true do
        local err = thread.errlog()
        if not err then
            break
        end
        log.error('Brave is dead!: ' .. err)
    end
end

function m.step(block)
    m.checkDead()
    m.recieve(block)
end

return m
