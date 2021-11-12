local guide     = require 'parser.guide'
local util      = require 'utility'
local files     = require 'files'
local timer     = require 'timer'

local setmetatable   = setmetatable
local running        = coroutine.running
local ipairs         = ipairs
local log            = log
local xpcall         = xpcall
local mathHuge       = math.huge

local weakMT = { __mode = 'kv' }

_ENV = nil

---@class vm
local m = {}

function m.getArgInfo(source)
    local callargs = source.parent
    if not callargs or callargs.type ~= 'callargs' then
        return nil
    end
    local call = callargs.parent
    if not call or call.type ~= 'call' then
        return nil
    end
    for i = 1, #callargs do
        if callargs[i] == source then
            return call.node, i
        end
    end
    return nil
end

function m.getSpecial(source)
    if not source then
        return nil
    end
    return source.special
end

function m.getKeyName(source)
    if not source then
        return nil
    end
    if source.type == 'call' then
        local special = m.getSpecial(source.node)
        if special == 'rawset'
        or special == 'rawget' then
            return guide.getKeyNameOfLiteral(source.args[2])
        end
    end
    return guide.getKeyName(source)
end

function m.getKeyType(source)
    if not source then
        return nil
    end
    if source.type == 'call' then
        local special = m.getSpecial(source.node)
        if special == 'rawset'
        or special == 'rawget' then
            return guide.getKeyTypeOfLiteral(source.args[2])
        end
    end
    return guide.getKeyType(source)
end

m.cacheTracker = setmetatable({}, weakMT)

function m.flushCache()
    if m.cache then
        m.cache.dead = true
    end
    m.cacheVersion = files.globalVersion
    m.cache = {}
    m.cacheActiveTime = mathHuge
    m.locked = setmetatable({}, weakMT)
    m.cacheTracker[m.cache] = true
end

function m.getCache(name, weak)
    if m.cacheVersion ~= files.globalVersion then
        m.flushCache()
    end
    m.cacheActiveTime = timer.clock()
    if not m.cache[name] then
        m.cache[name] = weak and setmetatable({}, weakMT) or {}
    end
    return m.cache[name]
end

local function init()
    m.flushCache()

    -- 可以在一段时间不活动后清空缓存，不过目前看起来没有必要
    --timer.loop(1, function ()
    --    if timer.clock() - m.cacheActiveTime > 10.0 then
    --        log.info('Flush cache: Inactive')
    --        m.flushCache()
    --        collectgarbage()
    --    end
    --end)
end

xpcall(init, log.error)

return m
