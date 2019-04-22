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

function mt:getClass()
    local class = self._manager:eachClass(self.name, function (class)
        if class.type == 'emmy.class' then
            return class
        end
    end)
    return class
end

function mt:setValue(value)
    self.value = value
end

function mt:getValue()
    return self.value
end

return function (manager, source)
    local self = setmetatable({
        name = buildName(source),
        source = source.id,
        _manager = manager,
    }, mt)
    return self
end
