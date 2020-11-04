local files = require 'files'
local furi  = require 'file-uri'
local core  = require 'core.hover'

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

function TEST(expect)
    files.removeAll()

    local targetScript = expect[1].content
    local targetUri = furi.encode(expect[1].path)

    local sourceScript, sourceList = catch_target(expect[2].content, '?')
    local sourceUri = furi.encode(expect[2].path)

    files.setText(targetUri, targetScript)
    files.setText(sourceUri, sourceScript)

    local sourcePos = (sourceList[1][1] + sourceList[1][2]) // 2
    local hover = core.byUri(sourceUri, sourcePos)
    assert(hover)
    if hover.label then
        hover.label = hover.label:gsub('\r\n', '\n')
    end
    assert(eq(hover.label, expect.hover.label))
    assert(eq(hover.description, expect.hover.description))
end

TEST {
    {
        path = 'a.lua',
        content = '',
    },
    {
        path = 'b.lua',
        content = 'require <?"a"?>',
    },
    hover = {
        label = '1 个字节',
        description = [[* [a.lua](file:///a.lua) （假设搜索路径包含 `?.lua`）]],
    }
}

TEST {
    {
        path = 'Folder/a.lua',
        content = '',
    },
    {
        path = 'b.lua',
        content = 'require <?"a"?>',
    },
    hover = {
        label = '1 个字节',
        description = [[* [Folder\a.lua](file:///Folder/a.lua) （假设搜索路径包含 `Folder\?.lua`）]],
    }
}

TEST {
    {
        path = 'a.lua',
        content = [[
            local function f(a, b)
            end
            return f
        ]],
    },
    {
        path = 'b.lua',
        content = [[
            local x = require 'a'
            <?x?>()
        ]]
    },
    hover = {
        label = 'function f(a: any, b: any)',
        name = 'f',
        args = EXISTS,
    }
}

TEST {
    {
        path = 'a.lua',
        content = [[
            return function (a, b)
            end
        ]],
    },
    {
        path = 'b.lua',
        content = [[
            local f = require 'a'
            <?f?>()
        ]]
    },
    hover = {
        label = 'function (a: any, b: any)',
        name = '',
        args = EXISTS,
    }
}

TEST {
    {
        path = 'a.lua',
        content = [[
            local mt = {}
            mt.__index = mt

            function mt:add(a, b)
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
    hover = {
        label = 'function mt:add(a: any, b: any)',
        name = 'mt:add',
        args = EXISTS,
    },
}

TEST {
    {
        path = 'a.lua',
        content = [[
            t = {
                [{}] = 1,
            }
        ]],
    },
    {
        path = 'b.lua',
        content = [[
            <?t?>[{}] = 2
        ]]
    },
    hover = {
        label = [[
global t: {
    [table]: integer = 1|2,
}]],
        name = 't',
    },
}

TEST {
    {
        path = 'a.lua',
        content = [[
            t = {
                [{}] = 1,
            }
        ]],
    },
    {
        path = 'a.lua',
        content = [[
            <?t?>[{}] = 2
        ]]
    },
    hover = {
        label = [[
global t: {
    [table]: integer = 2,
}]],
        name = 't',
    },
}

TEST {
    {
        path = 'a.lua',
        content = [[
            return {
                a = 1,
                b = 2,
            }
        ]],
    },
    {
        path = 'b.lua',
        content = [[
            local <?t?> = require 'a'
        ]]
    },
    hover = {
        label = [[
local t: {
    a: integer = 1,
    b: integer = 2,
}]],
        name = 't',
    },
}

TEST {
    {
        path = 'a.lua',
        content = '',
    },
    {
        path = 'b.lua',
        content = [[
            --- abc
            ---@param x number
            function <?f?>(x) end
        ]],
    },
    hover = {
        label = [[function f(x: number)]],
        name = 'f',
        description = ' abc',
        args = EXISTS,
    }
}

TEST {
    {
        path = 'a.lua',
        content = '',
    },
    {
        path = 'b.lua',
        content = [[
            --- abc
            <?x?> = 1
        ]],
    },
    hover = {
        label = [[global x: integer = 1]],
        name = 'x',
        description = ' abc',
    }
}

do return end
TEST {
    {
        path = 'a.lua',
        content = '',
    },
    {
        path = 'b.lua',
        content = [[
            ---@param x string
            ---|   "'选项1'" # 注释1
            ---| > "'选项2'" # 注释2
            function <?f?>(x) end
        ]]
    },
    hover = {
        label = 'function f(x: string)',
        name = 'f',
        args = EXISTS,
        rawEnum = EXISTS,
        enum = [[

x: string
   | '选项1' -- 注释1
   |>'选项2' -- 注释2]]
    }
}

TEST {
    {
        path = 'a.lua',
        content = '',
    },
    {
        path = 'b.lua',
        content = [[
            ---@alias option
            ---|   "'选项1'" # 注释1
            ---| > "'选项2'" # 注释2
            ---@param x option
            function <?f?>(x) end
        ]]
    },
    hover = {
        label = 'function f(x: option)',
        name = 'f',
        args = EXISTS,
        rawEnum = EXISTS,
        enum = [[

x: option
   | '选项1' -- 注释1
   |>'选项2' -- 注释2]]
    }
}

TEST {
    {
        path = 'a.lua',
        content = '',
    },
    {
        path = 'b.lua',
        content = [[
            ---@param x string {comment = 'aaaa'}
            ---@param y string {comment = 'bbbb'}
            local function <?f?>(x, y) end
        ]]
    },
    hover = {
        label = 'function f(x: string, y: string)',
        name = 'f',
        args = EXISTS,
        description = [[
+ `x`*(string)*: aaaa

+ `y`*(string)*: bbbb]]
    }
}
