local listMgr = require 'vm.list'

local function buildName(source)
    local names = {}
    for i, type in ipairs(source) do
        if type.type == 'emmyName' then
            names[i] = type[1]
        elseif type.type == 'emmyArrayType' then
            names[i] = type[1][1]..'[]'
        end
    end
    return table.concat(names, '|')
end

---@class EmmyType
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

function mt:eachClass(callback)
    for _, typeUnit in ipairs(self._childs) do
        ---@type EmmyTypeUnit
        local emmyTypeUnit = typeUnit
        emmyTypeUnit:getClass(callback)
    end
end

function mt:setValue(value)
    self.value = value
    for _, typeUnit in ipairs(self._childs) do
        typeUnit:setValue(value)
    end
end

function mt:getValue()
    return self.value
end

return function (manager, source)
    local self = setmetatable({
        name = buildName(source),
        source = source.id,
        _manager = manager,
        _childs = {},
    }, mt)
    return self
end
