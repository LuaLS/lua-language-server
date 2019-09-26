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

--- 获取对象作为域时的名字
function mt:getFieldName(obj)
    if obj.type == 'getglobal' or obj.type == 'setglobal' then
        return obj[1]
    end
    return nil
end

--- 查找所有局部变量引用
function mt:eachRefAsLocal(obj, callback)
    callback(obj, 'local')
    if obj.ref then
        for _, ref in ipairs(obj.ref) do
            local refObj = self.root[ref]
            if refObj.type == 'setlocal' then
                callback(self.root[ref], 'set')
            elseif refObj.type == 'getlocal' then
                callback(self.root[ref], 'get')
            elseif refObj.type == 'setglobal' then
                callback(self.root[ref], 'settable', refObj)
            elseif refObj.type == 'getglobal' then
                callback(self.root[ref], 'gettable', refObj)
            end
        end
    end
end

--- 查找所有全局变量引用
function mt:eachRefAsGlobal(obj, callback)
    local version = config.config.runtime.version
    if version ~= 'Lua 5.1' and version ~= 'LuaJIT' then
        local env   = guide.getLocal(self.root, obj, '_ENV', obj.start)
        local field = self:getFieldName(obj)
        self:eachRefAsField(env, field, callback)
        return
    end
end

--- 查找所有域引用
function mt:eachRefAsField(parent, field, callback)
    self:eachRef(parent, function (src, mode)
        if self:getFieldName(src) ~= field then
            return
        end
        if mode == 'settable' then
            callback(src, 'set')
        elseif mode == 'gettable' then
            callback(src, 'get')
        end
    end)
end

--- 查找所有引用
function mt:eachRef(obj, callback)
    if obj.type == 'local' then
        self:eachRefAsLocal(obj, callback)
    elseif obj.type == 'getlocal' or obj.type == 'setlocal' then
        local loc = self.root[obj.loc]
        self:eachRefAsLocal(loc, callback)
    elseif obj.type == 'setglobal' or obj.type == 'getglobal' then
        self:eachRefAsGlobal(obj, callback)
    end
end

return function (ast)
    if not ast.vm then
        ast.vm = {}
    end
    local self = setmetatable({
        step = 0,
        root = ast.root,
        vm   = ast.vm,
    }, mt)
    return self
end
