local guide = require 'parser.guide'
local vm    = require 'vm.vm'
local files = require 'files'

local function getFileLinks(uri)
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
    end)
    return links
end

local function getLinksTo(uri)
    local links = {}
    local mark = {}
    for u in files.eachFile() do
        local l = vm.getFileLinks(u)
        for _, lu in ipairs(l) do
            if files.eq(uri, lu) then
                local ku = files.asKey(u)
                if not mark[ku] then
                    mark[ku] = true
                    links[#links+1] = u
                end
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
