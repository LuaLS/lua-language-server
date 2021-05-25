---@type vm
local vm       = require 'vm.vm'
local searcher = require 'core.searcher'

function vm.getRefs(source, field)
    return searcher.requestReference(source, field)
end
