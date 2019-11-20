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

local function getLibInNode(source, nodeLib)
    if not nodeLib then
        return nil
    end
    if not nodeLib.child then
        return nil
    end
    local key = guide.getKeyString(source)
    local defLib = nodeLib.child[key]
    return defLib
end

local function getNodeAsTable(source)
    local node = source.node
    local nodeGlobalName = vm.getGlobal(node)
    if not nodeGlobalName then
        return nil
    end
    local nodeName = nodeGlobalName:match '^s|(.+)$'
    return getLibInNode(source, library.global[nodeName])
end

local function getNodeAsObject(source)
    local node = source.node
    local values = vm.getValue(node)
    if not values then
        return nil
    end
    for i = 1, #values do
        local value = values[i]
        local type = value.type
        local nodeLib = library.object[type]
        local lib = getLibInNode(source, nodeLib)
        if lib then
            return lib
        end
    end
    return nil
end

local function checkNode(source)
    if  source.type ~= 'getfield'
    and source.type ~= 'getmethod'
    and source.type ~= 'getindex' then
        return nil
    end
    return getNodeAsTable(source)
        or getNodeAsObject(source)
end

local function getLibrary(source)
    local lib = checkStdLibrary(source)
    if lib then
        return lib
    end
    return checkNode(source) or vm.eachRef(source, function (info)
        return checkNode(info.source)
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
