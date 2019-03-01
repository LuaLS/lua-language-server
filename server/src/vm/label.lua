local function getDefaultSource()
    return {
        start = 0,
        finish = 0,
        uri = '',
    }
end

local mt = {}
mt.__index = mt
mt.type = 'label'

function mt:getName()
    return self.name
end

function mt:addInfo(tp, source)
    if source and not source.start then
        error('Miss start: ' .. table.dump(source))
    end
    self[#self+1] = {
        type = tp,
        source = source or getDefaultSource(),
    }
end

function mt:eachInfo(callback)
    for _, info in ipairs(self) do
        local res = callback(info)
        if res ~= nil then
            return res
        end
    end
    return nil
end

return function (name, source)
    local self = setmetatable({
        name = name,
        source = source,
    }, mt)
    return self
end
