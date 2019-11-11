local guide = require 'parser.guide'
local searcher = require 'searcher.searcher'

local function getLinks(root)
    local cache = {}
    guide.eachSourceType(root, 'call', function (info)
        local uris = searcher.getLinkUris(info.source)
        if uris then
            for i = 1, #uris do
                local uri = uris[i]
                cache[uri] = true
            end
        end
    end)
    return cache
end

function searcher.getLinks(source)
    source = guide.getRoot(source)
    local cache = searcher.cache.getLinks[source]
    if cache ~= nil then
        return cache
    end
    local unlock = searcher.lock('getLinks', source)
    if not unlock then
        return nil
    end
    cache = getLinks(source)
    searcher.cache.getLinks[source] = cache or false
    unlock()
    return cache
end
