local core  = require 'core.type-formatting'
local files = require 'files'
local util  = require 'utility'
local catch = require 'catch'

rawset(_G, 'TEST', true)

function TEST(script)
    return function (expect)
        files.removeAll()
        local newScript, catched = catch(script, '?')
        files.setText('', newScript)
        local edits = core('', catched['?'][1][1], expect.ch)
        if edits then
            assert(expect.edits)
            assert(util.equal(edits, expect.edits))
        else
            assert(expect.edits == nil)
        end
    end
end

TEST [[
if true then <??> end
]]
{
    ch = '\n',
    edits = {
        {
            start  = 12,
            finish = 13,
            text   = '\n\t',
        },
        {
            start  = 13,
            finish = 15,
            text   = '',
        },
        {
            start  = 15,
            finish = 15,
            text   = '\ne',
        },
    }
}

TEST [[
if true then <??>end
]]
{
    ch = '\n',
    edits = {
        {
            start  = 12,
            finish = 13,
            text   = '\n\t',
        },
        {
            start  = 13,
            finish = 14,
            text   = '',
        },
        {
            start  = 14,
            finish = 14,
            text   = '\ne',
        },
    }
}

TEST [[
if true then<??>end
]]
{
    ch = '\n',
    edits = {
        {
            start  = 12,
            finish = 12,
            text   = '\n\t',
        },
        {
            start  = 12,
            finish = 13,
            text   = '',
        },
        {
            start  = 13,
            finish = 13,
            text   = '\ne',
        },
    }
}

TEST [[
    if true then<??>end
]]
{
    ch = '\n',
    edits = {
        {
            start  = 16,
            finish = 16,
            text   = '\n    \t',
        },
        {
            start  = 16,
            finish = 17,
            text   = '',
        },
        {
            start  = 17,
            finish = 17,
            text   = '\n    e',
        },
    }
}

TEST [[
if true then
    <??>
end
]]
{
    ch = '\n',
    edits = {}
}
