local service = require 'service'
local workspace = require 'workspace'
local fs = require 'bee.filesystem'
local core = require 'core'

local SymbolKind = {
    File = 1,
    Module = 2,
    Namespace = 3,
    Package = 4,
    Class = 5,
    Method = 6,
    Property = 7,
    Field = 8,
    Constructor = 9,
    Enum = 10,
    Interface = 11,
    Function = 12,
    Variable = 13,
    Constant = 14,
    String = 15,
    Number = 16,
    Boolean = 17,
    Array = 18,
    Object = 19,
    Key = 20,
    Null = 21,
    EnumMember = 22,
    Struct = 23,
    Event = 24,
    Operator = 25,
    TypeParameter = 26,
}

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

rawset(_G, 'TEST', true)

function TEST(data)
    local lsp = service()
    local ws = workspace(lsp, 'test')
    lsp.workspace = ws

    local targetUri = ws:uriEncode(fs.path(data[1].path))
    local sourceUri = ws:uriEncode(fs.path(data[2].path))

    lsp:saveText(sourceUri, 1, data[2].content)
    ws:addFile(sourceUri)
    lsp:saveText(targetUri, 1, data[1].content)
    ws:addFile(targetUri)
    while lsp._needCompile[1] do
        lsp:compileVM(lsp._needCompile[1])
    end

    local sourceVM = lsp:getVM(sourceUri)
    assert(sourceVM)
    local result = core.documentSymbol(sourceVM)
    assert(eq(data.symbol, result))
end

TEST {
    {
        path = 'a.lua',
        content = 'return function () end',
    },
    {
        path = 'b.lua',
        content = [[
local t = {
    x = require 'a',
}
        ]],
    },
    symbol = {
        [1] = {
            name = 't',
            detail = EXISTS,
            kind = SymbolKind.Variable,
            range = {7, 34},
            selectionRange = {7, 7},
            children = {
                [1] = {
                    name = 'x',
                    detail = EXISTS,
                    kind = SymbolKind.Class,
                    range = {17, 17},
                    selectionRange = {17, 17},
                },
            }
        }
    }
}
