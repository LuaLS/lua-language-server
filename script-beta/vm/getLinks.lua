local guide = require 'parser.guide'
local vm    = require 'vm.vm'

local function getLinks(root)
    local cache = {}
    local ok
    guide.eachSpecialOf(root, 'require', function (source)
        local call = source.parent
        if call.type == 'call' then
            local uris = vm.getLinkUris(call)
            if uris then
                ok = true
                for i = 1, #uris do
                    local uri = uris[i]
                    if not cache[uri] then
                        cache[uri] = {}
                    end
                    cache[uri][#cache[uri]+1] = call
                end
            end
        end
    end)
    if not ok then
        return nil
    end
    return cache
end

function vm.getLinks(source)
    source = guide.getRoot(source)
    local cache = vm.cache.getLinks[source]
    if cache ~= nil then
        return cache
    end
    local unlock = vm.lock('getLinks', source)
    if not unlock then
        return nil
    end
    local clock = os.clock()
    cache = getLinks(source) or false
    local passed = os.clock() - clock
    if passed > 0.1 then
        log.warn(('getLinks takes [%.3f] sec!'):format(passed))
    end
    vm.cache.getLinks[source] = cache
    unlock()
    return cache
end
