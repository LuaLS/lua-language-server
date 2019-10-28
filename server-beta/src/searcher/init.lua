local guide     = require 'parser.guide'
local files     = require 'files'
local util      = require 'utility'
local eachRef   = require 'searcher.eachRef'
local eachField = require 'searcher.eachField'

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
local mt = {}
mt.__index = mt
mt.__name = 'searcher'

function mt:lock(tp, source)
    if self.locked[tp][source] then
        return nil
    end
    self.locked[tp][source] = true
    return util.defer(function ()
        self.locked[tp][source] = nil
    end)
end

--- 获取所有的引用
function mt:eachRef(source, callback)
    local lock <close> = self:lock('eachRef', source)
    if not lock then
        return
    end
    local cache = self.cache.eachRef[source]
    if cache then
        for i = 1, #cache do
            callback(cache[i])
        end
        return
    end
    cache = {}
    self.cache.eachRef[source] = cache
    local mark = {}
    eachRef(self, source, function (info)
        local src = info.source
        if mark[src] then
            return
        end
        mark[src] = true
        cache[#cache+1] = info
        callback(info)
    end)
end

--- 获取所有的field
function mt:eachField(source, callback)
    local lock <close> = self:lock('eachField', source)
    if not lock then
        return
    end
    local cache = self.cache.eachField[source]
    if cache then
        for i = 1, #cache do
            callback(cache[i])
        end
        return
    end
    cache = {}
    self.cache.eachField[source] = cache
    local mark = {}
    eachField(self, source, function (info)
        local src = info.source
        if mark[src] then
            return
        end
        mark[src] = true
        cache[#cache+1] = info
        callback(info)
    end)
end

--- 获取特殊对象的名字
function mt:getSpecialName(source)
    local spName = self.cache.specialName[source]
    if spName ~= nil then
        if spName then
            return spName
        end
        return nil
    end
    local function getName(info)
        local src = info.source
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
    self:eachRef(source, getName)
    self.cache.specialName[source] = spName or false
    return spName
end

--- 遍历特殊对象
---@param callback fun(name:string, source:table)
function mt:eachSpecial(callback)
    local cache = self.cache.specials
    if cache then
        for i = 1, #cache do
            callback(cache[i][1], cache[i][2])
        end
        return
    end
    cache = {}
    self.cache.specials = cache
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

---@class engineer
local m = {}

--- 新建搜索器
---@param uri string
---@return searcher
function m.create(uri)
    local ast = files.getAst(uri)
    local searcher = setmetatable({
        ast  = ast.ast,
        uri  = uri,
        cache = {
            eachRef     = {},
            eachField   = {},
            specialName = {},
            specials    = nil,
        },
        locked = {
            eachRef   = {},
            eachField = {},
        }
    }, mt)
    return searcher
end

return m
