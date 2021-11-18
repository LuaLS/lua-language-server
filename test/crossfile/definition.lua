local files    = require 'files'
local furi     = require 'file-uri'
local core     = require 'core.definition'
local config   = require 'config'
local platform = require 'bee.platform'
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

function TEST(datas)
    files.removeAll()

    local targetList = {}
    local sourceList
    local sourceUri
    for i, data in ipairs(datas) do
        local uri = furi.encode(data.path)
        local newScript, catched = catch(data.content, '!?~')
        for _, position in ipairs(catched['!'] or {}) do
            targetList[#targetList+1] = {
                position[1],
                position[2],
                uri,
            }
        end
        for _, position in ipairs(catched['~'] or {}) do
            targetList[#targetList+1] = {
                position[1],
                position[2],
                uri,
            }
        end
        if catched['?'] or catched['~'] then
            sourceList = catched['?'] or catched['~']
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
        path = 'a.lua',
        content = '<!!>',
    },
    {
        path = 'b.lua',
        content = 'require <?"a"?>',
    },
}

TEST {
    {
        path = 'aaa/bbb.lua',
        content = '<!!>',
    },
    {
        path = 'b.lua',
        content = 'require "aaa.<?bbb?>"',
    },
}

TEST {
    {
        path = '@bbb.lua',
        content = '<!!>',
    },
    {
        path = 'b.lua',
        content = 'require "<?@bbb?>"',
    },
}

TEST {
    {
        path = 'aaa/bbb.lua',
        content = '<!!>',
    },
    {
        path = 'b.lua',
        content = 'require "<?bbb?>"',
    },
}

config.set('Lua.runtime.pathStrict', true)
TEST {
    {
        path = 'aaa/bbb.lua',
        content = '',
    },
    {
        path = 'b.lua',
        content = 'require "<?bbb?>"',
    },
}

TEST {
    {
        path = 'aaa/bbb.lua',
        content = '<!!>',
    },
    {
        path = 'b.lua',
        content = 'require "<?aaa.bbb?>"',
    },
}

config.set('Lua.runtime.pathStrict', false)

TEST {
    {
        path = 'a.lua',
        content = 'local <!t!> = 1; return <!t!>',
    },
    {
        path = 'b.lua',
        content = 'local <~t~> = require "a"',
    },
}

TEST {
    {
        path = 'a.lua',
        content = 'local <!t!> = 1; return <!t!>',
    },
    {
        path = 'b.lua',
        content = [[
---@module 'a'
local <~t~>
]],
    },
}

--if require 'bee.platform'.OS == 'Windows' then
--TEST {
--    {
--        path = 'a.lua',
--        content = '',
--        target = {0, 0},
--    },
--    {
--        path = 'b.lua',
--        content = 'require <?"A"?>',
--    },
--}
--end

TEST {
    {
        path = 'a.lua',
        content = 'local <!t!> = 1; return <!t!>',
    },
    {
        path = 'b.lua',
        content = 'local <~t~> = require "a"',
    },
}

TEST {
    {
        path = 'a.lua',
        content = [[
            local t = {
                <!x!> = 1,
            }
            return t
        ]],
    },
    {
        path = 'b.lua',
        content = [[
            local t = require "a"
            t.<?x?>()
        ]],
    },
}

TEST {
    {
        path = 'a.lua',
        content = [[
            return {
                <!x!> = 1,
            }
        ]],
    },
    {
        path = 'b.lua',
        content = [[
            local t = require "a"
            t.<?x?>()
        ]],
    },
}

TEST {
    {
        path = 'a.lua',
        content = [[
            return <!function ()
            end!>
        ]],
    },
    {
        path = 'b.lua',
        content = [[
            local <!f!> = require "a"
            <?f?>()
        ]],
    },
}

TEST {
    {
        path = 'a.lua',
        content = [[
            return <!a():b():c()!>
        ]],
    },
    {
        path = 'b.lua',
        content = [[
            local <~t~> = require 'a'
        ]],
    },
}

TEST {
    {
        path = 'a.lua',
        content = [[
            <!global!> = 1
        ]],
    },
    {
        path = 'b.lua',
        content = [[
            print(<?global?>)
        ]],
    }
}

TEST {
    {
        path = 'b.lua',
        content = [[
            print(<?global?>)
        ]],
    },
    {
        path = 'a.lua',
        content = [[
            <!global!> = 1
        ]],
    },
}

