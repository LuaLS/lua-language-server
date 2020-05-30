local vm    = require 'vm.vm'
local guide = require 'parser.guide'

local function eachDef(source)
    local lib = vm.getLibrary(source)
    local value = guide.getObjectValue(source)
    local results = guide.requestDefinition(source)
    if lib then
        results[#results+1] = lib
    end
    if value then
        vm.eachDef(value, function (res)
            results[#results+1] = res
        end)
    end
    return results
end

function vm.eachDef(source, callback)
    local cache = vm.cache.eachDef[source]
    if cache ~= nil then
        for i = 1, #cache do
            callback(cache[i])
        end
        return
    end
    local unlock = vm.lock('eachDef', source)
    if not unlock then
        return
    end
    cache = eachDef(source) or false
    vm.cache.eachDef[source] = cache
    unlock()
    for i = 1, #cache do
        callback(cache[i])
    end
end
