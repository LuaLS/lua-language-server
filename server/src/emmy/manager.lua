local listMgr = require 'vm.list'
local newClass = require 'emmy.class'
local newType = require 'emmy.type'

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

function mt:addClass(source)
    local className = source[1][1]
    self:flushClass(className)
    local list = self._class[className]
    local version = listMgr.getVersion()
    if not list then
        list = {
            version = version,
        }
        self._class[className] = list
    end
    list[source.id] = newClass(source)
    return list[source.id]
end

function mt:createType(source)
    return newType(source)
end

return function ()
    ---@class emmyMgr
    local self = setmetatable({
        _class = {},
    }, mt)
    return self
end
