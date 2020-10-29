local vm      = require 'vm.vm'
local guide   = require 'parser.guide'
local library = require 'library'

local function getLibrary(source, deep)
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

    local unlock = vm.lock('getLibrary', source)
    if not unlock then
        return
    end

    local defs = vm.getDefs(source, deep)
    unlock()

    for _, def in ipairs(defs) do
        if def.type == 'library' then
            return def
        end
    end

    return nil
end

function vm.getLibrary(source, deep)
    if guide.isGlobal(source) then
        local name = guide.getKeyName(source)
        local cache =  vm.getCache('getLibraryOfGlobal')[name]
                    or vm.getCache('getLibrary')[source]
                    or getLibrary(source, 'deep')
        vm.getCache('getLibraryOfGlobal')[name] = cache
        vm.getCache('getLibrary')[source] = cache
        return cache
    else
        local cache =  vm.getCache('getLibrary')[source]
                    or getLibrary(source, deep)
        if deep then
            vm.getCache('getLibrary')[source] = cache
        end
        return cache
    end
end
