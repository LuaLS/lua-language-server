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
    self._child:setValue(value)
end

function mt:getValue()
    return self.value
end

return function (manager, source, child)
    local self = setmetatable({
        name = child:getName(),
        source = source.id,
        _child = child,
        _manager = manager,
    }, mt)
    return self
end
