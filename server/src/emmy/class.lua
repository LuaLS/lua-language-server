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

return function (source)
    local self = setmetatable({
        name = source[1][1],
        source = source.id,
        extends = source[2] and source[2][1],
    }, mt)
    return self
end
