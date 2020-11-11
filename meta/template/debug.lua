---@class debug
debug = {}

function debug.debug() end

---@param o any
---@return table
function debug.getfenv(o) end

---@param co thread?
---@return function hook
---@return string mask
---@return integer count
function debug.gethook(co) end
