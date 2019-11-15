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

--- 获取link的uri
function m.getLinkUris(call)
    local workspace = require 'workspace'
    local func = call.node
    local name = func.special
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
