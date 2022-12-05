local core  = require 'core.definition'
local files = require 'files'
local vm    = require 'vm'
local catch = require 'catch'

rawset(_G, 'TEST', true)

local function founded(targets, results)
    if #targets ~= #results then
        return false
    end
    for _, target in ipairs(targets) do
        for _, result in ipairs(results) do
            if target[1] == result[1] and target[2] == result[2] then
                goto NEXT
            end
        end
        do return false end
        ::NEXT::
    end
    return true
end

---@async
function TEST(script)
    local newScript, catched = catch(script, '!?')

    files.setText(TESTURI, newScript)

    local results = core(TESTURI, catched['?'][1][1])
    if results then
        local positions = {}
        for i, result in ipairs(results) do
            if not vm.isMetaFile(result.uri) then
                positions[#positions+1] = { result.target.start, result.target.finish }
            end
        end
        assert(founded(catched['!'], positions))
    else
        assert(#catched['!'] == 0)
    end

    files.remove(TESTURI)
end

require 'definition.local'
require 'definition.set'
require 'definition.field'
require 'definition.arg'
require 'definition.function'
require 'definition.table'
require 'definition.method'
require 'definition.label'
require 'definition.special'
require 'definition.bug'
require 'definition.luadoc'
