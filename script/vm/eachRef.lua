---@class vm
local vm       = require 'vm.vm'
local searcher = require 'core.searcher'

function vm.getRefs(source, field)
    return searcher.requestReference(source, field)
end

function vm.getAllRefs(source, field)
    return searcher.requestAllReference(source, field)
end
