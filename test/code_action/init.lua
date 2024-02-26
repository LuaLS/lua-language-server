local core  = require 'core.code-action'
local files = require 'files'
local lang  = require 'language'
local catch = require 'catch'
local furi  = require 'file-uri'

rawset(_G, 'TEST', true)

local EXISTS = {}

local function eq(expected, result)
    if expected == EXISTS and result ~= nil then
        return true
    end
    if result == EXISTS and expected ~= nil then
        return true
    end
    local tp1, tp2 = type(expected), type(result)
    if tp1 ~= tp2 then
        return false, string.format(": expected type %s, got %s", tp1, tp2)
    end
    if tp1 == 'table' then
        local mark = {}
        for k in pairs(expected) do
            local ok, err = eq(expected[k], result[k])
            if not ok then
                return false, string.format(".%s%s", k, err)
            end
            mark[k] = true
        end
        for k in pairs(result) do
            if not mark[k] then
                return false, string.format(".%s: missing key in result", k)
            end
        end
        return true
    end
    return expected == result, string.format(": expected %s, got %s", expected, result)
end

function TEST(script)
    return function (expect)
        local newScript, catched = catch(script, '?')
        files.setText(TESTURI, newScript)
        local results = core(TESTURI, catched['?'][1][1], catched['?'][1][2])
        assert(results)
        assert(eq(expect, results))
        files.remove(TESTURI)
    end
end

---@param testfiles [string, {path:string, content:string}]
local function TEST_CROSSFILE(testfiles)
    local mainscript = table.remove(testfiles, 1)
    return function(expected)
        for _, data in ipairs(testfiles) do
            local uri = furi.encode(TESTROOT .. data.path)
            files.setText(uri, data.content)
            files.compileState(uri)
        end

        local newScript, catched = catch(mainscript, '?')
        files.setText(TESTURI, newScript)
        files.compileState(TESTURI)

        local _ <close> = function ()
            for _, info in ipairs(testfiles) do
                files.remove(furi.encode(TESTROOT .. info.path))
            end
            files.remove(TESTURI)
        end

        local results = core(TESTURI, catched['?'][1][1], catched['?'][1][2])
        assert(results)
        assert(eq(expected, results))
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

TEST [[
f = function (<?a?>, b) end
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
}

TEST [[
local t = {
    f = function (<?a?>, b) end
}
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

TEST_CROSSFILE {
[[
    <?unrequiredModule?>.myFunction()
]],
    {
        path = 'unrequiredModule.lua',
        content = [[
            local m = {}
            m.myFunction = print
            return m
        ]]
    }
} {
    {
        title = lang.script('ACTION_AUTOREQUIRE', 'unrequiredModule', 'unrequiredModule'),
        kind = 'refactor.rewrite',
        command = {
            title     = 'autoRequire',
            command   = 'lua.autoRequire',
            arguments = {
                {
                    uri         = TESTURI,
                    target      = furi.encode(TESTROOT .. 'unrequiredModule.lua'),
                    name        = 'unrequiredModule',
                    requireName = 'unrequiredModule'
                },
            },
        }
    }
}

TEST_CROSSFILE {
[[
    <?myModule?>.myFunction()
]],
    {
        path = 'myModule/init.lua',
        content = [[
            local m = {}
            m.myFunction = print
            return m
        ]]
    }
} {
    {
        title = lang.script('ACTION_AUTOREQUIRE', 'myModule.init', 'myModule'),
        kind = 'refactor.rewrite',
        command = {
            title     = 'autoRequire',
            command   = 'lua.autoRequire',
            arguments = {
                {
                    uri         = TESTURI,
                    target      = furi.encode(TESTROOT .. 'myModule/init.lua'),
                    name        = 'myModule',
                    requireName = 'myModule.init'
                },
            },
        }
    },
    {
        title = lang.script('ACTION_AUTOREQUIRE', 'init', 'myModule'),
        kind = 'refactor.rewrite',
        command = {
            title     = 'autoRequire',
            command   = 'lua.autoRequire',
            arguments = {
                {
                    uri         = TESTURI,
                    target      = furi.encode(TESTROOT .. 'myModule/init.lua'),
                    name        = 'myModule',
                    requireName = 'init'
                },
            },
        }
    },
    {
        title = lang.script('ACTION_AUTOREQUIRE', 'myModule', 'myModule'),
        kind = 'refactor.rewrite',
        command = {
            title     = 'autoRequire',
            command   = 'lua.autoRequire',
            arguments = {
                {
                    uri         = TESTURI,
                    target      = furi.encode(TESTROOT .. 'myModule/init.lua'),
                    name        = 'myModule',
                    requireName = 'myModule'
                },
            },
        }
    },
}
