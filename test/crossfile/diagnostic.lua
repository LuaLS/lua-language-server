local files    = require 'files'
local furi     = require 'file-uri'
local core     = require 'core.diagnostics'
local config   = require 'config'
local platform = require 'bee.platform'

config.get 'Lua.diagnostics.neededFileStatus'['deprecated'] = 'Any'

rawset(_G, 'TEST', true)

local function catch_target(script, sep)
    local list = {}
    local cur = 1
    local cut = 0
    while true do
        local start, finish  = script:find(('<%%%s.-%%%s>'):format(sep, sep), cur)
        if not start then
            break
        end
        list[#list+1] = { start - cut, finish - 4 - cut }
        cur = finish + 1
        cut = cut + 4
    end
    local new_script = script:gsub(('<%%%s(.-)%%%s>'):format(sep, sep), '%1')
    return new_script, list
end

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

function TEST(datas)
    files.removeAll()

    local targetList = {}
    local sourceUri
    for _, data in ipairs(datas) do
        local uri = furi.encode(data.path)
        local new, list = catch_target(data.content, '!')
        for _, position in ipairs(list) do
            targetList[#targetList+1] = {
                position[1],
                position[2],
                uri,
            }
        end
        data.content = new
        files.setText(uri, new)
    end

    local result = {}
    for _, data in ipairs(datas) do
        local uri = furi.encode(data.path)
        local results = {}
        core(uri, function (result)
            for _, res in ipairs(result) do
                results[#results+1] = res
            end
        end)
        for i, position in ipairs(results) do
            result[i] = {
                position.start,
                position.finish,
                uri,
            }
        end
    end
    assert(founded(targetList, result))
end

TEST {
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
