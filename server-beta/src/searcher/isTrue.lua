local searcher = require 'searcher.searcher'

local function checkLiteral(source)
    if source.type == 'boolean' then
        if source[1] == true then
            return 'true'
        else
            return 'false'
        end
    end
    if source.type == 'string' then
        return 'true'
    end
    if source.type == 'number' then
        return 'true'
    end
    if source.type == 'table' then
        return 'true'
    end
    if source.type == 'function' then
        return 'true'
    end
    if source.type == 'nil' then
        return 'false'
    end
end

local function isTrue(source)
    local res = checkLiteral(source)
    if res then
        return res
    end
    return 'unknown'
end

function searcher.isTrue(source)
    if not source then
        return
    end
    local cache = searcher.cache.isTrue[source]
    if cache ~= nil then
        return cache
    end
    local unlock = searcher.lock('isTrue', source)
    if not unlock then
        return
    end
    cache = isTrue(source) or false
    searcher.cache.isTrue[source] = cache
    unlock()
    return cache
end
