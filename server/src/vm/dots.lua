local createValue = require 'vm.value'

local mt = {}
mt.__index = mt
mt.type = 'dots'

function mt:set(n, value)
    self[n] = value
end

function mt:get(expect)
    local result = {}
    if expect then
        for i = 1, expect do
            result[i] = self[i] or createValue('any')
        end
    else
        for i = 1, #self do
            result[i] = self[i]
        end
    end
    return result
end

return function ()
    local self = setmetatable({}, mt)
    return self
end
