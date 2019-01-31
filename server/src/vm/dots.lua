local mt = {}
mt.__index = mt
mt.type = 'dots'

return function ()
    local self = setmetatable({}, mt)
    return self
end
