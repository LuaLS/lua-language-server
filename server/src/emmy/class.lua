local listMgr = require 'vm.list'

---@class EmmyClass
local mt = {}
mt.__index = mt
mt.type = 'emmy.class'

function mt:getType()
    return self.name
end

function mt:getName()
    return self.name
end

function mt:getSource()
    return listMgr.get(self.source)
end

function mt:setValue(value)
    self.value = value
end

function mt:getValue()
    return self.value
end

function mt:eachChild(callback)
    self._manager:eachClass(self.name, function (obj)
        if obj.type == 'emmy.typeUnit' then
            callback(obj)
        end
    end)
end

function mt:addField(field)
    if not self._fields then
        self._fields = {}
    end
    self._fields[#self._fields+1] = field
end

function mt:eachField(callback)
    if not self._fields then
        return
    end
    ---@param field EmmyField
    for _, field in ipairs(self._fields) do
        callback(field)
    end
end

return function (manager, name, extends, source)
    local self = setmetatable({
        name = name,
        source = source.id,
        extends = extends,
        _manager = manager,
    }, mt)
    return self
end
