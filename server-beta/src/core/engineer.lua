local guide  = require 'parser.guide'
local config = require 'config'

local type         = type
local setmetatable = setmetatable
local ipairs       = ipairs

_ENV = nil

---@class engineer
local mt = {}
mt.__index = mt
mt.type = 'engineer'

--- 查找所有局部变量引用
function mt:eachRefAsLocal(obj, callback)
    callback(obj, 'local')
    if obj.ref then
        for _, ref in ipairs(obj.ref) do
            if ref.type == 'setlocal' then
                callback(ref, 'set')
            elseif ref.type == 'getlocal' then
                callback(ref, 'get')
            end
        end
    end
end

--- 查找所有域的引用
function mt:eachRefAsField(obj, callback)
    local node = obj.node
    guide.eachFieldOf(node, guide.getKeyName(obj), function (value)
        local tp = value.type
        if tp == 'setglobal' or tp == 'setfield' then
            callback(value, 'set')
        elseif tp == 'getglobal' or tp == 'getfield' then
            callback(value, 'get')
        end
    end)
end

--- 查找所有引用
function mt:eachRef(obj, callback)
    if obj.type == 'local' then
        self:eachRefAsLocal(obj, callback)
    elseif obj.type == 'getlocal' or obj.type == 'setlocal' then
        self:eachRefAsLocal(obj.loc, callback)
    elseif obj.type == 'setglobal' or obj.type == 'getglobal' then
        self:eachRefAsField(obj, callback)
    end
end

return function (ast)
    if not ast.vm then
        ast.vm = {}
    end
    local self = setmetatable({
        step = 0,
        ast  = ast.ast,
    }, mt)
    return self
end
