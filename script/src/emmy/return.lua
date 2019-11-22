local listMgr = require 'vm.list'

---@class EmmyReturn
local mt = {}
mt.__index = mt
mt.type = 'emmy.return'

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

function mt:bindGeneric(generic)
    if generic then
        self._bindGeneric = generic
    else
        return self._bindGeneric
    end
end

return function (manager, source, name)
    local self = setmetatable({
        source = source.id,
        name   = name and name[1],
        option = source.option,
        _manager = manager,
    }, mt)
    return self
end
