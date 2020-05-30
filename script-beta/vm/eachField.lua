local vm      = require 'vm.vm'
local guide   = require 'parser.guide'
local library = require 'library'

local function eachFieldInTableLibrary(source, lib, results)
    if not lib or lib.type ~= 'table' or not lib.child then
        return
    end
    for _, value in pairs(lib.child) do
        results[#results+1] = value
    end
end

local function eachFieldOfLibrary(results)
    for _, lib in pairs(library.global) do
        results[#results+1] = lib
    end
end

local function eachField(source)
    local results = guide.requestFields(source)
    local lib = vm.getLibrary(source)
    if lib then
        eachFieldInTableLibrary(source, lib, results)
    end
    if source.special == '_G' then
        eachFieldOfLibrary(results)
    end
    return results
end

function vm.eachField(source, callback)
    local cache = vm.cache.eachField[source]
    if cache ~= nil then
        for i = 1, #cache do
            callback(cache[i])
        end
        return
    end
    local unlock = vm.lock('eachField', source)
    if not unlock then
        return
    end
    cache = eachField(source) or false
    vm.cache.eachField[source] = cache
    unlock()
    for i = 1, #cache do
        callback(cache[i])
    end
end
