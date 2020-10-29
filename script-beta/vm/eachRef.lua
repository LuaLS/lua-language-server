local vm     = require 'vm.vm'
local guide  = require 'parser.guide'
local util   = require 'utility'
local await  = require 'await'

local function getRefs(source, deep)
    local results = {}
    local lock = vm.lock('eachRef', source)
    if not lock then
        return results
    end

    await.delay()

    local clock = os.clock()
    local myResults, count = guide.requestReference(source, vm.interface, deep)
    if DEVELOP and os.clock() - clock > 0.1 then
        log.warn('requestReference', count, os.clock() - clock, guide.getUri(source), util.dump(source, { deep = 1 }))
    end
    vm.mergeResults(results, myResults)

    lock()

    return results
end

function vm.getRefs(source, deep)
    if guide.isGlobal(source) then
        local name = guide.getKeyName(source)
        local cache =  vm.getCache('eachRefOfGlobal')[name]
                    or vm.getCache('eachRef')[source]
                    or getRefs(source, 'deep')
        vm.getCache('eachRefOfGlobal')[name] = cache
        vm.getCache('eachRef')[source] = cache
        return cache
    else
        local cache =  vm.getCache('eachRef')[source]
                    or getRefs(source, deep)
        if deep then
            vm.getCache('eachRef')[source] = cache
        end
        return cache
    end
end
