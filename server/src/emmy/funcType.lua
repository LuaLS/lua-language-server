local listMgr = require 'vm.list'

---@class EmmyFunctionType
local mt = {}
mt.__index = mt
mt.type = 'emmy.functionType'

function mt:getType()
    return 'function'
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

function mt:addParam(name, type)
    self._params[#self._params+1] = { name, type }
end

function mt:addReturn(type)
    self._return = type
end

function mt:eachParam(callback)
    for _, data in ipairs(self._params) do
        callback(data[1], data[2])
    end
end

function mt:getReturn()
    return self._return
end

return function (manager, source)
    local self = setmetatable({
        source = source.id,
        _params = {},
        _manager = manager,
    }, mt)
    return self
end
