---@class Core
---@overload fun(): self
local M = Class 'Core'

function M:__init()
    local vm = luals.vm
    if not vm then
        vm = New 'VM' (luals.files)
        luals.vm = vm
    end
    self.vm = vm
end

require 'core.definition'

return M
