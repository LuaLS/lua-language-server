local files = require 'files'
local lang  = require 'language'
local guide = require 'parser.guide'
local vm    = require 'vm'

return function (uri, callback)
    local state = files.getState(uri)
    if not state then
        return
    end

    guide.eachSourceType(state.ast, 'setlocal', function (source)
        local value = source.value
        if not value then
            return
        end
        local locNode   = vm.compileNode(source)
        local valueNode = vm.compileNode(value)
    end)
end
