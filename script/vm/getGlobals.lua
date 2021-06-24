local collector = require 'core.collector'
---@type vm
local vm        = require 'vm.vm'
local noder     = require 'core.noder'

function vm.hasGlobalSets(name)
    local id = ('def:g:%q'):format(name)
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
        id = ('def:g:%q'):format(name)
    end
    for node in collector.each(id) do
        for source in noder.eachSource(node) do
            results[#results+1] = source
        end
    end
    return results
end
