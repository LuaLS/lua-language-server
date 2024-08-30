local files  = require 'files'
local guide  = require 'parser.guide'
local config = require 'config'
local catch  = require 'catch'
local vm     = require 'vm'

rawset(_G, 'TEST', true)

local function getSource(pos)
    local state = files.getState(TESTURI)
    if not state then
        return
    end
    local result
    guide.eachSourceContain(state.ast, pos, function (source)
        if source.type == 'local'
        or source.type == 'getlocal'
        or source.type == 'setlocal'
        or source.type == 'setglobal'
        or source.type == 'getglobal'
        or source.type == 'field'
        or source.type == 'method'
        or source.type == 'function'
        or source.type == 'table'
        or source.type == 'doc.type.name' then
            result = source
        end
    end)
    return result
end

function TEST(wanted)
    return function (script)
        local newScript, catched = catch(script, '?')
        files.setText(TESTURI, newScript)
        local source = getSource(catched['?'][1][1])
        assert(source)
        local result = vm.getInfer(source):view(TESTURI)
        if wanted ~= result then
            vm.getInfer(source):view(TESTURI)
        end
        assert(wanted == result, "Assertion failed! Wanted: " .. tostring(wanted) .. " Got: " .. tostring(result))
        files.remove(TESTURI)
    end
end

require 'type_inference.common'
require 'type_inference.param_match'
