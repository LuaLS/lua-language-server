local core = require 'core.document-symbol'
local files = require 'files'
local SymbolKind = require 'define.SymbolKind'

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

local function checkArcoss(symbols)
    local lastFinish = 0
    for _, symbol in ipairs(symbols) do
        assert(symbol.range[1] <= symbol.selectionRange[1])
        assert(symbol.range[2] >= symbol.selectionRange[2])
        assert(symbol.range[2] > lastFinish)
        lastFinish = symbol.range[2]
        if symbol.children then
            checkArcoss(symbol.children)
        end
    end
end

function TEST(script)
    return function (expect)
        files.removeAll()
        files.setText('', script)
        local result = core('')
        assert(eq(expect, result))
        checkArcoss(result)
    end
end

TEST [[
local function f()
end
]]
{
    [1] = {
        name = 'f',
        detail = 'function f()',
        kind = SymbolKind.Function,
        range = {1, 22},
        selectionRange = {16, 16},
        valueRange = {1, 22},
    }
}

TEST [[
function f()
end
]]
{
    [1] = {
        name = 'f',
        detail = 'function f()',
        kind = SymbolKind.Function,
        range = {1, 16},
        selectionRange = {10, 10},
        valueRange = {1, 16},
    }
}

TEST [[
return function ()
end
]]
{
    [1] = {
        name = '',
        detail = 'function ()',
        kind = SymbolKind.Function,
        range = {8, 22},
        selectionRange = {8, 8},
        valueRange = {8, 22},
    }
}

TEST [[
f = function ()
end
]]
{
    [1] = {
        name = 'f',
        detail = 'function f()',
        kind = SymbolKind.Function,
        range = {1, 1},
        selectionRange = {1, 1},
        valueRange = {5, 19},
    }
}

TEST [[
local f = function ()
end
]]
{
    [1] = {
        name = 'f',
        detail = 'function f()',
        kind = SymbolKind.Function,
        range = {7, 7},
        selectionRange = {7, 7},
        valueRange = {11, 25},
    }
}

TEST [[
function mt:add()
end
]]
{
    [1] = {
        name = 'mt:add',
        detail = 'function mt:add()',
        kind = SymbolKind.Field,
        range = {1, 21},
        selectionRange = {10, 15},
        valueRange = {1, 21},
    }
}

TEST [[
function A()
    function A1()
    end
    function A2()
    end
end
function B()
end
]]
{
    [1] = {
        name = 'A',
        detail = 'function A()',
        kind = SymbolKind.Function,
        range = {1, 68},
        selectionRange = {10, 10},
        valueRange = {1, 68},
        children = {
            [1] = {
                name = 'A1',
                detail = 'function A1()',
                kind = SymbolKind.Function,
                range = {18, 38},
                selectionRange = {27, 28},
                valueRange = {18, 38},
            },
            [2] = {
                name = 'A2',
                detail = 'function A2()',
                kind = SymbolKind.Function,
                range = {44, 64},
                selectionRange = {53, 54},
                valueRange = {44, 64},
            },
        },
    },
    [2] = {
        name = 'B',
        detail = 'function B()',
        kind = SymbolKind.Function,
        range = {70, 85},
        selectionRange = {79, 79},
        valueRange = {70, 85},
    },
}

TEST [[
local x = 1
local function f()
    local x = 'x'
    local y = {}
    --= 1
end
local y = true
local z
]]
{
    [1] = {
        name = 'x',
        detail = 'local x: number = 1',
        kind = SymbolKind.Variable,
        range = {7, 7},
        selectionRange = {7, 7},
        valueRange = {11, 11},
    },
    [2] = {
        name = 'f',
        detail = 'function f()',
        kind = SymbolKind.Function,
        range = {13, 79},
        selectionRange = {28, 28},
        valueRange = {13, 79},
        children = {
            [1] = {
                name = 'x',
                detail = 'local x: string = "x"',
                kind = SymbolKind.Variable,
                range = {42, 42},
                selectionRange = {42, 42},
                valueRange = {46, 48},
            },
            [2] = {
                name = 'y',
                detail = 'local y: {}',
                kind = SymbolKind.Variable,
                range = {60, 60},
                selectionRange = {60, 60},
                valueRange = {64, 65},
            },
            --[3] = {
            --    name = 'z',
            --    detail = 'global z: number = 1',
            --    kind = SymbolKind.Object,
            --    range = {71, 71},
            --    selectionRange = {71, 71},
            --    valueRange = {75, 75},
            --},
        },
    },
    [3] = {
        name = 'y',
        detail = 'local y: boolean = true',
        kind = SymbolKind.Variable,
        range = {87, 87},
        selectionRange = {87, 87},
        valueRange = {91, 94},
    },
    [4] = {
        name = 'z',
        detail = 'local z',
        kind = SymbolKind.Variable,
        range = {102, 102},
        selectionRange = {102, 102},
        valueRange = {102, 102},
    },
}

