local listMgr = require 'vm.list'

---@class EmmyGeneric
local mt = {}
mt.__index = mt
mt.type = 'emmy.generic'

function mt:getName()
    return self.name:getName()
end

function mt:setValue(value)
    self._value = value
end

function mt:getValue()
    return self._value
end

return function (manager, defs)
    for _, def in ipairs(defs) do
        setmetatable(def, mt)
        def._manager = manager
        def._binds = {}
    end
    return defs
end
