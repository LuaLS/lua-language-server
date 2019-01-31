local function getDefaultSource()
    return {
        start = 0,
        finish = 0,
        uri = '',
    }
end

local mt = {}
mt.__index = mt
mt.type = 'local'

function mt:setValue(value)
    if self.value then
        self.value:mergeValue(value)
    else
        self.value = value
    end
end

function mt:getValue()
    return self.value
end

function mt:addInfo(tp, source)
    self[#self+1] = {
        type = tp,
        source = source,
    }
end

function mt:eachInfo(callback)
    for _, info in ipairs(self) do
        callback(info)
    end
end

return function (name, source, value)
    local self = setmetatable({
        name = name,
        source = source or getDefaultSource(),
        value = value,
    }, mt)
    return self
end
