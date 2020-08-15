local vm     = require 'vm.vm'
local guide  = require 'parser.guide'
local util   = require 'utility'
local await  = require 'await'

local function getRefs(source, results)
    results = results or {}
    local lock = vm.lock('eachDef', source)
    if not lock then
        return results
    end

    await.delay()

    local clock = os.clock()
    local myResults, count = guide.requestReference(source, vm.interface)
    if DEVELOP and os.clock() - clock > 0.1 then
        log.warn('requestReference', count, os.clock() - clock, guide.getRoot(source).uri, util.dump(source, { deep = 1 }))
    end
    vm.mergeResults(results, myResults)

    lock()

    return results
end

function vm.getRefs(source)
    local cache = vm.getCache('eachRef')[source] or getRefs(source)
    vm.getCache('eachRef')[source] = cache
    return cache
end

function vm.eachRef(source, callback)
    local results = vm.getRefs(source)
    for i = 1, #results do
        callback(results[i])
    end
end
