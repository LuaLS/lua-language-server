local guide    = require 'parser.guide'
local files    = require 'files'
local util     = require 'utility'
local getValue = require 'searcher.getValue'
local getField = require 'searcher.getField'
local eachRef  = require 'searcher.eachRef'

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

--- 获取关联的值
---@param source table
---@return value table
function mt:getValue(source)
    local lock <close> = self:lock('getValue', source)
    if not lock then
        return nil
    end
    return getValue(self, source)
end

--- 获取关联的field
---@param source table
---@return table field
function mt:getField(source)
    return getField(self, source)
end

--- 获取所有的定义（不递归）
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
    eachRef(self, source, function (info)
        cache[#cache+1] = info
        callback(info)
    end)
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
            eachRef  = {},
        },
        locked = {
            getValue = {},
            eachRef  = {},
        }
    }, mt)
    return searcher
end

return m
