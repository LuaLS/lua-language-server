local config = require 'config'

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
            return <!<?function?> ()
            end!>
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
            return <~function () end~>
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

config.set('Lua.IntelliSense.traceBeSetted', true)
TEST {
    {
        path = 'a.lua',
        content = [[
            local function <~f~>()
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

            <~f~>()

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
            local function <~f~>()
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
            local <~t~> = require 'b'
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
config.set('Lua.IntelliSense.traceBeSetted', false)

