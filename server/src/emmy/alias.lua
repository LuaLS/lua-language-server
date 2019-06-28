local listMgr = require 'vm.list'

---@class EmmyAlias
local mt = {}
mt.__index = mt
mt.type = 'emmy.alias'

function mt:getName()
    return self.name
end

function mt:getSource()
    return listMgr.get(self.source)
end

function mt:bindType(type)
    if type then
        self._bindType = type
    else
        return self._bindType
    end
end

function mt:addEnum(enum)
    self._enum[#self._enum+1] = enum
end

function mt:eachEnum(callback)
    for _, enum in ipairs(self._enum) do
        callback(enum)
    end
end

return function (manager, source)
    local self = setmetatable({
        name = source[1][1],
        source = source.id,
        _manager = manager,
        _enum = {},
    }, mt)
    return self
end
