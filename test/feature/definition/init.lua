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

---@param script string
function TEST(script)
    local newScript, catched = test.catch(script, '!?')

    local file <close> = ls.file.setText(test.fileUri, newScript)

    local results = ls.core.definition(test.fileUri, catched['?'][1][1])
    assert(founded(catched['!'], results))
end

require 'test.feature.definition.local'
require 'test.feature.definition.set'
require 'test.feature.definition.field'
require 'test.feature.definition.arg'
require 'test.feature.definition.function'
require 'test.feature.definition.table'
require 'test.feature.definition.method'
require 'test.feature.definition.label'
require 'test.feature.definition.special'
require 'test.feature.definition.bug'
require 'test.feature.definition.luadoc'
