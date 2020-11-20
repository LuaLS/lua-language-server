local files = require 'files'
local furi  = require 'file-uri'
local core  = require 'core.reference'

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

local function catch_target(script, sep)
    local list = {}
    local cur = 1
    while true do
        local start, finish  = script:find(('<%%%s.-%%%s>'):format(sep, sep), cur)
        if not start then
            break
        end
        list[#list+1] = { start + 2, finish - 2 }
        cur = finish + 1
    end
    local new_script = script:gsub(('<%%%s(.-)%%%s>'):format(sep, sep), '  %1  ')
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
    local sourceList
    local sourceUri
    for i, data in ipairs(datas) do
        local uri = furi.encode(data.path)
        local new, list = catch_target(data.content, '!')
        if new ~= data.content or data.target then
            if data.target then
                targetList[#targetList+1] = {
                    data.target[1],
                    data.target[2],
                    uri,
                }
            else
                for _, position in ipairs(list) do
                    targetList[#targetList+1] = {
                        position[1],
                        position[2],
                        uri,
                    }
                end
            end
            data.content = new
        end
        new, list = catch_target(data.content, '~')
        if new ~= data.content then
            sourceList = list
            sourceUri = uri
            data.content = new
        end
        new, list = catch_target(data.content, '?')
        if new ~= data.content then
            sourceList = list
            sourceUri = uri
            data.content = new
            for _, position in ipairs(list) do
                targetList[#targetList+1] = {
                    position[1],
                    position[2],
                    uri,
                }
            end
        end
        files.setText(uri, data.content)
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
            local <?f?> = require 'lib'
        ]],
    },
}

TEST {
    {
        path = 'a.lua',
        content = [[
            local <!f!> = require 'lib'
        ]],
    },
    {
        path = 'lib.lua',
        content = [[
            return <~function~> ()
            end
        ]],
        target = {22, 50},
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
            print(<?ROOT?>)
        ]],
    },
}

TEST {
    {
        path = 'a.lua',
        content = [[
            <?ROOT?> = 1
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
            local m = {}
            function m.<?func?>()
            end
            return m
        ]],
    },
    {
        path = 'b.lua',
        content = [[
            local t = require 'a'
            t.<!func!>()
        ]],
    },
}

TEST {
    {
        path = 'a.lua',
        content = [[
            return <?function () end?>
        ]],
    },
    {
        path = 'b.lua',
        content = [[
            local t = require 'a'
        ]],
    },
    {
        path = 'b.lua',
        content = [[
            local t = require 'a'
        ]],
    },
    {
        path = 'b.lua',
        content = [[
            local t = require 'a'
        ]],
    },
    {
        path = 'b.lua',
        content = [[
            local <!t!> = require 'a'
        ]],
    },
}

TEST {
    {
        path = 'a.lua',
        content = [[
            local f = require 'lib'
            local <?o?> = f()
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
            local function <?f?>()
            end

            return {
                <!f!> = <!f!>,
            }
        ]]
    },
    {
        path = 'b.lua',
        content = [[
            local t = require 'a'
            local <!f!> = t.<!f!>

            <!f!>()

            return {
                <!f!> = <!f!>,
            }
        ]]
    }
}

TEST {
    {
        path = 'a.lua',
        content = [[
            local function <!f!>()
            end

            return {
                <!f!> = <!f!>,
            }
        ]]
    },
    {
        path = 'c.lua',
        content = [[
            local t = require 'a'
            local <!f!> = t.<!f!>

            <!f!>()

            return {
                <!f!> = <!f!>,
            }
        ]]
    },
    {
        path = 'b.lua',
        content = [[
            local t = require 'a'
            local <!f!> = t.<!f!>

            <?f?>()

            return {
                <!f!> = <!f!>,
            }
        ]]
    }
}

TEST {
    {
        path = 'a.lua',
        content = [[
            local function <?f?>()
            end

            return {
                <!f!> = <!f!>,
            }
        ]]
    },
    {
        path = 'b1.lua',
        content = [[
            local t = require 'a'
            t.<!f!>()
        ]]
    },
    {
        path = 'b2.lua',
        content = [[
            local t = require 'a'
            t.<!f!>()
        ]]
    },
    {
        path = 'b3.lua',
        content = [[
            local t = require 'a'
            t.<!f!>()
        ]]
    },
    {
        path = 'b4.lua',
        content = [[
            local t = require 'a'
            t.<!f!>()
        ]]
    },
    {
        path = 'b5.lua',
        content = [[
            local t = require 'a'
            t.<!f!>()
        ]]
    },
    {
        path = 'b6.lua',
        content = [[
            local t = require 'a'
            t.<!f!>()
        ]]
    },
    {
        path = 'b7.lua',
        content = [[
            local t = require 'a'
            t.<!f!>()
        ]]
    },
}

TEST {
    {
        path = 'a.lua',
        content = [[
            local <?t?> = require 'b'
            return <!t!>
        ]]
    },
    {
        path = 'b.lua',
        content = [[
            local <!t!> = require 'a'
            return <!t!>
        ]]
    },
}
