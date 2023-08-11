local files    = require 'files'
local furi     = require 'file-uri'
local core     = require 'core.diagnostics'
local config   = require 'config'
local platform = require 'bee.platform'
local catch    = require 'catch'


config.get(nil, 'Lua.diagnostics.neededFileStatus')['deprecated'] = 'Any'
config.get(nil, 'Lua.diagnostics.neededFileStatus')['type-check'] = 'Any'
config.get(nil, 'Lua.diagnostics.neededFileStatus')['duplicate-set-field'] = 'Any'
config.get(nil, 'Lua.diagnostics.neededFileStatus')['codestyle-check'] = 'None'

rawset(_G, 'TEST', true)

local function founded(targets, results)
    if #targets ~= #results then
        return false
    end
    for _, target in ipairs(targets) do
        for _, result in ipairs(results) do
            if target[1] == result[1]
            and target[2] == result[2]
            and target[3] == result[3]
            then
                goto NEXT
            end
        end
        do return false end
        ::NEXT::
    end
    return true
end

---@diagnostic disable: await-in-sync
function TEST(datas)
    local targetList = {}
    for _, data in ipairs(datas) do
        local uri = furi.encode(data.path)
        local newScript, catched = catch(data.content, '!')
        for _, position in ipairs(catched['!'] or {}) do
            targetList[#targetList+1] = {
                position[1],
                position[2],
                uri,
            }
        end
        data.content = newScript
        files.setText(uri, newScript)
        files.compileState(uri)
    end

    local _ <close> = function ()
        for _, info in ipairs(datas) do
            files.remove(furi.encode(info.path))
        end
    end


    local results = {}
    local origins = {}
    for _, data in ipairs(datas) do
        local uri = furi.encode(data.path)
        core(uri, false, function (result)
            if result.code == datas.code then
                results[#results+1] = {
                    result.start,
                    result.finish,
                    uri,
                }
            end
            origins[#origins+1] = result
        end)
    end
    assert(datas.code, 'Need code')
    assert(founded(targetList, results))
end

TEST {
    code = 'different-requires',
    {
        path = 'f/a.lua',
        content = '',
    },
    {
        path = 'b.lua',
        content = 'require "a"',
    },
    {
        path = 'c.lua',
        content = 'require <!"f.a"!>',
    },
}

TEST {
    code = 'different-requires',
    {
        path = 'f/a.lua',
        content = '',
    },
    {
        path = 'a.lua',
        content = '',
    },
    {
        path = 'b.lua',
        content = 'require "a"',
    },
    {
        path = 'c.lua',
        content = 'require "f.a"',
    },
}

TEST {
    code = 'different-requires',
    {
        path = 'a.lua',
        content = '',
    },
    {
        path = 'f/a.lua',
        content = '',
    },
    {
        path = 'b.lua',
        content = 'require "a"',
    },
    {
        path = 'c.lua',
        content = 'require "f.a"',
    },
}

TEST {
    code = 'different-requires',
    {
        path = 'a/init.lua',
        content = '',
    },
    {
        path = 'f/a.lua',
        content = '',
    },
    {
        path = 'b.lua',
        content = 'require "a"',
    },
    {
        path = 'c.lua',
        content = 'require "f.a"',
    },
}

TEST {
    code = 'invisible',
    { path = 'a.lua', content = [[
        ---@class A
        ---@field package x string

        ---@type A
        local obj

        print(obj.x)
    ]]},
}

TEST {
    code = 'invisible',
    { path = 'a.lua', content = [[
        ---@class A
        ---@field package x string
    ]]},
    { path = 'b.lua', content = [[
        ---@type A
        local obj

        print(obj.<!x!>)
    ]]}
}

TEST {
    code = 'duplicate-doc-field',
    { path = 'a.lua', content = [[
        ---@class A
        ---@field <!x!> number
    ]]},
    { path = 'b.lua', content = [[
        ---@class A
        ---@field <!x!> number
    ]]}
}

TEST {
    code = 'duplicate-set-field',
    { path = 'a.lua', content = [[
        ---@class A
        local mt

        function <!mt:init!>()
        end
    ]]},
    { path = 'b.lua', content = [[
        ---@class A
        local mt

        function <!mt:init!>()
        end
    ]]}
}

TEST {
    code = 'duplicate-set-field',
    { path = 'a.lua', content = [[
        ---@class A
        local mt

        function mt:init()
        end
    ]]},
    { path = 'b.lua', content = [[
        ---@class B: A
        local mt

        function mt:init()
        end
    ]]}
}
