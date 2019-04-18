local listMgr = require 'vm.list'
local newClass = require 'emmy.class'

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

function mt:eachClass(name, callback)
    self:flushClass(name)
    local list = self._class[name]
    if not list then
        return
    end
    for _, class in pairs(list) do
        callback(class)
    end
end

function mt:addClass(class, parent)
    local className = class[1]
    self:flushClass(className)
    local list = self._class[className]
    local version = listMgr.getVersion()
    if not list then
        list = {
            version = version,
        }
        self._class[className] = list
    end
    list[class.id] = newClass(class, parent)
    return list[class.id]
end

function mt:remove()
end

return function ()
    local self = setmetatable({
        _class = {},
    }, mt)
    return self
end
