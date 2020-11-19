local vm    = require 'vm.vm'
local guide = require 'parser.guide'
local files = require 'files'
local util  = require 'utility'
local await = require 'await'

local function eachDef(source, deep)
    local results = {}
    local lock = vm.lock('eachDef', source)
    if not lock then
        return results
    end

    await.delay()

    local clock = os.clock()
    local myResults, count = guide.requestDefinition(source, vm.interface, deep)
    if DEVELOP and os.clock() - clock > 0.1 then
        log.warn('requestDefinition', count, os.clock() - clock, guide.getUri(source), util.dump(source, { deep = 1 }))
    end
    vm.mergeResults(results, myResults)

    lock()

    return results
end

function vm.getDefs(source, deep)
    if guide.isGlobal(source) then
        local key = guide.getKeyName(source)
        return vm.getGlobalSets(key)
    else
        local cache =  vm.getCache('eachDef')[source]
                    or eachDef(source, deep)
        if deep then
            vm.getCache('eachDef')[source] = cache
        end
        return cache
    end
end
