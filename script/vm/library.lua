---@class vm
local vm      = require 'vm.vm'

function vm.getLibraryName(source)
    if source.special then
        return source.special
    end
    local defs = vm.getDefs(source)
    for _, def in ipairs(defs) do
        if def.special then
            return def.special
        end
    end
    return nil
end
