---@async
---@param script string
function TEST(script)
    local newScript, catched = test.catch(script, '!?')
    test.singleFile(newScript)

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

require 'test.definition.local'
require 'test.definition.set'
require 'test.definition.field'
require 'test.definition.arg'
require 'test.definition.function'
require 'test.definition.table'
require 'test.definition.method'
require 'test.definition.label'
require 'test.definition.special'
require 'test.definition.bug'
require 'test.definition.luadoc'
