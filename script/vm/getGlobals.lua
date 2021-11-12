local collector = require 'core.collector'
local guide     = require 'parser.guide'
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
    if name == '*' then
        for noders in collector.each('def:g:') do
            for id in noder.eachID(noders) do
                if  id:sub(1, 2) == 'g:'
                and not id:find(noder.SPLIT_CHAR) then
                    for source in noder.eachSource(noders, id) do
                        if guide.isSet(source) then
                            results[#results+1] = source
                        end
                    end
                end
            end
        end
    else
        local id
        if type(name) == 'string' then
            id = ('g:%s%s'):format(noder.STRING_CHAR, name)
        else
            id = ('g:%s'):format(noder.STRING_CHAR, name)
        end
        for noders in collector.each('def:' .. id) do
            for source in noder.eachSource(noders, id) do
                if guide.isSet(source) then
                    results[#results+1] = source
                end
            end
        end
    end
    return results
end
