---@class vm
local vm       = require 'vm.vm'
local searcher = require 'core.searcher'

function vm.getDefs(source, field)
    return searcher.requestDefinition(source, field)
end

function vm.getAllDefs(source, field)
    return searcher.requestAllDefinition(source, field)
end
