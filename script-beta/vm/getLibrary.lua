local vm      = require 'vm.vm'
local library = require 'library'
local guide   = require 'parser.guide'

local function checkStdLibrary(source)
    if source.library then
        return source
    end
    if source.type == 'getglobal'
    or source.type == 'setglobal' then
        local name = guide.getName(source)
        return library.global[name]
    elseif source.type == 'select' then
        local call = source.vararg
        if call.type ~= 'call' then
            goto CONTINUE
        end
        local func = call.node
        local lib = vm.getLibrary(func)
        if not lib then
            goto CONTINUE
        end
        if lib.name == 'require' then
            local modName = call.args[1]
            if modName and modName.type == 'string' then
                return library.library[modName[1]]
            end
        end
        ::CONTINUE::
    end
end

local function getLibInNode(source, nodeLib)
    if not nodeLib then
        return nil
    end
    if not nodeLib.child then
        return nil
    end
    local key = guide.getName(source)
    local defLib = nodeLib.child[key]
    return defLib
end

local function getNodeAsTable(source)
    local nodeLib = checkStdLibrary(source.node)
    return getLibInNode(source, nodeLib)
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
    if source.type == 'method' then
        source = source.parent
    elseif source.type == 'field' then
        source = source.parent
    end
    if source.type == 'getfield'
    or source.type == 'getmethod'
    or source.type == 'getindex' then
        return getNodeAsTable(source)
            or getNodeAsObject(source)
    end
end

local function checkRef(source)
    local results = guide.requestReference(source)
    for _, src in ipairs(results) do
        local lib = checkStdLibrary(src) or checkNode(src)
        if lib then
            return lib
        end
    end
    return nil
end

local function getLibrary(source)
    return checkNode(source)
        or checkStdLibrary(source)
        or checkRef(source)
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
