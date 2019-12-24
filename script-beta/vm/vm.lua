local guide     = require 'parser.guide'
local util      = require 'utility'

local setmetatable = setmetatable
local assert       = assert
local require      = require
local type         = type
local running      = coroutine.running

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

---@class vm
local m = {}

function m.lock(tp, source)
    local co = running()
    local master = m.locked[co]
    if not master then
        master = {}
        m.locked[co] = master
    end
    if not master[tp] then
        master[tp] = {}
    end
    if master[tp][source] then
        return nil
    end
    master[tp][source] = true
    return function ()
        master[tp][source] = nil
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

function m.isSet(src)
    local tp = src.type
    return tp == 'setglobal'
        or tp == 'local'
        or tp == 'setlocal'
        or tp == 'setfield'
        or tp == 'setmethod'
        or tp == 'setindex'
        or tp == 'tablefield'
        or tp == 'tableindex'
end

m.cacheTracker = setmetatable({}, { __mode = 'kv' })

--- 刷新缓存
function m.refreshCache()
    if m.cache then
        m.cache.dead = true
    end
    m.cache = {
        eachRef     = {},
        eachDef     = {},
        eachField   = {},
        eachMeta    = {},
        getGlobals  = {},
        getLinks    = {},
        getGlobal   = {},
        specialName = {},
        getLibrary  = {},
        getValue    = {},
        getMeta     = {},
        specials    = nil,
    }
    m.locked = setmetatable({}, { __mode = 'k' })
    m.cacheTracker[m.cache] = true
end

return m
