local guide     = require 'parser.guide'
local files     = require 'files'
local timer     = require 'timer'

local setmetatable   = setmetatable
local log            = log
local xpcall         = xpcall
local mathHuge       = math.huge

local weakMT = { __mode = 'kv' }

---@class vm
local m = {}

m.ID_SPLITE = '\x1F'

function m.getSpecial(source)
    if not source then
        return nil
    end
    return source.special
end

---@param source parser.object
---@return string?
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

---@param source parser.object
---@return parser.object?
function m.getObjectValue(source)
    if source.value then
        return source.value
    end
    if source.special == 'rawset' then
        return source.args and source.args[3]
    end
    return nil
end

---@param source parser.object
---@return parser.object?
function m.getObjectFunctionValue(source)
    local value = m.getObjectValue(source)
    if value == nil then return end
    if value.type == 'function' or value.type == 'doc.type.function' then
        return value
    end
    if value.type == 'getlocal' then
        return m.getObjectFunctionValue(value.node)
    end
    return value
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
