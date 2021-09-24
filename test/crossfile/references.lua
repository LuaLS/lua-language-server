local files = require 'files'
local furi  = require 'file-uri'
local core  = require 'core.reference'
local catch = require 'catch'

rawset(_G, 'TEST', true)

local EXISTS = {}

local function eq(a, b)
    if a == EXISTS and b ~= nil then
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
    local sourceList
    local sourceUri
    for i, data in ipairs(datas) do
        local uri = furi.encode(data.path)
        local newScript, catched = catch(data.content, '!?~')
        if catched['!'] or catched['~'] then
            for _, position in ipairs(catched['!'] + catched['~']) do
                targetList[#targetList+1] = {
                    position[1],
                    position[2],
                    uri,
                }
            end
        end
        if catched['?'] or catched['~'] then
            sourceList = catched['?'] + catched['~']
            sourceUri = uri
        end
        files.setText(uri, newScript)
    end

    local sourcePos = (sourceList[1][1] + sourceList[1][2]) // 2
    local positions = core(sourceUri, sourcePos)
    if positions then
        local result = {}
        for i, position in ipairs(positions) do
            result[i] = {
                position.target.start,
                position.target.finish,
                position.uri,
            }
        end
        assert(founded(targetList, result))
    else
        assert(#targetList == 0)
    end
end

TEST {
    {
        path = 'lib.lua',
        content = [[
            return <!function ()
            end!>
        ]],
    },
    {
        path = 'a.lua',
        content = [[
            local <~f~> = require 'lib'
        ]],
    },
}

TEST {
    {
        path = 'a.lua',
        content = [[
            <!ROOT!> = 1
        ]],
    },
    {
        path = 'b.lua',
        content = [[
            print(<~ROOT~>)
        ]],
    },
}

TEST {
    {
        path = 'a.lua',
        content = [[
            <~ROOT~> = 1
        ]],
    },
    {
        path = 'b.lua',
        content = [[
            print(<!ROOT!>)
        ]],
    },
}

TEST {
    {
        path = 'a.lua',
        content = [[
            local f = require 'lib'
            local <~o~> = f()
        ]],
    },
    {
        path = 'lib.lua',
        content = [[
            return function ()
                return <!{}!>
            end
        ]],
    },
}

TEST {
    {
        path = 'a.lua',
        content = [[
            ---@type A
            local t

            t.<!f!>()
        ]]
    },
    {
        path = 'b.lua',
        content = [[
            ---@class A
            local mt

            function mt.<~f~>()
            end
        ]]
    }
}
