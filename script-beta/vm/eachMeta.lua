local vm = require 'vm.vm'

function vm.setMeta(source, meta)
    if not source or not meta then
        return
    end
    vm.cache.getMeta[source] = meta
end

--- 获取所有的引用
function vm.eachMeta(source, callback)
    local cache = vm.cache.eachMeta[source]
    if cache then
        for i = 1, #cache do
            local res = callback(cache[i])
            if res ~= nil then
                return res
            end
        end
        return
    end
    local unlock = vm.lock('eachMeta', source)
    if not unlock then
        return
    end
    cache = {}
    vm.eachRef(source, function (info)
        local src = info.source
        vm.cache.eachMeta[src] = cache
    end)
    unlock()
    vm.eachRef(source, function (info)
        local src = info.source
        cache[#cache+1] = vm.cache.getMeta[src]
    end)
    for i = 1, #cache do
        local res = callback(cache[i])
        if res ~= nil then
            return res
        end
    end
end
