local guide     = require 'parser.guide'
local util      = require 'utility'

local setmetatable = setmetatable
local assert       = assert
local require      = require
local type         = type

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

--- 获取link的uri
function m.getLinkUris(call)
    local workspace = require 'workspace'
    local func = call.node
    local name = m.getSpecialName(func)
    if name == 'require' then
        local args = call.args
        if not args[1] then
            return nil
        end
        local literal = guide.getLiteral(args[1])
        if type(literal) ~= 'string' then
            return nil
        end
        return workspace.findUrisByRequirePath(literal, true)
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
        getLinks    = {},
        isGlobal    = {},
        specialName = {},
        getLibrary  = {},
        specials    = nil,
    }
    m.locked = {
        eachRef    = {},
        eachField  = {},
        getGlobals = {},
        getLinks   = {},
        getLibrary = {},
    }
    m.cacheTracker[m.cache] = true
end

return m
