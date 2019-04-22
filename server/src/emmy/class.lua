local listMgr = require 'vm.list'

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
        if obj.type == 'emmy.type' then
            callback(obj)
        end
    end)
end

return function (manager, source)
    local self = setmetatable({
        name = source[1][1],
        source = source.id,
        extends = source[2] and source[2][1],
        _manager = manager,
    }, mt)
    return self
end
