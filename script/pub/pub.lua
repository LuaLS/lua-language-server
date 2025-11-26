local thread     = require 'bee.thread'
local channelMod = require 'bee.channel'
local selectMod  = require 'bee.select'
local utility    = require 'utility'
local await      = require 'await'

-- 每个 brave 有独立的 channel 对，避免多线程竞争
local selector = selectMod.create()

local type    = type
local counter = utility.counter()

local braveTemplate = [[
package.path  = {path:q}
package.cpath = {cpath:q}
DEVELOP = {DEVELOP}
DBGPORT = {DBGPORT}
DBGWAIT = {DBGWAIT}

collectgarbage 'generational'

log = require 'brave.log'

xpcall(dofile, log.error, {debugger:q})
local brave = require 'brave'
brave.register({id}, {taskChName:q}, {replyChName:q})
]]

---@class pub
local m     = {}
m.type      = 'pub'
m.ability   = {}
m.taskMap   = {}
m.allBraves = {}
m.publicBraves  = {}  -- 公共线程组
m.privateBraves = {}  -- 专用线程组字典 {padName = {braves}}
m.publicQueue   = {}  -- 公共任务队列
m.privateQueues = {}  -- 专用任务队列字典 {padName = {tasks}}

--- 注册酒馆的功能
function m.on(name, callback)
    m.ability[name] = callback
end

--- 招募勇者，为每个勇者分配独立的 channel 对
---@param num integer
---@param privatePad string?
function m.recruitBraves(num, privatePad)
    local braveList
    if privatePad then
        -- 专用线程组
        if not m.privateBraves[privatePad] then
            m.privateBraves[privatePad] = {}
            m.privateQueues[privatePad] = {}
        end
        braveList = m.privateBraves[privatePad]
    else
        -- 公共线程组
        braveList = m.publicBraves
    end

    for _ = 1, num do
        local id = #m.allBraves + 1
        local taskChName = privatePad and ('task:' .. privatePad .. ':' .. id) or ('task:' .. id)
        local replyChName = privatePad and ('reply:' .. privatePad .. ':' .. id) or ('reply:' .. id)

        local taskCh = channelMod.create(taskChName)
        local replyCh = channelMod.create(replyChName)
        selector:event_add(replyCh:fd(), selectMod.SELECT_READ)

        log.debug('Create brave:', privatePad or 'public', id)
        local brave = {
            id          = id,
            thread      = thread.create(braveTemplate % {
                path = package.path,
                cpath = package.cpath,
                DEVELOP = DEVELOP,
                DBGPORT = DBGPORT or 11412,
                DBGWAIT = DBGWAIT or 'nil',
                debugger = (ROOT / 'debugger.lua'):string(),
                id = id,
                taskChName = taskChName,
                replyChName = replyChName,
            }),
            taskMap     = {},
            currentTask = nil,
            memory      = 0,
            taskCh      = taskCh,
            replyCh     = replyCh,
            busy        = false,
            privatePad  = privatePad,
        }
        m.allBraves[id] = brave
        braveList[#braveList+1] = brave
    end
end

--- 查找一个空闲的勇者
---@param braveList table
---@return table?
local function findIdleBrave(braveList)
    for _, brave in ipairs(braveList) do
        if not brave.busy then
            return brave
        end
    end
    return nil
end

--- 给勇者推送任务
function m.pushTask(info)
    if info.removed then
        return false
    end

    -- 检查是否有对应的专用组（通过任务名匹配 privatePad）
    local braveList = m.publicBraves
    local queue = m.publicQueue
    if m.privateBraves[info.name] then
        braveList = m.privateBraves[info.name]
        queue = m.privateQueues[info.name]
    end

    -- 查找空闲的 brave
    local brave = findIdleBrave(braveList)
    if not brave then
        -- 所有 brave 都忙，加入队列
        queue[#queue + 1] = info
        m.taskMap[info.id] = info
        return true
    end

    -- 找到空闲 brave，直接推送
    brave.busy = true
    brave.currentTask = info.id
    brave.taskCh:push(info.name, info.id, info.params)
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

    -- 任务完成，标记为空闲
    brave.busy = false
    brave.currentTask = nil

    -- 从对应的队列中取下一个任务
    local queue = brave.privatePad and m.privateQueues[brave.privatePad] or m.publicQueue
    for i = 1, #queue do
        local nextTask = queue[i]
        if not nextTask.removed then
            table.remove(queue, i)
            brave.busy = true
            brave.currentTask = nextTask.id
            brave.taskCh:push(nextTask.name, nextTask.id, nextTask.params)
            break
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

--- 发布同步任务
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

function m.reciveFromPad(brave)
    local suc, name, id, result = brave.replyCh:pop()
    if not suc then
        return false
    end
    if type(name) == 'string' then
        m.popReport(brave, name, id)
    else
        m.popTask(brave, name, result)
    end
    return true
end

--- 接收反馈
function m.recieve(block)
    if block then
        -- 使用 select 等待数据
        selector:wait(-1)
        -- 遍历公共组
        for _, brave in ipairs(m.publicBraves) do
            if m.reciveFromPad(brave) then
                return
            end
        end
        -- 遍历所有专用组
        for _, braveList in pairs(m.privateBraves) do
            for _, brave in ipairs(braveList) do
                if m.reciveFromPad(brave) then
                    return
                end
            end
        end
    else
        while true do
            local ok = false
            -- 遍历公共组
            for _, brave in ipairs(m.publicBraves) do
                if m.reciveFromPad(brave) then
                    ok = true
                end
            end
            -- 遍历所有专用组
            for _, braveList in pairs(m.privateBraves) do
                for _, brave in ipairs(braveList) do
                    if m.reciveFromPad(brave) then
                        ok = true
                    end
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
