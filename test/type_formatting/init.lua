local core  = require 'core.type-formatting'
local files = require 'files'
local util  = require 'utility'

rawset(_G, 'TEST', true)

function TEST(script)
    return function (expect)
        local pos = script:find('$', 1, true) - 1
        local new_script = script:gsub('%$', '')
        files.removeAll()
        files.setText('', new_script)
        local edits = core('', pos, expect.ch)
        if edits then
            assert(expect.edits)
            assert(util.equal(edits, expect.edits))
        else
            assert(expect.edits == nil)
        end
    end
end
do return end
TEST [[
if true then$
]]
{
    ch = '\n',
    {
    }
}
