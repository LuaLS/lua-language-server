local guide = require 'parser.guide'
local vm    = require 'vm.vm'
local files = require 'files'

local function getFileLinks(uri)
    
end

local function getLinksTo(uri)

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
