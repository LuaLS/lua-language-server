local guide   = require 'parser.guide'
local files   = require 'files'
local vm      = require 'vm.vm'
local library = require 'library'
local await   = require 'await'

local function ofLocal(declare, source, callback)
    
end

local function eachDef(source, callback)
    local stype = source.type
    if     stype == 'local' then
        ofLocal(source, source, callback)
    elseif stype == 'getlocal'
    or     stype == 'setlocal' then
        ofLocal(source.node, source, callback)
    end
end

--- 获取所有的引用
function vm.eachDef(source, callback, max)
    local cache = vm.cache.eachDef[source]
    if cache then
        await.delay(function ()
            return files.globalVersion
        end)
        if max then
            if max > #cache then
                max = #cache
            end
        else
            max = #cache
        end
        for i = 1, max do
            local res = callback(cache[i])
            if res ~= nil then
                return res
            end
        end
        return
    end
    local unlock = vm.lock('eachDef', source)
    if not unlock then
        return
    end
    cache = {}
    vm.cache.eachDef[source] = cache
    local mark = {}
    eachDef(source, function (info)
        local src = info.source
        if mark[src] then
            return
        end
        mark[src] = true
        cache[#cache+1] = info
    end)
    unlock()
    await.delay(function ()
        return files.globalVersion
    end)
    if max then
        if max > #cache then
            max = #cache
        end
    else
        max = #cache
    end
    for i = 1, max do
        local res = callback(cache[i])
        if res ~= nil then
            return res
        end
    end
end
