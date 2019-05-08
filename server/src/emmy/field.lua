local listMgr = require 'vm.list'

---@class EmmyField
local mt = {}
mt.__index = mt
mt.type = 'emmy.field'

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

function mt:bindValue(value)
    if value then
        self._bindValue = value
    else
        if self._bindValue then
            if not self._bindValue:getSource() then
                self._bindValue = nil
            end
        end
        return self._bindValue
    end
end

return function (manager, source)
    local self = setmetatable({
        name = source[2][1],
        source = source.id,
        visible = source[1],
        _manager = manager,
    }, mt)
    return self
end
