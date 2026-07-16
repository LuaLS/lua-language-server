local core   = require 'core.hint'
local files  = require 'files'
local catch  = require 'catch'
local config = require 'config'
local define = require 'proto.define'

rawset(_G, 'TEST', true)

---@diagnostic disable: await-in-sync
local function TEST(script, expect, opts)
    opts = opts or {}
    local newScript, catched = catch(script, '!')

    files.setText(TESTURI, newScript)
    files.compileState(TESTURI)

    local results = core(TESTURI, 0, math.huge)
    table.sort(results, function (a, b)
        if a.offset ~= b.offset then
            return a.offset < b.offset
        end
        return a.text < b.text
    end)

    if #expect ~= #results then
        print('Expect count:', #expect, 'Result count:', #results)
        for i, res in ipairs(results) do
            print(('  %d: text=%s kind=%s where=%s offset=%s'):format(
                i,
                tostring(res.text),
                tostring(res.kind),
                tostring(res.where),
                tostring(res.offset)
            ))
        end
    end

    assert(#expect == #results)
    for i, res in ipairs(results) do
        local info = expect[i]
        local pos = catched['!'][info.pos]
        assert(pos)
        local offset = info.useFinish and pos[2] or pos[1]
        assert(res.text == info.text)
        assert(res.kind == info.kind)
        assert(res.where == info.where)
        assert(res.offset == offset)
    end

    files.remove(TESTURI)
end

config.set(nil, 'Lua.hint.enable', true)

config.set(nil, 'Lua.hint.setType', true)

TEST([[
---@return integer
local function returnsInt()
    return 1
end

local <!val!> = returnsInt()
]], {
    {
        pos   = 1,
        text  = ': integer',
        kind  = define.InlayHintKind.Type,
        where = 'right',
        useFinish = true,
    },
})

config.set(nil, 'Lua.hint.paramName', 'Literal')

TEST([[
local function foo(first, second)
end

foo(<!1!>, x)
foo(<!1!>, <!2!>)
]], {
    {
        pos   = 1,
        text  = 'first:',
        kind  = define.InlayHintKind.Parameter,
        where = 'left',
    },
    {
        pos   = 2,
        text  = 'first:',
        kind  = define.InlayHintKind.Parameter,
        where = 'left',
    },
    {
        pos   = 3,
        text  = 'second:',
        kind  = define.InlayHintKind.Parameter,
        where = 'left',
    },
})

config.set(nil, 'Lua.hint.paramName', 'All')

TEST([[
local function foo(first, second)
end

local first, second
foo(<!first!>, <!second!>)
]], {})


config.set(nil, 'Lua.hint.arrayIndex', 'Enable')

TEST([[
local t = {
    <!'first'!>,
    <!'second'!>,
    <!'third'!>,
    <!'fourth'!>,
}
]], {
    {
        pos   = 1,
        text  = '[1]',
        kind  = define.InlayHintKind.Other,
        where = 'left',
    },
    {
        pos   = 2,
        text  = '[2]',
        kind  = define.InlayHintKind.Other,
        where = 'left',
    },
    {
        pos   = 3,
        text  = '[3]',
        kind  = define.InlayHintKind.Other,
        where = 'left',
    },
    {
        pos   = 4,
        text  = '[4]',
        kind  = define.InlayHintKind.Other,
        where = 'left',
    },
})

config.set(nil, 'Lua.hint.enable', false)
