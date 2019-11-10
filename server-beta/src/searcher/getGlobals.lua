local guide = require 'parser.guide'
local searcher = require 'searcher.searcher'

local function getGlobals(source)
    local root = guide.getRoot(source)
    local env  = guide.getENV(root)
    local cache = {}
    local mark = {}
    searcher.eachField(env, function (info)
        local src = info.source
        if mark[src] then
            return
        end
        mark[src] = true
        local name = info.key
        if not name then
            return
        end
        if not cache[name] then
            cache[name] = {
                key  = name,
                mode = {},
            }
        end
        cache[name][#cache[name]+1] = info
        cache[name].mode[info.mode] = true
        searcher.cache.isGlobal[src] = true
    end)
    return cache
end

function searcher.getGlobals(source)
    source = guide.getRoot(source)
    local cache = searcher.cache.getGlobals[source]
    if cache then
        return cache
    end
    local unlock = searcher.lock('getGlobals', source)
    if not unlock then
        return nil
    end
    cache = getGlobals(source)
    searcher.cache.getGlobals[source] = cache
    unlock()
    return cache
end