TEST {
    {
        path = 'a.lua',
        content = [[
            x = {}
            x.<!global!> = 1
        ]],
    },
    {
        path = 'b.lua',
        content = [[
            print(x.<?global?>)
        ]],
    },
}

TEST {
    {
        path = 'a.lua',
        content = [[
            x.<!global!> = 1
        ]],
    },
    {
        path = 'b.lua',
        content = [[
            print(x.<?global?>)
        ]],
    },
    {
        path = 'c.lua',
        content = [[
            x = {}
        ]]
    }
}

TEST {
    {
        path = 'a.lua',
        content = [[
            return function (<!arg!>)
                print(<?arg?>)
            end
        ]],
    },
    {
        path = 'b.lua',
        content = [[
            local f = require 'a'
            local v = 1
            f(v)
        ]],
    },
}

TEST {
    {
        path = 'a.lua',
        content = [[
            return <!{
                a = 1,
            }!>
        ]],
    },
    {
        path = 'b.lua',
        content = [[
            local <!t!> = require 'a'
            <?t?>
        ]],
    }
}

TEST {
    {
        path = 'a.lua',
        content = [[
            return <!function () end!>
        ]]
    },
    {
        path = 'b.lua',
        content = [[
            local f = require 'a'
        ]]
    },
    {
        path = 'c.lua',
        content = [[
            local <!f!> = require 'a'
            <?f?>
        ]]
    }
}

TEST {
    {
        path = 'a.lua',
        content = [[
            local function <!f!>()
            end
            return <!f!>
        ]]
    },
    {
        path = 'b.lua',
        content = [[
            local f = require 'a'
        ]]
    },
    {
        path = 'c.lua',
        content = [[
            local <!f!> = require 'a'
            <?f?>
        ]]
    }
}

TEST {
    {
        path = 'a/xxx.lua',
        content = [[
            return <!function () end!>
        ]]
    },
    {
        path = 'b/xxx.lua',
        content = [[
            local <!f!> = require 'xxx'
            <?f?>
            return function () end
        ]]
    }
}

TEST {
    {
        path = 'a.lua',
        content = [[
            local <!x!>
            return {
                <!x!> = x,
            }
        ]],
    },
    {
        path = 'b.lua',
        content = [[
            local t = require 'a'
            print(t.<?x?>)
        ]],
    },
}

TEST {
    {
        path = 'a.lua',
        content = [[
            local function <!f!>()
            end

            return {
                <!f!> = f,
            }
        ]]
    },
    {
        path = 'c.lua',
        content = [[
            local t = require 'a'
            local f = t.f

            f()

            return {
                f = f,
            }
        ]]
    },
    {
        path = 'b.lua',
        content = [[
            local t = require 'a'
            local <!f!> = t.f

            <?f?>()

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
            local m = {}
            function m.<!func!>()
            end
            return m
        ]]
    },
    {
        path = 'b.lua',
        content = [[
            local x = require 'a'
            print(x.<?func?>)
        ]]
    }
}

TEST {
    {
        path = 'a.lua',
        content = [[
            local m = {}
            function m.<!func!>()
            end
            return m
        ]]
    },
    {
        path = 'c.lua',
        content = [[
            local x = require 'a'
            print(x.func)
        ]]
    },
    {
        path = 'b.lua',
        content = [[
            local x = require 'a'
            print(x.<?func?>)
        ]]
    }
}

TEST {
    {
        path = 'a.lua',
        content = [[
            return <!function ()
            end!>
        ]]
    },
    {
        path = 'middle.lua',
        content = [[
            return {
                <!func!> = require 'a'
            }
        ]]
    },
    {
        path = 'b.lua',
        content = [[
            local x = require 'middle'
            print(x.<?func?>)
        ]]
    }
}

TEST {
    {
        path = 'a.lua',
        content = [[
            local mt = {}
            mt.__index = mt

            function mt:<!add!>(a, b)
            end
            
            return function ()
                return setmetatable({}, mt)
            end
        ]],
    },
    {
        path = 'b.lua',
        content = [[
            local m = require 'a'
            local obj = m()
            obj:<?add?>()
        ]]
    },
}

