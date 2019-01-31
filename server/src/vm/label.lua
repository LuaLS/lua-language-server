local mt = {}
mt.__index = mt
mt.type = 'label'

function mt:getName()
    return self.name
end

return function (name, source)
    local self = setmetatable({
        name = name,
        source = source,
    }, mt)
    return self
end
