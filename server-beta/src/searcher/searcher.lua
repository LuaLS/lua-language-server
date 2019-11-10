local guide     = require 'parser.guide'
local util      = require 'utility'

local setmetatable = setmetatable
local assert       = assert

_ENV = nil

local specials = {
    ['_G']           = true,
    ['rawset']       = true,
    ['rawget']       = true,
    ['setmetatable'] = true,
    ['require']      = true,
    ['dofile']       = true,
    ['loadfile']     = true,
}

---@class searcher
local m = {}

function m.lock(tp, source)
    if m.locked[tp][source] then
        return nil
    end
    m.locked[tp][source] = true
    return function ()
        m.locked[tp][source] = nil
    end
end

--- 获取特殊对象的名字
function m.getSpecialName(source)
    local spName = m.cache.specialName[source]
    if spName ~= nil then
        if spName then
            return spName
        end
        return nil
    end
    local function getName(src)
        if src.type == 'getglobal' then
            local node = src.node
            if node.tag ~= '_ENV' then
                return nil
            end
            local name = guide.getKeyName(src)
            if name:sub(1, 2) ~= 's|' then
                return nil
            end
            spName = name:sub(3)
            if not specials[spName] then
                spName = nil
            end
        elseif src.type == 'local' then
            if src.tag == '_ENV' then
                spName = '_G'
            end
        elseif src.type == 'getlocal' then
            local loc = src.loc
            if loc.tag == '_ENV' then
                spName = '_G'
            end
        end
    end
    getName(source)
    if not spName then
        m.eachRef(source, function (info)
            getName(info.source)
        end)
    end
    m.cache.specialName[source] = spName or false
    return spName
end

--- 遍历特殊对象
---@param callback fun(name:string, source:table)
function m.eachSpecial(callback)
    local cache = m.cache.specials
    if cache then
        for i = 1, #cache do
            callback(cache[i][1], cache[i][2])
        end
        return
    end
    cache = {}
    m.cache.specials = cache
    guide.eachSource(m.ast, function (source)
        if source.type == 'getlocal'
        or source.type == 'getglobal'
        or source.type == 'local'
        or source.type == 'field'
        or source.type == 'string' then
            local name = m.getSpecialName(source)
            if name then
                cache[#cache+1] = { name, source }
            end
        end
    end)
    for i = 1, #cache do
        callback(cache[i][1], cache[i][2])
    end
end

m.cacheTracker = setmetatable({}, { __mode = 'kv' })

--- 刷新缓存
function m.refreshCache()
    if m.cache then
        m.cache.dead = true
    end
    m.cache = {
        eachRef     = {},
        eachField   = {},
        getGlobals  = {},
        isGlobal    = {},
        specialName = {},
        getLibrary  = {},
        specials    = nil,
    }
    m.locked = {
        eachRef    = {},
        eachField  = {},
        getGlobals = {},
        getLibrary = {},
    }
    m.cacheTracker[m.cache] = true
end

return m
