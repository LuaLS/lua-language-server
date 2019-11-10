local guide = require 'parser.guide'
local searcher = require 'searcher.searcher'

local function eachGlobal(source, callback)
    local root = guide.getRoot(source)
    local env  = root.locals[1]
    local result = {}
    local mark = {}
    searcher.eachField(env, function (info)
        local src = info.source
        if mark[src] then
            return
        end
        mark[src] = true
        local name = info.key
        if not result[name] then
            result[name] = {
                key  = name,
                mode = {},
            }
        end
        result[name][#result[name]+1] = info
        result[name].mode[info.mode] = true
    end)
    for _, info in pairs(result) do
        callback(info)
    end
end

function searcher.eachGlobal(source, callback)
    source = guide.getRoot(source)
    local cache = searcher.cache.eachGlobal[source]
    if cache then
        for i = 1, #cache do
            local res = callback(cache[i])
            if res ~= nil then
                return res
            end
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
        cache[#cache+1] = info
    end)
    unlock()
    for i = 1, #cache do
        local res = callback(cache[i])
        if res ~= nil then
            return res
        end
    end
end
