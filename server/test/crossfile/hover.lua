local service = require 'service'
local workspace = require 'workspace'
local fs = require 'bee.filesystem'
local core = require 'core'
local uric = require 'uri'

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

function TEST(data)
    local lsp = service()
    local ws = workspace(lsp, 'test')
    lsp.workspace = ws
    ws.root = ROOT

    local targetScript = data[1].content
    local targetUri = uric.encode(fs.path(data[1].path))

    local sourceScript, sourceList = catch_target(data[2].content, '?')
    local sourceUri = uric.encode(fs.path(data[2].path))

    lsp:saveText(targetUri, 1, targetScript)
    ws:addFile(uric.decode(targetUri))
    lsp:compileVM(targetUri)
    lsp:saveText(sourceUri, 1, sourceScript)
    ws:addFile(uric.decode(sourceUri))
    lsp:compileVM(sourceUri)

    local sourceVM = lsp:loadVM(sourceUri)
    assert(sourceVM)
    local sourcePos = (sourceList[1][1] + sourceList[1][2]) // 2
    local source = core.findSource(sourceVM, sourcePos)
    local hover = core.hover(source, lsp)
    assert(hover)
    if data.hover.description then
        local uriROOT = uric.encode(ROOT):gsub('%%', '%%%%')
        data.hover.description = data.hover.description:gsub('%$ROOT%$', uriROOT)
    end
    if hover.label then
        hover.label = hover.label:gsub('\r\n', '\n')
    end
    assert(eq(hover, data.hover))
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
        description = [[[a.lua]($ROOT$/a.lua)]],
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
    [*table]: number = 1,
    [*table]: number = 2,
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
    [*table]: number = 2,
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
        description = 'abc',
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
        label = [[global x: number = 1]],
        name = 'x',
        description = 'abc',
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
            ---@param x string
            ---| "'选项1'" {comment = '注释1'}
            ---| "'选项2'" {comment = '注释2', default = true}
            function <?f?>(x) end
        ]]
    },
    hover = {
        label = 'function f(x: string)',
        name = 'f',
        enum = [[

x:string
   | '选项1' -- 注释1
   |>'选项2' -- 注释2]]
    }
}
