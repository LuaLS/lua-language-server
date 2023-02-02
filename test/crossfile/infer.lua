local files  = require 'files'
local furi   = require 'file-uri'
local vm     = require 'vm'
local guide  = require 'parser.guide'
local catch  = require 'catch'

rawset(_G, 'TEST', true)

local function getSource(uri, pos)
    local state = files.getState(uri)
    if not state then
        return
    end
    local result
    guide.eachSourceContain(state.ast, pos, function (source)
        if source.type == 'local'
        or source.type == 'getlocal'
        or source.type == 'setlocal'
        or source.type == 'setglobal'
        or source.type == 'getglobal'
        or source.type == 'field'
        or source.type == 'method'
        or source.type == 'function'
        or source.type == 'table'
        or source.type == 'doc.type.name' then
            result = source
        end
    end)
    return result
end

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

---@diagnostic disable: await-in-sync
function TEST(expect)
    local sourcePos, sourceUri
    for _, file in ipairs(expect) do
        local script, list = catch(file.content, '?')
        local uri          = furi.encode(file.path)
        files.setText(uri, script)
        files.compileState(uri)
        if #list['?'] > 0 then
            sourceUri = uri
            sourcePos = (list['?'][1][1] + list['?'][1][2]) // 2
        end
    end

    local _ <close> = function ()
        for _, info in ipairs(expect) do
            files.remove(furi.encode(info.path))
        end
    end

    local source = getSource(sourceUri, sourcePos)
    assert(source)
    local view = vm.getInfer(source):view(sourceUri)
    assert(eq(view, expect.infer))
end

TEST {
    {
        path = 'a.lua',
        content = [[
---@class T
local x

---@class V
x.y = 1
]],
    },
    {
        path = 'b.lua',
        content = [[
---@type T
local x

if x.y then
    print(x.<?y?>)
end
        ]],
    },
    infer = 'V',
}

TEST {
    { path = 'a.lua', content = [[
X = 1
X = true
]], },
    { path = 'b.lua', content = [[
print(<?X?>)
]], },
    infer = 'integer',
}

TEST {
    { path = 'a.lua', content = [[
---@meta
X = 1
X = true
]], },
    { path = 'b.lua', content = [[
print(<?X?>)
]], },
    infer = 'boolean|integer',
}

TEST {
    { path = 'a.lua', content = [[
return 1337, "string", true
]], },
    { path = 'b.lua', content = [[
local <?a?>, b, c = require 'a
]], },
    infer = 'integer',
}

TEST {
    { path = 'a.lua', content = [[
return 1337, "string", true
]], },
    { path = 'b.lua', content = [[
local a, <?b?>, c = require 'a
]], },
    infer = 'unknown',
}

TEST {
    { path = 'a.lua', content = [[
return 1337, "string", true
]], },
    { path = 'b.lua', content = [[
local a, b, <?c?> = require 'a
]], },
    infer = 'nil',
}
