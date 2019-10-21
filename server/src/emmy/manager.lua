local listMgr      = require 'vm.list'
local sourceMgr    = require 'vm.source'
local newClass     = require 'emmy.class'
local newType      = require 'emmy.type'
local newTypeUnit  = require 'emmy.typeUnit'
local newAlias     = require 'emmy.alias'
local newParam     = require 'emmy.param'
local newReturn    = require 'emmy.return'
local newField     = require 'emmy.field'
local newGeneric   = require 'emmy.generic'
local newArrayType = require 'emmy.arrayType'
local newTableType = require 'emmy.tableType'
local newFuncType  = require 'emmy.funcType'

local mt = {}
mt.__index = mt
mt.__name = 'emmyMgr'

function mt:flushClass(name)
    local list = self._class[name]
    if not list then
        return
    end
    local version = listMgr.getVersion()
    if version == list.version then
        return
    end
    for srcId in pairs(list) do
        if not listMgr.get(srcId) then
            list[srcId] = nil
        end
    end
    if not next(list) then
        self._class[name] = nil
        return
    end
    list.version = version
end

function mt:eachClassByName(name, callback)
    self:flushClass(name)
    local list = self._class[name]
    if not list then
        return
    end
    for k, class in pairs(list) do
        if k ~= 'version' then
            local res = callback(class)
            if res ~= nil then
                return res
            end
        end
    end
end

function mt:eachClass(...)
    local n = select('#', ...)
    if n == 1 then
        local callback = ...
        for name in pairs(self._class) do
            local res = self:eachClassByName(name, callback)
            if res ~= nil then
                return res
            end
        end
    else
        local name, callback = ...
        return self:eachClassByName(name, callback)
    end
end

function mt:getClass(name)
    self:flushClass(name)
    local list = self._class[name]
    local version = listMgr.getVersion()
    if not list then
        list = {
            version = version,
        }
        self._class[name] = list
    end
    return list
end

function mt:newClass(name, extends, source)
    local list = self:getClass(name)
    list[source.id] = newClass(self, name, extends, source)
    return list[source.id]
end

function mt:addClass(source)
    local className = source[1][1]
    local extends = source[2] and source[2][1]
    local class = self:newClass(className, extends, source)
    return class
end

function mt:addType(source)
    local typeObj = newType(self, source)
    for i, obj in ipairs(source) do
        local typeUnit = newTypeUnit(self, obj)
        local className = obj[1]
        if className then
            local list = self:getClass(className)
            list[source.id] = typeUnit
        end
        typeUnit:setParent(typeObj)
        typeObj._childs[i] = typeUnit
        obj:set('emmy.typeUnit', typeUnit)
    end
    return typeObj
end

function mt:addArrayType(source)
    local typeObj = self:addType(source)
    local arrayTypeObj = newArrayType(self, source, typeObj)
    return arrayTypeObj
end

function mt:addTableType(source, keyType, valueType)
    local typeObj = newTableType(self, source, keyType, valueType)
    return typeObj
end

function mt:addFunctionType(source)
    local typeObj = newFuncType(self, source)
    return typeObj
end

function mt:addAlias(source, typeObj)
    local aliasName = source[1][1]
    local aliasObj = newAlias(self, source)
    aliasObj:bindType(typeObj)
    local list = self:getClass(aliasName)
    list[source.id] = aliasObj
    for i = 3, #source do
        aliasObj:addEnum(source[i])
    end
    return aliasObj
end

function mt:addParam(source, bind)
    local paramObj = newParam(self, source)
    if bind.type == 'emmy.generic' then
        paramObj:bindGeneric(bind)
    else
        paramObj:bindType(bind)
        self:eachClass(bind:getType(), function (class)
            if class.type == 'emmy.alias' then
                class:eachEnum(function (enum)
                    paramObj:addEnum(enum)
                end)
            end
        end)
    end
    for i = 3, #source do
        paramObj:addEnum(source[i])
    end
    paramObj:setOption(source.option)
    return paramObj
end

function mt:addReturn(source, bind, name)
    local returnObj = newReturn(self, source, name)
    if bind then
        if bind.type == 'emmy.generic' then
            returnObj:bindGeneric(bind)
        else
            returnObj:bindType(bind)
        end
    end
    return returnObj
end

function mt:addField(source, typeObj, value)
    local fieldObj = newField(self, source)
    fieldObj:bindType(typeObj)
    fieldObj:bindValue(value)
    return fieldObj
end

function mt:addGeneric(defs)
    local genericObj = newGeneric(self, defs)
    return genericObj
end

function mt:remove()
end

function mt:count()
    local count = 0
    for _, list in pairs(self._class) do
        for k in pairs(list) do
            if k ~= 'version' then
                count = count + 1
            end
        end
    end
    return count
end

return function ()
    ---@class emmyMgr
    local self = setmetatable({
        _class = {},
    }, mt)

    local source = sourceMgr.dummy()
    self:newClass('any',       nil,     source)
    self:newClass('string',   'any',    source)
    self:newClass('number',   'any',    source)
    self:newClass('integer',  'number', source)
    self:newClass('boolean',  'any',    source)
    self:newClass('table',    'any',    source)
    self:newClass('function', 'any',    source)
    self:newClass('nil',      'any',    source)
    self:newClass('userdata', 'any',    source)
    self:newClass('thread',   'any',    source)

    return self
end
