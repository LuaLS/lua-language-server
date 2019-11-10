local searcher = require 'searcher.searcher'

local function isGlobal(source)
    local node = source.node
    if not node then
        return false
    end
    local global = searcher.eachRef(node, function (info)
        if info.source.tag == '_ENV' then
            return true
        end
    end)
    return global or false
end

function searcher.isGlobal(source)
    local cache = searcher.cache.isGlobal[source]
    if cache ~= nil then
        return cache
    end
    cache = isGlobal(source)
    searcher.cache.isGlobal[source] = cache
    searcher.eachRef(source, function (info)
        local src = info.source
        searcher.cache.isGlobal[src] = cache
    end)
    return cache
end
