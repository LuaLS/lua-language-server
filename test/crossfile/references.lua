---@diagnostic disable: await-in-sync
local files    = require 'files'
local furi     = require 'file-uri'
local core     = require 'core.reference'
local catch    = require 'catch'

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

local function TEST(datas)
    local targetList = {}
    local sourceList
    local sourceUri
    for i, data in ipairs(datas) do
        local uri = furi.encode(TESTROOT .. data.path)
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
        if #catched['?'] > 0 or #catched['~'] > 0 then
            sourceList = catched['?'] + catched['~']
            sourceUri = uri
        end
        files.setText(uri, newScript)
        files.compileState(uri)
    end

    local _ <close> = function ()
        for _, info in ipairs(datas) do
            files.remove(furi.encode(TESTROOT .. info.path))
        end
    end

    local sourcePos = (sourceList[1][1] + sourceList[1][2]) // 2
    local positions = core(sourceUri, sourcePos, true)
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

TEST {
    {
        path = 'a.lua',
        content = [[
            local t = {}
            t.<~x~> = 1
            return t
        ]]
    },
    {
        path = 'b.lua',
        content = [[
            local t = require 'a'

            print(t.<!x!>)
        ]]
    }
}

TEST {
    {
        path = 'a.lua',
        content = [[
            local f = require 'lib'
            <!f!>()
        ]],
    },
    {
        path = 'lib.lua',
        content = [[
            return <?function?> ()
            end
        ]],
    },
}

TEST {
    {
        path = 'a.lua',
        content = [[
            local m = {}
            function m.<~func~>()
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
            return <?function?> () end
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
            local t = require 'a'
            <!t!>()
        ]],
    },
}

TEST {
    {
        path = 'a.lua',
        content = [[
            local function <~f~>()
            end

            return {
                f = <!f!>,
            }
        ]]
    },
    {
        path = 'b.lua',
        content = [[
            local t = require 'a'
            local f = t.f

            f()

            return {
                f = f,
            }
        ]]
    }
}

TEST {
    {
        path = 'a.lua',
        content = [[
            local <?function?> f()
            end

            return {
                f = f,
            }
        ]]
    },
    {
        path = 'b.lua',
        content = [[
            local t = require 'a'
            local f = t.f

            <!f!>()

            return {
                f = f,
            }
        ]]
    }
}

TEST {
    {
        path = 'a.lua',
        content = [[
            local <?function?> f()
            end

            return {
                f = f,
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
            local <~x~> = require 'b'
            return <!x!>
        ]]
    },
    {
        path = 'b.lua',
        content = [[
            local y = require 'a'
            return y
        ]]
    },
}

TEST {
    {
        path = 'a.lua',
        content = [[
            ---@alias <~XX~> number
        ]]
    },
    {
        path = 'b.lua',
        content = [[
            ---@type <!XX!>
        ]]
    }
}
