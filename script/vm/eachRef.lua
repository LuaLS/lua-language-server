---@class vm
local vm       = require 'vm.vm'

function vm.getRefs(source, field)
    return searcher.requestReference(source, field)
end

function vm.getAllRefs(source, field)
    return searcher.requestAllReference(source, field)
end
