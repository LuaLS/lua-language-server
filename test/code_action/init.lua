local core  = require 'core.code-action'
local files = require 'files'
local lang  = require 'language'
local catch = require 'catch'

rawset(_G, 'TEST', true)

local EXISTS = {}

local function eq(a, b)
    if a == EXISTS and b ~= nil then
        return true
    end
    if b == EXISTS and a ~= nil then
        return true
    end
    local tp1, tp2 = type(a), type(b)
    if tp1 ~= tp2 then
        return false
    end
    if tp1 == 'table' then
        local mark = {}
        for k in pairs(a) do
            if not eq(a[k], b[k]) then
                return false
            end
            mark[k] = true
        end
        for k in pairs(b) do
            if not mark[k] then
                return false
            end
        end
        return true
    end
    return a == b
end

function TEST(script)
    return function (expect)
        files.removeAll()

        local newScript, catched = catch(script, '?')
        files.setText('', newScript)
        local results = core('', catched['?'][1][1], catched['?'][1][2])
        assert(results)
        assert(eq(expect, results))
    end
end

TEST [[
print(<?a?>, b, c)
]]
{
    {
        title = lang.script('ACTION_SWAP_PARAMS', {
            node  = 'print',
            index = 2,
        }),
        kind  = 'refactor.rewrite',
        edit  = EXISTS,
    },
    {
        title = lang.script('ACTION_SWAP_PARAMS', {
            node  = 'print',
            index = 3,
        }),
        kind  = 'refactor.rewrite',
        edit  = EXISTS,
    },
}

TEST [[
local function f(<?a?>, b, c) end
]]
{
    {
        title = lang.script('ACTION_SWAP_PARAMS', {
            node  = 'f',
            index = 2,
        }),
        kind  = 'refactor.rewrite',
        edit  = EXISTS,
    },
    {
        title = lang.script('ACTION_SWAP_PARAMS', {
            node  = 'f',
            index = 3,
        }),
        kind  = 'refactor.rewrite',
        edit  = EXISTS,
    },
}

TEST [[
return function(<?a?>, b, c) end
]]
{
    {
        title = lang.script('ACTION_SWAP_PARAMS', {
            node  = lang.script.SYMBOL_ANONYMOUS,
            index = 2,
        }),
        kind  = 'refactor.rewrite',
        edit  = EXISTS,
    },
    {
        title = lang.script('ACTION_SWAP_PARAMS', {
            node  = lang.script.SYMBOL_ANONYMOUS,
            index = 3,
        }),
        kind  = 'refactor.rewrite',
        edit  = EXISTS,
    },
}

--TEST [[
--<?print(1)
--print(2)?>
--]]
--{
--    {
--        title = lang.script.ACTION_EXTRACT,
--        kind  = 'refactor.extract',
--        edit  = EXISTS,
--    },
--}