TEST {
    {
        path = 'a.lua',
        content = [[
            GlobalTable.settings = {
                <!test!> = 1
            }
        ]],
    },
    {
        path = 'b.lua',
        content = [[
            local b = GlobalTable.settings

            print(b.<?test?>)
        ]]
    },
}

TEST {
    {
        path = 'a.lua',
        content = [[
            ---@class Class
            local <!obj!>
        ]]
    },
    {
        path = 'b.lua',
        content = [[
            ---@type Class
            local <!obj!>
            <?obj?>
        ]]
    },
}

TEST {
    {
        path = 'a.lua',
        content = [[
            ---@type Class
            local <!obj!>
            <?obj?>
        ]]
    },
    {
        path = 'b.lua',
        content = [[
            ---@class Class
            local <!obj!>
        ]]
    },
}

TEST {
    {
        path = 'a.lua',
        content = [[
            local lib = {}

            function lib:fn1()
                return self
            end
            
            function lib:<!fn2!>()
            end
            
            return lib:fn1()
        ]]
    },
    {
        path = 'b.lua',
        content = [[
            local app = require 'a'
            print(app.<?fn2?>)
        ]]
    },
}

TEST {
    {
        path = 'a.lua',
        content = [[
            local m = {}

            function m.<!f!>()
            end

            return setmetatable(m, {})
        ]],
    },
    {
        path = 'b.lua',
        content = [[
            local m = require 'a'

            m.<?f?>()
        ]]
    }
}

local originOS = platform.OS
platform.OS = 'Linux'

TEST {
    {
        path = 'test.lua',
        content = [[
            return {
                <!x!> = 1,
            }
        ]],
    },
    {
        path = 'Test.lua',
        content = [[
            return {
                x = 1,
            }
        ]],
    },
    {
        path = 'b.lua',
        content = [[
            local t = require 'test'
            print(t.<?x?>)
        ]]
    }
}

TEST {
    {
        path = 'test.lua',
        content = [[
            return {
                x = 1,
            }
        ]],
    },
    {
        path = 'Test.lua',
        content = [[
            return {
                <!x!> = 1,
            }
        ]],
    },
    {
        path = 'b.lua',
        content = [[
            local t = require 'Test'
            print(t.<?x?>)
        ]]
    }
}
platform.OS = originOS

local originRuntimePath = config.get 'Lua.runtime.path'
config.set('Lua.runtime.path', {
    '?/1.lua',
})
TEST {
    {
        path = 'd:/xxxx/1.lua',
        content = [[
            return <!function () end!>
        ]],
    },
    {
        path = 'main.lua',
        content = [[
            local <!f!> = require 'xxxx'
            print(<?f?>)
        ]],
    },
}

config.set('Lua.runtime.path', {
    'D:/?/1.lua',
})
TEST {
    {
        path = 'D:/xxxx/1.lua',
        content = [[
            return <!function () end!>
        ]],
    },
    {
        path = 'main.lua',
        content = [[
            local <!f!> = require 'xxxx'
            print(<?f?>)
        ]],
    },
}
config.set('Lua.runtime.path', originRuntimePath)

TEST {
    {
        path = 'a.lua',
        content = [[
            a = b.x
        ]],
    },
    {
        path = 'b.lua',
        content = [[
            b = a.<?x?>
        ]],
    },
}

config.set('Lua.IntelliSense.traceFieldInject', true)
TEST {
    {
        path = 'a.lua',
        content = [[
local t = GlobalTable

t.settings = {
    <!test!> = 1
}
        ]]
    },
    {
        path = 'b.lua',
        content = [[
local b = GlobalTable.settings

print(b.<?test?>)
        ]]
    }
}
config.set('Lua.IntelliSense.traceFieldInject', false)

TEST {
    {
        path = 'a.lua',
        content = [[
---@class A
local t

t.<!a!> = 1
        ]]
    },
    {
        path = 'b.lua',
        content = [[
---@class B
local t

---@type A
t.x = nil

print(t.x.<?a?>)
        ]]
    }
}

TEST {
    {
        path = 'a.lua',
        content = [[
return {
    <!x!> = 1,
}
]],
    },
    {
        path = 'f/a.lua',
        content = [[
return {
    x = 1,
}
]]
    },
    {
        path = 'b.lua',
        content = [[
local t = require 'a'
print(t.<?x?>)
        ]]
    }
}
