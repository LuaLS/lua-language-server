local vm      = require 'vm.vm'
local guide   = require 'parser.guide'

local function getLibrary(source)
    local defs = vm.getDefs(source)
    for _, def in ipairs(defs) do
        if def.type == 'library' then
            return def
        end
    end
    return nil
end

function vm.getLibrary(source)
    local cache = vm.getCache('getLibrary')[source]
    if cache ~= nil then
        return cache
    end
    local unlock = vm.lock('getLibrary', source)
    if not unlock then
        return
    end
    cache = getLibrary(source) or false
    vm.getCache('getLibrary')[source] = cache
    unlock()
    return cache
end
