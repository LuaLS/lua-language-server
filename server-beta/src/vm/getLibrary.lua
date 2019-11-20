local vm      = require 'vm.vm'
local library = require 'library'
local guide   = require 'parser.guide'

local function checkStdLibrary(source)
    local globalName = vm.getGlobal(source)
    if not globalName then
        return nil
    end
    local name = globalName:match '^s|(.+)$'
    if library.global[name] then
        return library.global[name]
    end
end

local function getLibrary(source)
    local lib = checkStdLibrary(source)
    if lib then
        return lib
    end
    return vm.eachRef(source, function (info)
        local src = info.source
        if  src.type ~= 'getfield'
        and src.type ~= 'getmethod'
        and src.type ~= 'getindex' then
            return
        end
        local node = src.node
        local nodeGlobalName = vm.getGlobal(node)
        if not nodeGlobalName then
            return
        end
        local nodeName = nodeGlobalName:match '^s|(.+)$'
        local nodeLib = library.global[nodeName]
        if not nodeLib then
            return
        end
        if not nodeLib.child then
            return
        end
        local key = guide.getKeyString(src)
        local defLib = nodeLib.child[key]
        return defLib
    end)
end

function vm.getLibrary(source)
    local cache = vm.cache.getLibrary[source]
    if cache ~= nil then
        return cache
    end
    local unlock = vm.lock('getLibrary', source)
    if not unlock then
        return
    end
    cache = getLibrary(source) or false
    vm.cache.getLibrary[source] = cache
    unlock()
    return cache
end
