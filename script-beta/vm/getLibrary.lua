local vm      = require 'vm.vm'
local guide   = require 'parser.guide'
local library = require 'library'

local function getLibrary(source, simple)
    if source.type == 'library' then
        return source
    end
    if source.library then
        return source.library
    end
    if source.type == 'getglobal'
    or source.type == 'setglobal' then
        if source.node and source.node.type == 'local' then
            local lib = library.global[guide.getName(source)]
            if lib then
                return lib
            end
        end
    end
    local defs = vm.getDefs(source, simple)
    for _, def in ipairs(defs) do
        if def.type == 'library' then
            return def
        end
    end
    return nil
end

function vm.getLibrary(source, simple)
    if simple then
        return getLibrary(source, simple) or false
    end
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