TEST [[
local t = {
    a = 1,
    b = 2,
    c = 3,
}
]]
{
    [1] = {
        name = 't',
        detail = 'local t: {a = ..., b = ..., c = ...}',
        kind = SymbolKind.Variable,
        range = {7, 7},
        selectionRange = {7, 7},
        valueRange = {11, 46},
        children = {
            [1] = {
                name = 'a',
                detail = 'field a: number = 1',
                kind = SymbolKind.Class,
                range = {17, 17},
                selectionRange = {17, 17},
                valueRange = {21, 21},
            },
            [2] = {
                name = 'b',
                detail = 'field b: number = 2',
                kind = SymbolKind.Class,
                range = {28, 28},
                selectionRange = {28, 28},
                valueRange = {32, 32},
            },
            [3] = {
                name = 'c',
                detail = 'field c: number = 3',
                kind = SymbolKind.Class,
                range = {39, 39},
                selectionRange = {39, 39},
                valueRange = {43, 43},
            },
        }
    }
}

TEST [[
local t = {
    a = {
        b = 1,
    }
}
]]
{
    [1] = {
        name = 't',
        detail = EXISTS,
        kind = SymbolKind.Variable,
        range = {7, 7},
        selectionRange = {7, 7},
        valueRange = {11, 44},
        children = {
            [1] = {
                name = 'a',
                detail = EXISTS,
                kind = SymbolKind.Class,
                range = {17, 17},
                selectionRange = {17, 17},
                valueRange = {21, 42},
                children = {
                    [1] = {
                        name = 'b',
                        detail = EXISTS,
                        kind = SymbolKind.Class,
                        range = {31, 31},
                        selectionRange = {31, 31},
                        valueRange = {35, 35},
                    }
                }
            },
        }
    }
}

TEST[[
local function g()
end

g = 1
]]{
    [1] = {
        name = 'g',
        detail = 'function g()',
        kind = SymbolKind.Function,
        range = {1, 22},
        selectionRange = {16, 16},
        valueRange = {1, 22},
    },
    [2] = {
        name = 'g',
        detail = 'setlocal g: number = 1',
        kind = SymbolKind.Variable,
        range = {25, 25},
        selectionRange = {25, 25},
        valueRange = {29, 29},
    }
}

TEST[[
function f(a, b, ...)
    local x = ...
    print(x.a)
end
]]{
    [1] = {
        name = 'f',
        detail = 'function f(a, b, ...)',
        kind = SymbolKind.Function,
        range = {1, 58},
        selectionRange = {10, 10},
        valueRange = {1, 58},
        children = {
            [1] = {
                name = 'a',
                detail = 'param a',
                kind = SymbolKind.TypeParameter,
                range = {12, 12},
                selectionRange = {12, 12},
                valueRange = {12, 12},
            },
            [2] = {
                name = 'b',
                detail = 'param b',
                kind = SymbolKind.TypeParameter,
                range = {15, 15},
                selectionRange = {15, 15},
                valueRange = {15, 15},
            },
            [3] = {
                name = 'x',
                detail = 'local x',
                kind = SymbolKind.Variable,
                range = {33, 33},
                selectionRange = {33, 33},
                valueRange = {37, 39},
            }
        }
    },
}

TEST [[
local t = {
    a = 1,
    b = 2,
}

local v = t
]]{
    [1] = {
        name = 't',
        detail = EXISTS,
        kind = SymbolKind.Variable,
        range = {7, 7},
        selectionRange = {7, 7},
        valueRange = {11, 35},
        children = EXISTS,
    },
    [2] = {
        name = 'v',
        detail = EXISTS,
        kind = SymbolKind.Variable,
        range = {44, 44},
        selectionRange = {44, 44},
        valueRange = {48, 48},
    },
}

TEST [[
local x
local function
]]{
    [1] = {
        name = 'x',
        detail = 'local x',
        kind = SymbolKind.Variable,
        range = {7, 7},
        selectionRange = {7, 7},
        valueRange = {7, 7},
    },
}
