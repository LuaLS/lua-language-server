local searcher = require 'searcher.searcher'
local guide    = require 'parser.guide'
local library  = require 'library'

local function getLibrary(source)
    local name = guide.getKeyName(source)
    if not name then
        return
    end
    local sname = name:match '^s|(.+)$'
    if not sname then
        return
    end
    if searcher.isGlobal(source) then
        return library.global[sname]
    end
    local node = source.node
    if not node then
        return
    end

    local lib
    searcher.eachRef(node, function (info)
        local src = info.source
        if info.mode == 'get' and searcher.isGlobal(node) then
            local nodeName = guide.getKeyName(src)
            if not nodeName then
                return
            end
            local sNodeName = nodeName:match '^s|(.+)$'
            if not sNodeName then
                return
            end
            local tbl = library.global[sNodeName]
            if tbl then
                lib = lib or tbl[sname]
            end
        end
    end)
    return lib
end

function searcher.getLibrary(source)
    local cache = searcher.cache.getLibrary[source]
    if cache ~= nil then
        return cache
    end
    local unlock = searcher.lock('getLibrary', source)
    if not unlock then
        return
    end
    cache = getLibrary(source) or false
    searcher.cache.getLibrary[source] = cache
    unlock()
    return cache
end
