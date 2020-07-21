local vm    = require 'vm.vm'
local req   = require 'vm.getRequire'
local guide = require 'parser.guide'

local m = {}

function m.searchDefAcrossRequire(results)
    for _, source in ipairs(results) do

    end
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

function m.searchLibrary(source, results, mark)
    if not source then
        return
    end
    local lib = vm.getLibrary(source)
    if not lib then
        return
    end
    if mark[lib] then
        return
    end
    mark[lib] = true
    results[#results+1] = lib
end

function m.eachDef(source, results, mark)
    results = results or {}
    mark    = mark    or {}
    if mark[source] then
        return results
    end

    m.mergeResults(results, guide.requestDefinition(source), mark)
    m.searchLibrary(source, results, mark)
    m.searchLibrary(guide.getObjectValue(source), results, mark)
    m.searchDefAcrossRequire(results, mark)

    return results
end

function vm.eachDef(source, callback)
    local cache = vm.cache.eachDef[source] or m.eachDef(source)
    vm.cache.eachDef[source] = cache
    for i = 1, #cache do
        callback(cache[i])
    end
end
