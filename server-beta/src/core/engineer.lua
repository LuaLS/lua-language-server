local guide       = require 'parser.guide'
local require     = require
local tableUnpack = table.unpack
local error       = error

local setmetatable = setmetatable

_ENV = nil
---@class engineer
local mt = {}
mt.__index = mt
mt.type = 'engineer'

mt['local']      = require 'core.local'
mt['getlocal']   = require 'core.getlocal'
mt['setlocal']   = mt['getlocal']
mt['getglobal']  = require 'core.getglobal'
mt['setglobal']  = mt['getglobal']
mt['getfield']   = require 'core.getfield'
mt['setfield']   = mt['getfield']
mt['tablefield'] = require 'core.tablefield'
mt['getmethod']  = mt['getfield']
mt['setmethod']  = mt['getfield']
mt['getindex']   = mt['getfield']
mt['setindex']   = mt['getfield']
mt['field']      = require 'core.field'
mt['method']     = require 'core.method'
mt['index']      = require 'core.index'
mt['number']     = require 'core.number'
mt['boolean']    = require 'core.boolean'
mt['string']     = require 'core.string'
mt['table']      = require 'core.table'
mt['select']     = require 'core.select'
mt['goto']       = require 'core.goto'
mt['label']      = require 'core.label'

local specials = {
    ['_G']           = true,
    ['rawset']       = true,
    ['rawget']       = true,
    ['setmetatable'] = true,
}

function mt:getSpecialName(source)
    local spName = self.cache.specialName[source]
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
    self:eachValue(source, getName)
    self.cache.specialName[source] = spName or false
    return spName
end

function mt:eachSpecial(callback)
    local cache = self.cache.special
    if cache then
        for i = 1, #cache do
            callback(cache[i][1], cache[i][2])
        end
        return
    end
    cache = {}
    self.cache.special = cache
    guide.eachSource(self.ast, function (source)
        if source.type == 'getlocal'
        or source.type == 'getglobal'
        or source.type == 'local'
        or source.type == 'field'
        or source.type == 'string' then
            local name = self:getSpecialName(source)
            if name then
                cache[#cache+1] = { name, source }
            end
        end
    end)
    for i = 1, #cache do
        callback(cache[i][1], cache[i][2])
    end
end

function mt:eachField(source, key, callback)
    local cache = self.cache.field[source]
    if cache and cache[key] then
        for i = 1, #cache[key] do
            callback(tableUnpack(cache[key][i]))
        end
        return
    end
    local tp = source.type
    local d = mt[tp]
    if not d then
        return
    end
    local f = d.field
    if not f then
        return
    end
    if self.step >= 100 then
        error('Stack overflow!')
        return
    end
    self.step = self.step + 1
    local mark = {}
    if not cache then
        cache = {}
        self.cache.field[source] = cache
    end
    cache[key] = {}
    f(self, source, key, function (src, ...)
        if mark[src] then
            return
        end
        mark[src] = true
        cache[key][#cache[key]+1] = { src, ... }
    end)
    for i = 1, #cache[key] do
        callback(tableUnpack(cache[key][i]))
    end
    self.step = self.step - 1
end

function mt:eachRef(source, callback)
    local cache = self.cache.ref[source]
    if cache then
        for i = 1, #cache do
            callback(tableUnpack(cache[i]))
        end
        return
    end
    local tp = source.type
    local d = mt[tp]
    if not d then
        return
    end
    local f = d.ref
    if not f then
        return
    end
    if self.step >= 100 then
        error('Stack overflow!')
        return
    end
    self.step = self.step + 1
    cache = {}
    self.cache.ref[source] = cache
    local mark = {}
    f(self, source, function (src, ...)
        if mark[src] then
            return
        end
        mark[src] = true
        cache[#cache+1] = {src, ...}
    end)
    for i = 1, #cache do
        callback(tableUnpack(cache[i]))
    end
    self.step = self.step - 1
end

function mt:eachDef(source, callback)
    local cache = self.cache.def[source]
    if cache then
        for i = 1, #cache do
            callback(tableUnpack(cache[i]))
        end
        return
    end
    local tp = source.type
    local d = mt[tp]
    if not d then
        return
    end
    local f = d.def
    if not f then
        return
    end
    if self.step >= 100 then
        error('Stack overflow!')
        return
    end
    self.step = self.step + 1
    cache = {}
    self.cache.def[source] = cache
    local mark = {}
    f(self, source, function (src, ...)
        if mark[src] then
            return
        end
        mark[src] = true
        cache[#cache+1] = {src, ...}
    end)
    for i = 1, #cache do
        callback(tableUnpack(cache[i]))
    end
    self.step = self.step - 1
end

function mt:eachValue(source, callback)
    local cache = self.cache.value[source]
    if cache then
        for i = 1, #cache do
            callback(tableUnpack(cache[i]))
        end
        return
    end
    local tp = source.type
    local d = mt[tp]
    if not d then
        return
    end
    local f = d.value
    if not f then
        return
    end
    if self.step >= 100 then
        error('Stack overflow!')
        return
    end
    self.step = self.step + 1
    cache = {}
    self.cache.value[source] = cache
    local mark = {}
    f(self, source, function (src, ...)
        if mark[src] then
            return
        end
        mark[src] = true
        cache[#cache+1] = {src, ...}
    end)
    for i = 1, #cache do
        callback(tableUnpack(cache[i]))
    end
    self.step = self.step - 1
end

function mt:callArgOf(source)
    if not source or source.type ~= 'call' then
        return
    end
    local args = source.args
    if not args then
        return
    end
    return tableUnpack(args)
end

function mt:callReturnOf(source)
    if not source or source.type ~= 'call' then
        return
    end
    local parent = source.parent
    local extParent = source.extParent
    if extParent then
        local returns = {parent.parent}
        for i = 1, #extParent do
            returns[i+1] = extParent[i].parent
        end
        return tableUnpack(returns)
    elseif parent then
        return parent.parent
    end
end

function mt:childMode(source)
    if     source.type == 'getfield' then
        return source.field, 'get'
    elseif source.type == 'setfield' then
        return source.field, 'set'
    elseif source.type == 'getmethod' then
        return source.method, 'get'
    elseif source.type == 'setmethod' then
        return source.method, 'set'
    elseif source.type == 'getindex' then
        return source.index, 'get'
    elseif source.type == 'setindex' then
        return source.index, 'set'
    elseif source.type == 'field' then
        return self:childMode(source.parent)
    elseif source.type == 'method' then
        return self:childMode(source.parent)
    end
    return nil, nil
end

return function (ast)
    local self = setmetatable({
        step  = 0,
        ast   = ast.ast,
        cache = {
            def   = {},
            ref   = {},
            field = {},
            value = {},
            specialName = {},
        },
    }, mt)
    return self
end
