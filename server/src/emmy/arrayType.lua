local listMgr = require 'vm.list'

---@class EmmyArrayType
local mt = {}
mt.__index = mt
mt.type = 'emmy.arrayType'

function mt:getType()
    return 'table'
end

function mt:getName()
    return self.name
end

function mt:getSource()
    return listMgr.get(self.source)
end

function mt:setValue(value)
    self.value = value
    self:getSource():get('emmy.typeUnit'):setValue(value)
end

function mt:getValue()
    return self.value
end

return function (manager, source)
    local self = setmetatable({
        name = source[1],
        source = source.id,
        _manager = manager,
    }, mt)
    return self
end
