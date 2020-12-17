local files  = require 'files'
local furi   = require 'file-uri'
local core   = require 'core.definition'
local config = require 'config'

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
        new, list = catch_target(data.content, '?')
        if new ~= data.content then
            sourceList = list
            sourceUri = uri
            data.content = new
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
        path = 'a.lua',
        content = '',
        target = {0, 0},
    },
    {
        path = 'b.lua',
        content = 'require <?"a"?>',
    },
}

TEST {
    {
        path = 'aaa/bbb.lua',
        content = '',
        target = {0, 0},
    },
    {
        path = 'b.lua',
        content = 'require "aaa.<?bbb?>"',
    },
}

TEST {
    {
        path = 'aaa/bbb.lua',
        content = '',
        target = {0, 0},
    },
    {
        path = 'b.lua',
        content = 'require "<?bbb?>"',
    },
}

TEST {
    {
        path = 'a.lua',
        content = 'local <!t!> = 1; return <!t!>',
    },
    {
        path = 'b.lua',
        content = 'local <?t?> = require "a"',
        target = {7, 7},
    },
}

if require 'bee.platform'.OS == 'Windows' then
TEST {
    {
        path = 'a.lua',
        content = '',
        target = {0, 0},
    },
    {
        path = 'b.lua',
        content = 'require <?"A"?>',
    },
}
end

TEST {
    {
        path = 'a.lua',
        content = 'local <!t!> = 1; return <!t!>',
    },
    {
        path = 'b.lua',
        content = 'local <?t?> = require "a"',
        target = {7, 7},
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
            local <?t?> = require 'a'
        ]],
        target = {19, 19},
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
            local t = GlobalTable

            t.settings = {
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
