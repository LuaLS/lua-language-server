local vm      = require 'vm.vm'
local library = require 'library'
local guide   = require 'parser.guide'

local interface = {
    global = function (name)
        if name:sub(1, 2) == 's|' then
            return library.global[name:sub(3)]
        end
    end,
}

local function getLibrary(source)
    local results = guide.requestDefinition(source, interface)
    for _, def in ipairs(results) do

    end
end

function vm.getLibrary(source)
    local cache = vm.getCache('getLibrary')[source]
    if cache ~= nil then
        return cache
    end
    local unlock = vm.lock('getLibrary', source)
    if not unlock then
        return
    end
    cache = getLibrary(source) or false
    vm.getCache('getLibrary')[source] = cache
    unlock()
    return cache
end
