local listMgr = require 'vm.list'

---@class EmmyTableType
local mt = {}
mt.__index = mt
mt.type = 'emmy.tableType'

function mt:getType()
    return 'table'
end

function mt:getKeyType()
    return self.keyType
end

function mt:getValueType()
    return self.valueType
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

return function (manager, source, keyType, valueType)
    local self = setmetatable({
        source = source.id,
        keyType = keyType,
        valueType = valueType,
        _manager = manager,
    }, mt)
    return self
end
