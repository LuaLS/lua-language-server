local env = require 'vm.env'
local createDots = require 'vm.dots'

local mt = {}
mt.__index = mt
mt.type = 'function'
mt._returnDots = false

function mt:getUri()
    return self.source.uri
end

function mt:saveLocal(name, loc)
    self.locals[name] = loc
end

function mt:setReturn(index, value)
    self.returns[index] = value
end

function mt:returnDots(index, value)
    self.returns[index] = value
    self._returnDots = true
end

return function (source)
    if not source then
        error('Function must has a source')
    end
    local self = setmetatable({
        source = source,
        locals = {},
        returns = {},
    }, mt)
    return self
end
