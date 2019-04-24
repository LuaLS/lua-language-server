local listMgr = require 'vm.list'

---@class EmmyParam
local mt = {}
mt.__index = mt
mt.type = 'emmy.param'

function mt:getName()
    return self.name
end

function mt:getSource()
    return listMgr.get(self.source)
end

function mt:bindType(type)
    if type then
        self._bindType = type
    else
        return self._bindType
    end
end

return function (manager, source)
    local self = setmetatable({
        name = source[1][1],
        source = source.id,
        _manager = manager,
    }, mt)
    return self
end
