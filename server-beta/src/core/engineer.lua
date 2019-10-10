local guide       = require 'parser.guide'
local require     = require
local tableUnpack = table.unpack

local setmetatable = setmetatable

_ENV = nil
---@class engineer
local mt = {}
mt.__index = mt
mt.type = 'engineer'

mt['local']     = require 'core.local'
mt['getlocal']  = require 'core.getlocal'
mt['setlocal']  = mt['getlocal']
mt['getglobal'] = require 'core.getglobal'
mt['setglobal'] = mt['getglobal']
mt['field']     = require 'core.field'
mt['method']    = require 'core.method'
mt['number']    = require 'core.number'
mt['boolean']   = require 'core.boolean'
mt['string']    = require 'core.string'
mt['table']     = require 'core.table'

function mt:getSpecialName(source)
    if source.type == 'getglobal' then
        local node = source.node
        if node.tag ~= '_ENV' then
            return
        end
        local name = guide.getKeyName(source)
        if name:sub(1, 2) ~= 's|' then
            return nil
        end
        return name:sub(3)
    elseif source.type == 'local' then
        if source.tag == '_ENV' then
            return '_G'
        end
        return nil
    elseif source.type == 'getlocal' then
        local loc = source.loc
        if loc.tag == '_ENV' then
            return '_G'
        end
    end
end

function mt:eachSpecial(callback)
    local env = guide.getENV(self.ast)
    if not env then
        return
    end
    local refs = env.ref
    if not refs then
        return
    end
    for i = 1, #refs do
        local ref = refs[i]
        if ref.type == 'getglobal' then
            callback(ref[1], ref)
        end
    end
end

function mt:eachField(source, key, callback)
    local tp = source.type
    local d = mt[tp]
    if not d then
        return
    end
    local f = d.field
    if not f then
        return
    end
    f(self, source, key, callback)
end

function mt:eachRef(source, callback)
    local tp = source.type
    local d = mt[tp]
    if not d then
        return
    end
    local f = d.ref
    if not f then
        return
    end
    f(self, source, callback)
end

function mt:eachDef(source, callback)
    local tp = source.type
    local d = mt[tp]
    if not d then
        return
    end
    local f = d.def
    if not f then
        return
    end
    f(self, source, callback)
end

function mt:childDef(source, callback)
    local tp = source.type
    if     tp == 'setfield' then
        callback(source.field, 'set')
    elseif tp == 'setmethod' then
        callback(source.method, 'set')
    elseif tp == 'setindex' then
        callback(source.index, 'set')
    end
end

function mt:childRef(source, callback)
    local tp = source.type
    if     tp == 'setfield' then
        callback(source.field, 'set')
    elseif tp == 'setmethod' then
        callback(source.method, 'set')
    elseif tp == 'setindex' then
        callback(source.index, 'set')
    elseif tp == 'getfield' then
        callback(source.field, 'get')
    elseif tp == 'getmethod' then
        callback(source.method, 'get')
    elseif tp == 'getindex' then
        callback(source.index, 'get')
    end
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

return function (ast)
    local self = setmetatable({
        step  = 0,
        ast   = ast.ast,
        cache = {},
    }, mt)
    return self
end
