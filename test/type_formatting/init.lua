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

TEST [[
if true then $ end
]]
{
    ch = '\n',
    edits = {
        {
            start  = 13,
            finish = 13,
            text   = '\n\t',
        },
        {
            start  = 14,
            finish = 17,
            text   = '',
        },
        {
            start  = 18,
            finish = 17,
            text   = '\nend',
        },
    }
}

TEST [[
if true then $end
]]
{
    ch = '\n',
    edits = {
        {
            start  = 13,
            finish = 13,
            text   = '\n\t',
        },
        {
            start  = 14,
            finish = 16,
            text   = '',
        },
        {
            start  = 17,
            finish = 16,
            text   = '\nend',
        },
    }
}

TEST [[
if true then$end
]]
{
    ch = '\n',
    edits = {
        {
            start  = 13,
            finish = 12,
            text   = '\n\t',
        },
        {
            start  = 13,
            finish = 15,
            text   = '',
        },
        {
            start  = 16,
            finish = 15,
            text   = '\nend',
        },
    }
}

TEST [[
if true then
    $
end
]]
{
    ch = '\n',
    edits = {}
}
