local guide = require 'parser.guide'
local searcher = require 'searcher.searcher'

local function eachGlobal(source, callback)
    local root = guide.getRoot(source)
    local env  = root.locals[1]
    searcher.eachField(env, callback)
end

function searcher.eachGlobal(source, callback)
    local cache = searcher.cache.eachGlobal[source]
    if cache then
        for i = 1, #cache do
            callback(cache[i])
        end
        return
    end
    local unlock = searcher.lock('eachGlobal', source)
    if not unlock then
        return
    end
    cache = {}
    searcher.cache.eachGlobal[source] = cache
    local mark = {}
    eachGlobal(source, function (info)
        local src = info.source
        if mark[src] then
            return
        end
        mark[src] = true
        cache[#cache+1] = info
    end)
    unlock()
    for i = 1, #cache do
        callback(cache[i])
    end
end
