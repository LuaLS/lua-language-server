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

local function catch_target(script)
    local list = {}
    local cur = 1
    while true do
        local start, finish  = script:find('<[!?].-[!?]>', cur)
        if not start then
            break
        end
        list[#list+1] = { start + 2, finish - 2 }
        cur = finish + 1
    end
    return list
end

local function founded(targets, results)
    if #targets ~= #results then
        return false
    end
    for _, target in ipairs(targets) do
        for _, result in ipairs(results) do
            if target[1] == result[1] and target[2] == result[2] then
                goto NEXT
            end
        end
        do return false end
        ::NEXT::
    end
    return true
end

local function compileAll(lsp)
    while lsp._needCompile[1] do
        lsp:compileVM(lsp._needCompile[1])
    end
end

function TEST(data)
    local lsp = service()
    local ws = workspace(lsp, 'test')
    lsp.workspace = ws
    ws.root = ROOT

    local mainUri
    local pos
    local expect = {}
    for _, info in ipairs(data) do
        local uri = uric.encode(ROOT / fs.path(info.path))
        ws:addFile(uric.decode(uri))
    end
    for _, info in ipairs(data) do
        local uri = uric.encode(ROOT / fs.path(info.path))
        local script = info.content
        local list = catch_target(script)
        for _, location in ipairs(list) do
            expect[#expect+1] = {
                location[1],
                location[2],
                uri,
            }
        end
        local start  = script:find('<?', 1, true)
        local finish = script:find('?>', 1, true)
        if start then
            mainUri = uri
            pos = (start + finish) // 2 + 1
        end
        local newScript = script:gsub('<[!?]', '  '):gsub('[!?]>', '  ')
        lsp:saveText(uri, 1, newScript)
        compileAll(lsp)
    end

    local vm = lsp:loadVM(mainUri)

    compileAll(lsp)

    assert(vm)
    local result = core.definition(vm, pos, 'reference')
    if expect then
        assert(result)
        assert(founded(expect, result))
    else
        assert(result == nil)
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
            return <?function ()
            end?>
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
