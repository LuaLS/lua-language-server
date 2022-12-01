local util     = require 'utility'
local timer    = require 'timer'
local scope    = require 'workspace.scope'
local template = require 'config.template'

---@alias config.source '"client"'|'"path"'|'"local"'

---@class config.api
local m = {}
m.watchList = {}

m.NULL = {}

m.nullSymbols = {
    [m.NULL] = true,
}

---@param scp      scope
---@param key      string
---@param nowValue any
---@param rawValue any
local function update(scp, key, nowValue, rawValue)
    local now = m.getNowTable(scp)
    local raw = m.getRawTable(scp)

    now[key] = nowValue
    raw[key] = rawValue
end

---@param uri? uri
---@param key? string
---@return scope
local function getScope(uri, key)
    local raw = m.getRawTable(scope.override)
    if raw then
        if not key or raw[key] ~= nil then
            return scope.override
        end
    end
    if uri then
        ---@type scope?
        local scp = scope.getFolder(uri) or scope.getLinkedScope(uri)
        if scp then
            if not key
            or m.getRawTable(scp)[key] ~= nil then
                return scp
            end
        end
    end
    return scope.fallback
end

---@param scp   scope
---@param key   string
---@param value any
function m.setByScope(scp, key, value)
    local unit = template[key]
    if not unit then
        return false
    end
    local raw = m.getRawTable(scp)
    if util.equal(raw[key], value) then
        return false
    end
    if unit:checker(value) then
        update(scp, key, unit:loader(value), value)
    else
        update(scp, key, unit.default, unit.default)
    end
    return true
end

---@param uri?   uri
---@param key   string
---@param value any
function m.set(uri, key, value)
    local unit = template[key]
    assert(unit, 'unknown key: ' .. key)
    local scp = getScope(uri, key)
    local oldValue = m.get(uri, key)
    m.setByScope(scp, key, value)
    local newValue = m.get(uri, key)
    if not util.equal(oldValue, newValue) then
        m.event(uri, key, newValue, oldValue)
        return true
    end
    return false
end

function m.add(uri, key, value)
    local unit = template[key]
    assert(unit, 'unknown key: ' .. key)
    local list = m.getRaw(uri, key)
    assert(type(list) == 'table', 'not a list: ' .. key)
    local copyed = {}
    for i, v in ipairs(list) do
        if util.equal(v, value) then
            return false
        end
        copyed[i] = v
    end
    copyed[#copyed+1] = value
    local oldValue = m.get(uri, key)
    m.set(uri, key, copyed)
    local newValue = m.get(uri, key)
    if not util.equal(oldValue, newValue) then
        m.event(uri, key, newValue, oldValue)
        return true
    end
    return false
end

function m.remove(uri, key, value)
    local unit = template[key]
    assert(unit, 'unknown key: ' .. key)
    local list = m.getRaw(uri, key)
    assert(type(list) == 'table', 'not a list: ' .. key)
    local copyed = {}
    for i, v in ipairs(list) do
        if not util.equal(v, value) then
            copyed[i] = v
        end
    end
    local oldValue = m.get(uri, key)
    m.set(uri, key, copyed)
    local newValue = m.get(uri, key)
    if not util.equal(oldValue, newValue) then
        m.event(uri, key, newValue, oldValue)
        return true
    end
    return false
end

function m.prop(uri, key, prop, value)
    local unit = template[key]
    assert(unit, 'unknown key: ' .. key)
    local map = m.getRaw(uri, key)
    assert(type(map) == 'table', 'not a map: ' .. key)
    if util.equal(map[prop], value) then
        return false
    end
    local copyed = {}
    for k, v in pairs(map) do
        copyed[k] = v
    end
    copyed[prop] = value
    local oldValue = m.get(uri, key)
    m.set(uri, key, copyed)
    local newValue = m.get(uri, key)
    if not util.equal(oldValue, newValue) then
        m.event(uri, key, newValue, oldValue)
        return true
    end
    return false
end

---@param uri? uri
---@param key string
---@return any
function m.get(uri, key)
    local scp = getScope(uri, key)
    local value = m.getNowTable(scp)[key]
    if value == nil then
        value = template[key].default
    end
    if value == m.NULL then
        value = nil
    end
    return value
end

---@param uri uri
---@param key string
---@return any
function m.getRaw(uri, key)
    local scp = getScope(uri, key)
    local value = m.getRawTable(scp)[key]
    if value == nil then
        value = template[key].default
    end
    if value == m.NULL then
        value = nil
    end
    return value
end

---@param scp  scope
function m.getNowTable(scp)
    return scp:get 'config.now'
        or scp:set('config.now', {})
end

---@param scp  scope
function m.getRawTable(scp)
    return scp:get 'config.raw'
        or scp:set('config.raw', {})
end

---@param scp  scope
---@param ...  table
function m.update(scp, ...)
    local oldConfig = m.getNowTable(scp)
    local newConfig = {}
    scp:set('config.now', newConfig)
    scp:set('config.raw', {})

    local function expand(t, left)
        for key, value in pairs(t) do
            local fullKey = key
            if left then
                fullKey = left .. '.' .. key
            end
            if m.nullSymbols[value] then
                value = m.NULL
            end
            if     template[fullKey] then
                m.setByScope(scp, fullKey, value)
            elseif template['Lua.' .. fullKey] then
                m.setByScope(scp, 'Lua.' .. fullKey, value)
            elseif type(value) == 'table' then
                expand(value, fullKey)
            end
        end
    end

    local news = table.pack(...)
    for i = 1, news.n do
        if type(news[i]) == 'table' then
            expand(news[i])
        end
    end

    -- compare then fire event
    if oldConfig then
        for key, oldValue in pairs(oldConfig) do
            local newValue = newConfig[key]
            if not util.equal(oldValue, newValue) then
                m.event(scp.uri, key, newValue, oldValue)
            end
        end
    end

    m.event(scp.uri, '')
end

---@param callback fun(uri: uri, key: string, value: any, oldValue: any)
function m.watch(callback)
    m.watchList[#m.watchList+1] = callback
end

function m.event(uri, key, value, oldValue)
    if not m.changes then
        m.changes = {}
        timer.wait(0, function ()
            local delay = m.changes
            m.changes = nil
            for _, info in ipairs(delay) do
                for _, callback in ipairs(m.watchList) do
                    callback(info.uri, info.key, info.value, info.oldValue)
                end
            end
        end)
    end
    m.changes[#m.changes+1] = {
        uri      = uri,
        key      = key,
        value    = value,
        oldValue = oldValue,
    }
end

function m.addNullSymbol(null)
    m.nullSymbols[null] = true
end

return m
