local DefaultSource = { start = 0, finish = 0 }

local mt = {}
mt.__index = mt
mt.type = 'value'

return function (tp, uri, source, value)
    if tp == '...' then
        error('Value type cant be ...')
    end
    -- TODO lib里的多类型
    if type(tp) == 'table' then
        tp = tp[1]
    end
    local self = setmetatable({
        type = tp,
        source = source or DefaultSource,
        value = value,
        uri = uri,
    }, mt)
    return self
end
