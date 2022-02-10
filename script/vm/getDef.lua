local util = require 'utility'

---@class vm
local vm = require 'vm.vm'

local simpleMap = util.switch()
    : case 'local'
    : call(function (source, results)
        results[#results+1] = source
    end)
    : case 'getlocal'
    : case 'setlocal'
    : call(function (source, results)
        results[#results+1] = source.node
    end)
    : getMap()

function vm.getDefs(source, field)
    local results = {}
    local simple  = simpleMap[source.type]
    if simple then
        simple(source, results)
    end
    return results
end

function vm.getAllDefs(source, field)
    return vm.getDefs(source, field)
end
