local vm    = require 'vm.vm'
local guide = require 'parser.guide'

local function eachFieldOfLibrary(source, lib, results)
    if not lib or lib.type ~= 'table' or not lib.child then
        return
    end
    for _, value in pairs(lib.child) do
        results[#results+1] =value
    end
end

local function eachField(source)
    local lib = vm.getLibrary(source)
    local results = guide.requestFields(source)
    eachFieldOfLibrary(source, lib, results)
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
