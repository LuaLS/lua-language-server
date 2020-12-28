---@type vm
local vm      = require 'vm.vm'
local guide   = require 'parser.guide'
local await   = require 'await'
local config  = require 'config'

local function getFields(source, deep, filterKey)
    local unlock = vm.lock('eachField', source)
    if not unlock then
        return {}
    end

    while source.type == 'paren' do
        source = source.exp
        if not source then
            return {}
        end
    end
    deep = config.config.intelliSense.searchDepth + (deep or 0)

    await.delay()
    local results = guide.requestFields(source, vm.interface, deep, filterKey)

    unlock()
    return results
end

local function getDefFields(source, deep, filterKey)
    local unlock = vm.lock('eachDefField', source)
    if not unlock then
        return {}
    end

    while source.type == 'paren' do
        source = source.exp
        if not source then
            return {}
        end
    end
    deep = config.config.intelliSense.searchDepth + (deep or 0)

    await.delay()
    local results = guide.requestDefFields(source, vm.interface, deep, filterKey)

    unlock()
    return results
end

local function getFieldsBySource(source, deep, filterKey)
    deep = deep or -999
    local cache = vm.getCache('eachField')[source]
    if not cache or cache.deep < deep then
        cache = getFields(source, deep, filterKey)
        cache.deep = deep
        if not filterKey then
            vm.getCache('eachField')[source] = cache
        end
    end
    return cache
end

local function getDefFieldsBySource(source, deep, filterKey)
    deep = deep or -999
    local cache = vm.getCache('eachDefField')[source]
    if not cache or cache.deep < deep then
        cache = getDefFields(source, deep, filterKey)
        cache.deep = deep
        if not filterKey then
            vm.getCache('eachDefField')[source] = cache
        end
    end
    return cache
end

function vm.getFields(source, deep)
    if source.special == '_G' then
        return vm.getGlobals '*'
    end
    if guide.isGlobal(source) then
        local name = guide.getKeyName(source)
        if not name then
            return {}
        end
        local cache =  vm.getCache('eachFieldOfGlobal')[name]
                    or getFieldsBySource(source, deep)
        vm.getCache('eachFieldOfGlobal')[name] = cache
        return cache
    else
        return getFieldsBySource(source, deep)
    end
end

function vm.getDefFields(source, deep)
    if source.special == '_G' then
        return vm.getGlobalSets '*'
    end
    if guide.isGlobal(source) then
        local name = guide.getKeyName(source)
        if not name then
            return {}
        end
        local cache =  vm.getCache('eachDefFieldOfGlobal')[name]
                    or getDefFieldsBySource(source, deep)
        vm.getCache('eachDefFieldOfGlobal')[name] = cache
        return cache
    else
        return getDefFieldsBySource(source, deep)
    end
end
