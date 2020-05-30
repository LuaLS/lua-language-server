local vm    = require 'vm.vm'
local guide = require 'parser.guide'

local function eachRef(source)
    local results = guide.requestReference(source)
    return results
end

function vm.eachRef(source, callback)
    local cache = vm.cache.eachRef[source]
    if cache ~= nil then
        for i = 1, #cache do
            callback(cache[i])
        end
        return
    end
    local unlock = vm.lock('eachRef', source)
    if not unlock then
        return
    end
    cache = eachRef(source) or false
    vm.cache.eachRef[source] = cache
    unlock()
    for i = 1, #cache do
        callback(cache[i])
    end
end
