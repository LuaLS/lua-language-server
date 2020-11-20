local vm      = require 'vm.vm'
local guide   = require 'parser.guide'
local await   = require 'await'

local function eachField(source, deep)
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

    await.delay()
    local results = guide.requestFields(source, vm.interface, deep)

    unlock()
    return results
end

function vm.getFields(source, deep)
    if source.special == '_G' then
        return vm.getGlobals '*'
    end
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
