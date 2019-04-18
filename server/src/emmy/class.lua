local mt = {}
mt.__index = mt
mt.type = 'emmy.class'

function mt:getType()
    return self._name
end

return function (class, parent)
    local self = setmetatable({
        name = class[1],
        source = class.id,
        parent = parent and parent.id,
    })
    return self
end
