local guide   = require 'parser.guide'
local require = require

local setmetatable = setmetatable
local ipairs       = ipairs

_ENV = nil
---@class engineer
local mt = {}
mt.__index = mt
mt.type = 'engineer'

mt['local']     = require 'core.local'
mt['getlocal']  = require 'core.getlocal'
mt['setlocal']  = mt['getlocal']
mt['_G']        = require 'core._G'
mt['getglobal'] = require 'core.getglobal'
mt['setglobal'] = mt['getglobal']
mt['field']     = require 'core.field'
mt['method']    = require 'core.method'
mt['number']    = require 'core.number'
mt['boolean']   = require 'core.boolean'
mt['string']    = require 'core.string'
mt['table']     = require 'core.table'

--mt['special'] = function (self, source, mode, callback)
--    local name = self:getSpecial(source)
--    if not name then
--        return
--    end
--    if mode == 'def' then
--        if name == 's|_G' then
--            self:search(source, '_G', mode, callback)
--        elseif name == 's|rawset' then
--            callback(source.parent, 'set')
--        end
--    end
--end
--mt['call'] = function (self, source, mode, callback)
--    local name = self:getSpecial(source)
--    if not name then
--        return
--    end
--    local parent = source.parent
--    if name == 's|setmetatable' then
--        if parent.index ~= 1 then
--            return
--        end
--        self:eachField(source.args[2], 's|__index', 'def', function (src)
--            self:eachField(src, nil, 'ref', callback)
--        end)
--        return
--    end
--end

function mt:getSpecial(source)
    local node = source.node
    if node.tag ~= '_ENV' then
        return nil
    end
    local name = guide.getKeyName(source)
    return name
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

return function (ast)
    local self = setmetatable({
        step = 0,
        ast  = ast.ast,
    }, mt)
    if not ast.vm then
        ast.vm = {}
    end
    return self
end
