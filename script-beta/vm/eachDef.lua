local vm    = require 'vm.vm'
local guide = require 'parser.guide'
local ws    = require 'workspace'
local files = require 'files'

local m = {}

function m.searchLibrary(source, results)
    if not source then
        return
    end
    local lib = vm.getLibrary(source)
    if not lib then
        return
    end
    vm.mergeResults(results, { lib })
end

function m.eachDef(source, results)
    results = results or {}
    local lock = vm.lock('eachDef', source)
    if not lock then
        return results
    end

    local myResults = guide.requestDefinition(source, vm.interface)
    vm.mergeResults(results, myResults)
    m.searchLibrary(source, results)
    m.searchLibrary(guide.getObjectValue(source), results)

    lock()

    return results
end

function vm.getDefs(source)
    local cache = vm.getCache('eachDef')[source] or m.eachDef(source)
    vm.getCache('eachDef')[source] = cache
    return cache
end

function vm.eachDef(source, callback)
    local results = vm.getDefs(source)
    for i = 1, #results do
        callback(results[i])
    end
end
