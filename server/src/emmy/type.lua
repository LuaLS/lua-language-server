local listMgr = require 'vm.list'

local function buildName(source)
    local names = {}
    for i, type in ipairs(source) do
        names[i] = type[1]
    end
    return table.concat(names, '|')
end

local mt = {}
mt.__index = mt
mt.type = 'emmy.type'

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
        name = buildName(source),
        source = source.id,
    }, mt)
    return self
end
