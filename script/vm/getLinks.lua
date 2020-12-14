local guide = require 'parser.guide'
---@type vm
local vm    = require 'vm.vm'
local files = require 'files'

local function getFileLinks(uri)
    local ws    = require 'workspace'
    local links = {}
    local ast = files.getAst(uri)
    if not ast then
        return links
    end
    guide.eachSpecialOf(ast.ast, 'require', function (source)
        local call = source.parent
        if not call or call.type ~= 'call' then
            return
        end
        local args = call.args
        if not args[1] or args[1].type ~= 'string' then
            return
        end
        local uris = ws.findUrisByRequirePath(args[1][1])
        for _, u in ipairs(uris) do
            u = files.asKey(u)
            if not links[u] then
                links[u] = {}
            end
            links[u][#links[u]+1] = call
        end
    end)
    return links
end

local function getLinksTo(uri)
    uri = files.asKey(uri)
    local links = {}
    for u in files.eachFile() do
        local ls = vm.getFileLinks(u)
        if ls[uri] then
            for _, l in ipairs(ls[uri]) do
                links[#links+1] = l
            end
        end
    end
    return links
end

function vm.getLinksTo(uri)
    local cache = vm.getCache('getLinksTo')[uri]
    if cache ~= nil then
        return cache
    end
    cache = getLinksTo(uri)
    vm.getCache('getLinksTo')[uri] = cache
    return cache
end

function vm.getFileLinks(uri)
    local cache = files.getCache(uri)
    cache.links = cache.links or getFileLinks(uri)
    return cache.links
end
