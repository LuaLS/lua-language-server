local guide  = require 'parser.guide'
local config = require 'config'

local type         = type
local setmetatable = setmetatable

_ENV = nil

---@class engineer
local mt = {}
mt.__index = mt
mt.type = 'engineer'

function mt:call(method, obj, ...)
    self.step = self.step + 1
    if self.step > 100 then
        return nil
    end
    if not obj then
        return nil
    end
    if ... == nil and obj['_'..method] ~= nil then
        return obj['_'..method]
    end
    local res = self[method](self, obj, ...)
    self.step = self.step - 1
    if ... == nil then
        obj['_'..method] = res
    end
    return res
end

--- 根据变量名，遍历全局变量
function mt:eachGloablOfName(name, callback)
    if type(name) ~= 'string' then
        return
    end
    guide.eachSourceOf(self.ast.root, {
        ['setglobal'] = function (source)
            if source[1] == name then
                callback(source, 'set')
            end
        end,
        ['getglobal'] = function (source)
            if source[1] == name then
                callback(source, 'get')
            end
        end,
        ['setfield'] = function (source)
            if source.field[1] ~= name then
                return
            end
            if self:call('isGlobalField', source) then
                callback(source, 'set')
            end
        end,
        ['getfield'] = function (source)
            if source.field[1] ~= name then
                return
            end
            if self:call('isGlobalField', source) then
                callback(source, 'get')
            end
        end,
        ['call'] = function (source)
            local d = self:call('asRawSet', source)
            if d then
                if self:call('getLiteral', d.k) == name then
                    callback(source, 'set')
                end
            end
            local d = self:call('asRawGet', source)
            if d then
                if self:call('getLiteral', d.k) == name then
                    callback(source, 'get')
                end
            end
        end,
    })
end

--- 是否是全局变量
function mt:isGlobal(obj)
    if obj.type == 'getglobal' then
        return true
    end
    if obj.type == 'getfield' then
        return self:call('isGlobalField', obj)
    end
    if obj.type == 'call' then
        local d = self:call('asRawGet', obj)
        return not not d
    end
    return false
end

--- 是否是指定名称的全局变量
function mt:isGlobalOfName(obj, name)
    if not self:call('isGlobal', obj) then
        return false
    end
    return self:call('getName', obj) == name
end

--- 获取名称
function mt:getName(obj)
    if obj.type == 'setglobal' or obj.type == 'getglobal' then
        return obj[1]
    elseif obj.type == 'setfield' or obj.type == 'getfield' then
        return obj.field[1]
    elseif obj.type == 'local' or obj.type == 'setlocal' or obj.type == 'getlocal' then
        return obj[1]
    end
    return false
end

--- 获取字面量值
function mt:getLiteral(obj)
    if obj.type == 'number' then
        return obj[1]
    elseif obj.type == 'boolean' then
        return obj[1]
    elseif obj.type == 'string' then
        return obj[1]
    end
    return nil
end

--- 是否是全局field
---|_G.xxx
---|_ENV.xxx
---|_ENV._G.xxx
function mt:isGlobalField(obj)
    local node = self.ast.root[obj.node]
    if self:call('isG', node) then
        return true
    end
    if self:call('isENV', node) then
        return true
    end
    return false
end

--- 是否是_ENV
function mt:isENV(obj)
    local version = config.config.runtime.version
    if version == 'Lua 5.1' or version == 'LuaJIT' then
        return false
    end
    if self:isGlobalOfName(obj, '_ENV') then
        return true
    end
    return false
end

--- 是否是_G
function mt:isG(obj)
    if self:isGlobalOfName(obj, '_G') then
        return true
    end
    return false
end

--- 获取call的参数
function mt:getCallArg(obj, i)
    local args = self.ast.root[obj.args]
    if not args then
        return nil
    end
    return self.ast.root[args[i]]
end

--- 获取rawset信息
function mt:asRawSet(obj)
    local node = self.ast.root[obj.node]
    if not self:isGlobalOfName(node, 'rawset') then
        return false
    end
    return {
        t = self:getCallArg(obj, 1),
        k = self:getCallArg(obj, 2),
        v = self:getCallArg(obj, 3),
    }
end

--- 获取rawget信息
function mt:asRawGet(obj)
    local node = self.ast.root[obj.node]
    if not self:isGlobalOfName(node, 'rawget') then
        return false
    end
    return {
        t = self:getCallArg(obj, 1),
        k = self:getCallArg(obj, 2),
    }
end

--- 根据指定的局部变量，遍历局部变量引用
function mt:eachLocalRef(obj, callback)
    if not obj then
        return
    end
    local src
    if obj.type == 'local' then
        src = obj
    elseif obj.type == 'getlocal' or obj.type == 'setlocal' then
        src = self.ast.root[obj.loc]
    else
        return
    end
    callback(src, 'local')
    if src.ref then
        for i = 1, #src.ref do
            local ref = src.ref[i]
            local refObj = self.ast.root[ref]
            if refObj.type == 'setlocal' then
                callback(refObj, 'set')
            elseif refObj.type == 'getlocal' then
                callback(refObj, 'get')
            end
        end
    end
end

--- 遍历class
function mt:eachClass(obj, callback)
    local root = self.ast.root
    if obj.type == 'setlocal' or obj.type == 'getlocal' then
        local loc = root[obj.loc]
        local setmethod = root[loc.method]
        if setmethod then
            local node = root[setmethod.node]
            self:call('eachLocalRef', node, function (src, mode)
                if mode == 'local' or mode == 'set' then
                    callback(src)
                end
            end)
        end
    end
end

return function (ast)
    local self = setmetatable({
        step = 0,
        ast  = ast,
    }, mt)
    return self
end
