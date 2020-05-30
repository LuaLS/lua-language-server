local vm    = require 'vm.vm'
local guide = require 'parser.guide'

local function eachFieldOfLibrary(source, lib, callback)
    if not lib or lib.type ~= 'table' or not lib.child then
        return
    end
    for _, value in pairs(lib.child) do
        callback(value)
    end
end

function vm.eachField(source, callback)
    local lib = vm.getLibrary(source)
    eachFieldOfLibrary(source, lib, callback)
    local results = guide.requestFields(source)
    for i = 1, #results do
        callback(results[i])
    end
end
