local vm    = require 'vm.vm'
local guide = require 'parser.guide'

local m = {}

function m.searchDefAcrossRequire(results)

end

function m.mergeResults(a, b, mark)
    for _, r in ipairs(b) do
        if not mark[r] then
            mark[r] = true
            a[#a+1] = r
        end
    end
    return a
end

function m.eachDef(source, results, mark)
    results = results or {}
    mark    = mark    or {}
    if mark[source] then
        return results
    end

    m.mergeResults(results, guide.requestDefinition(source), mark)
    m.searchDefAcrossRequire(results)

    local lib = vm.getLibrary(source)
    if lib then
        results[#results+1] = lib
    end

    local value   = guide.getObjectValue(source)
    if value then
        m.eachDef(value, results, mark)
    end

    return results
end

function vm.eachDef(source, callback)
    local cache = vm.cache.eachDef[source] or m.eachDef(source)
    vm.cache.eachDef[source] = cache
    for i = 1, #cache do
        callback(cache[i])
    end
end
