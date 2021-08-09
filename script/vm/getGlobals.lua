local collector = require 'core.collector'
---@diagnostic disable-next-line
---@class vm
local vm        = require 'vm.vm'
local noder     = require 'core.noder'

function vm.hasGlobalSets(name)
    local id
    if type(name) == 'string' then
        id = ('def:g:%s%s'):format(noder.STRING_CHAR, name)
    else
        id = ('def:g:%s'):format(noder.STRING_CHAR, name)
    end
    return collector.has(id)
end

function vm.getGlobalSets(name)
    local cache = vm.getCache 'getGlobalSets'
    if cache[name] then
        return cache[name]
    end
    local results = {}
    cache[name] = results
    local id
    if name == '*' then
        id = 'def:g:'
    else
        if type(name) == 'string' then
            id = ('def:g:%s%s'):format(noder.STRING_CHAR, name)
        else
            id = ('def:g:%s'):format(noder.STRING_CHAR, name)
        end
    end
    for noders in collector.each(id) do
        for source in noder.eachSource(noders, id) do
            results[#results+1] = source
        end
    end
    return results
end
