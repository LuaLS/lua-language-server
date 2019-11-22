---@class VM
local mt = {}
mt.__index = mt
mt.type = 'vm'
mt._version = -1

---@param version integer
function mt:setVersion(version)
    self._version = version
end

---@return integer
function mt:getVersion()
    return self._version
end

return mt
