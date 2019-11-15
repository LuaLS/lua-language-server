local searcher = require 'searcher.searcher'
local guide    = require 'parser.guide'
local library  = require 'library'

local function getLibrary(source)
    local globalName = searcher.getGlobal(source)
    if not globalName then
        return nil
    end
    local name = globalName:match '^s|(.+)$'
    if library.global[name] then
        return library.global[name]
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
