local core  = require 'core.reference'
local files = require 'files'
local catch = require 'catch'

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

function TEST(script)
    files.removeAll()
    local newScript, catched = catch(script, '!?~')
    files.setText('', newScript)

    local input  = catched['?'] + catched['~']
    local expect = catched['!'] + catched['?']
    local results = core('', input[1][1])
    if results then
        local positions = {}
        for i, result in ipairs(results) do
            positions[i] = { result.target.start, result.target.finish }
        end
        assert(founded(expect, positions))
    else
        assert(#expect == 0)
    end
end

require 'references.common'
require 'references.all'
