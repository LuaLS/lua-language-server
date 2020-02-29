local listMgr = require 'vm.list'

---@class EmmyTypeUnit
local mt = {}
mt.__index = mt
mt.type = 'emmy.typeUnit'

function mt:getType()
    return self.name
end

function mt:getName()
    return self.name
end

function mt:getSource()
    return listMgr.get(self.source)
end

function mt:getClass(callback)
    self._manager:eachClass(self:getName(), function (class)
        if class.type == 'emmy.class' then
            callback(class)
        end
    end)
end

function mt:setValue(value)
    self.value = value
end

function mt:getValue()
    return self.value
end

function mt:setParent(parent)
    self.parent = parent
end

function mt:getParent()
    return self.parent
end

return function (manager, source)
    local self = setmetatable({
        name = source[1],
        source = source.id,
        _manager = manager,
    }, mt)
    return self
end
