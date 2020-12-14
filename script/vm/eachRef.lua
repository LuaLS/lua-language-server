---@type vm
local vm     = require 'vm.vm'
local guide  = require 'parser.guide'
local util   = require 'utility'
local await  = require 'await'
local config = require 'config'

local function getRefs(source, deep)
    local results = {}
    local lock = vm.lock('eachRef', source)
    if not lock then
        return results
    end

    await.delay()

    deep = config.config.intelliSense.searchDepth + (deep or 0)

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
    deep = deep or -999
    if guide.isGlobal(source) then
        local key = guide.getKeyName(source)
        return vm.getGlobals(key)
    else
        local cache =  vm.getCache('eachRef')[source]
        if not cache or cache.deep < deep then
            cache = getRefs(source, deep)
            cache.deep = deep
            vm.getCache('eachRef')[source] = cache
        end
        return cache
    end
end
