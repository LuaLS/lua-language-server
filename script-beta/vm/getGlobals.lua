local guide = require 'parser.guide'
local vm    = require 'vm.vm'

local function getGlobals(root)
    local env  = guide.getENV(root)
    if not env then
        return nil
    end
    local cache = {}
    local fields = guide.requestFields(env)
    for _, src in ipairs(fields) do
        local name = vm.getKeyName(src)
        if not name then
            return
        end
        if not cache[name] then
            cache[name] = {
                key  = name,
            }
        end
        cache[name][#cache[name]+1] = src
        vm.cache.getGlobal[src] = name
    end
    return cache
end

function vm.getGlobals(source)
    source = guide.getRoot(source)
    local cache = vm.cache.getGlobals[source]
    if cache ~= nil then
        return cache
    end
    local unlock = vm.lock('getGlobals', source)
    if not unlock then
        return nil
    end
    cache = getGlobals(source) or false
    vm.cache.getGlobals[source] = cache
    unlock()
    return cache
end
