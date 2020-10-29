local vm      = require 'vm.vm'
local guide   = require 'parser.guide'
local library = require 'library'
local await   = require 'await'

local function eachFieldInLibrary(source, lib, results)
    if not lib or not lib.child then
        return
    end
    for _, value in pairs(lib.child) do
        if value.name:sub(1, 1) ~= '@' then
            results[#results+1] = value
        end
    end
end

local function eachFieldOfLibrary(results)
    for _, lib in pairs(library.global) do
        results[#results+1] = lib
    end
end

local function eachField(source, deep)
    local unlock = vm.lock('eachField', source)
    if not unlock then
        return
    end

    while source.type == 'paren' do
        source = source.exp
        if not source then
            return
        end
    end

    await.delay()
    local results = guide.requestFields(source, vm.interface, deep)
    if source.special == '_G' then
        eachFieldOfLibrary(results)
    end
    if library.object[source.type] then
        eachFieldInLibrary(source, library.object[source.type], results)
    end

    unlock()
    return results
end

function vm.getFields(source, deep)
    if guide.isGlobal(source) then
        local name = guide.getKeyName(source)
        local cache =  vm.getCache('eachFieldOfGlobal')[name]
                    or vm.getCache('eachField')[source]
                    or eachField(source, 'deep')
        vm.getCache('eachFieldOfGlobal')[name] = cache
        vm.getCache('eachField')[source] = cache
        return cache
    else
        local cache =  vm.getCache('eachField')[source]
                    or eachField(source, deep)
        if deep then
            vm.getCache('eachField')[source] = cache
        end
        return cache
    end
end
