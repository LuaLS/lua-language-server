local searcher = require 'searcher.searcher'
local guide    = require 'parser.guide'
local library  = require 'library'

local function getLibrary(source)
    local name = guide.getKeyName(source)
    if not name then
        return nil
    end
    local sname = name:match '^s|(.+)$'
    if not sname then
        return nil
    end
    if searcher.isGlobal(source) then
        return library.global[sname]
    end
    return nil
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
