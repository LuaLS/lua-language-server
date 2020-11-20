local core   = require 'core.document-symbol'
local files  = require 'files'
local define = require 'proto.define'

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
A = 1
]]
{
    [1] = {
        name = 'A',
        detail = 'global number = 1',
        kind = define.SymbolKind.Class,
        range = {1, 5},
        selectionRange = {1, 1},
    }
}

TEST [[
local function f()
end
]]
{
    [1] = {
        name = 'f',
        detail = 'function ()',
        kind = define.SymbolKind.Function,
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
        detail = 'function ()',
        kind = define.SymbolKind.Function,
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
        detail = 'return function ()',
        kind = define.SymbolKind.Function,
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
        detail = 'function ()',
        kind = define.SymbolKind.Function,
        range = {1, 19},
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
        detail = 'function ()',
        kind = define.SymbolKind.Function,
        range = {7, 25},
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
        detail = 'function ()',
        kind = define.SymbolKind.Method,
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
        detail = 'function ()',
        kind = define.SymbolKind.Function,
        range = {1, 68},
        selectionRange = {10, 10},
        valueRange = {1, 68},
        children = {
            [1] = {
                name = 'A1',
                detail = 'function ()',
                kind = define.SymbolKind.Function,
                range = {18, 38},
                selectionRange = {27, 28},
                valueRange = {18, 38},
            },
            [2] = {
                name = 'A2',
                detail = 'function ()',
                kind = define.SymbolKind.Function,
                range = {44, 64},
                selectionRange = {53, 54},
                valueRange = {44, 64},
            },
        },
    },
    [2] = {
        name = 'B',
        detail = 'function ()',
        kind = define.SymbolKind.Function,
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
        detail = 'local number = 1',
        kind = define.SymbolKind.Variable,
        range = {7, 11},
        selectionRange = {7, 7},
    },
    [2] = {
        name = 'f',
        detail = 'function ()',
        kind = define.SymbolKind.Function,
        range = {13, 79},
        selectionRange = {28, 28},
        valueRange = {13, 79},
        children = {
            [1] = {
                name = 'x',
                detail = 'local string = "x"',
                kind = define.SymbolKind.Variable,
                range = {42, 48},
                selectionRange = {42, 42},
            },
            [2] = {
                name = 'y',
                detail = 'local {}',
                kind = define.SymbolKind.Variable,
                range = {60, 65},
                selectionRange = {60, 60},
                valueRange = {64, 65},
            },
            --[3] = {
            --    name = 'z',
            --    detail = 'global z: number = 1',
            --    kind = define.SymbolKind.Object,
            --    range = {71, 71},
            --    selectionRange = {71, 71},
            --    valueRange = {75, 75},
            --},
        },
    },
    [3] = {
        name = 'y',
        detail = 'local boolean = true',
        kind = define.SymbolKind.Variable,
        range = {87, 94},
        selectionRange = {87, 87},
    },
    [4] = {
        name = 'z',
        detail = 'local',
        kind = define.SymbolKind.Variable,
        range = {102, 102},
        selectionRange = {102, 102},
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
        detail = 'local {a, b, c}',
        kind = define.SymbolKind.Variable,
        range = {7, 46},
        selectionRange = {7, 7},
        valueRange = {11, 46},
        children = {
            [1] = {
                name = 'a',
                detail = 'field number = 1',
                kind = define.SymbolKind.Property,
                range = {17, 21},
                selectionRange = {17, 17},
            },
            [2] = {
                name = 'b',
                detail = 'field number = 2',
                kind = define.SymbolKind.Property,
                range = {28, 32},
                selectionRange = {28, 28},
            },
            [3] = {
                name = 'c',
                detail = 'field number = 3',
                kind = define.SymbolKind.Property,
                range = {39, 43},
                selectionRange = {39, 39},
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
        detail = 'local {a}',
        kind = define.SymbolKind.Variable,
        range = {7, 44},
        selectionRange = {7, 7},
        valueRange = {11, 44},
        children = {
            [1] = {
                name = 'a',
                detail = 'field {b}',
                kind = define.SymbolKind.Property,
                range = {17, 42},
                selectionRange = {17, 17},
                valueRange = {21, 42},
                children = {
                    [1] = {
                        name = 'b',
                        detail = EXISTS,
                        kind = define.SymbolKind.Property,
                        range = {31, 35},
                        selectionRange = {31, 31},
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
        detail = 'function ()',
        kind = define.SymbolKind.Function,
        range = {1, 22},
        selectionRange = {16, 16},
        valueRange = {1, 22},
    },
    [2] = {
        name = 'g',
        detail = 'setlocal number = 1',
        kind = define.SymbolKind.Variable,
        range = {25, 29},
        selectionRange = {25, 25},
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
        detail = 'function (a, b, ...)',
        kind = define.SymbolKind.Function,
        range = {1, 58},
        selectionRange = {10, 10},
        valueRange = {1, 58},
        children = {
            [1] = {
                name = 'a',
                detail = 'param',
                kind = define.SymbolKind.Constant,
                range = {12, 12},
                selectionRange = {12, 12},
            },
            [2] = {
                name = 'b',
                detail = 'param',
                kind = define.SymbolKind.Constant,
                range = {15, 15},
                selectionRange = {15, 15},
            },
            [3] = {
                name = 'x',
                detail = 'local',
                kind = define.SymbolKind.Variable,
                range = {33, 39},
                selectionRange = {33, 33},
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
        detail = 'local {a, b}',
        kind = define.SymbolKind.Variable,
        range = {7, 35},
        selectionRange = {7, 7},
        valueRange = {11, 35},
        children = EXISTS,
    },
    [2] = {
        name = 'v',
        detail = 'local',
        kind = define.SymbolKind.Variable,
        range = {44, 48},
        selectionRange = {44, 44},
    },
}

TEST [[
local x
local function
]]{
    [1] = {
        name = 'x',
        detail = 'local',
        kind = define.SymbolKind.Variable,
        range = {7, 7},
        selectionRange = {7, 7},
    },
}

TEST [[
local a, b = {
    x = 1,
    y = 1,
    z = 1,
}, {
    x = 1,
    y = 1,
    z = 1,
}

]]{
    [1] = {
        name = 'a',
        detail = 'local {x, y, z}',
        kind = define.SymbolKind.Variable,
        range = {7, 49},
        selectionRange = {7, 7},
        valueRange = {14, 49},
        children = EXISTS,
    },
    [2] = {
        name = 'b',
        detail = 'local {x, y, z}',
        kind = define.SymbolKind.Variable,
        range = {10, 87},
        selectionRange = {10, 10},
        valueRange = {52, 87},
        children = EXISTS,
    }
}

TEST [[
local function x()
end

local function f()
    local c
end
]]
{
    [1] = {
        name = 'x',
        detail = 'function ()',
        kind = define.SymbolKind.Function,
        range = {1, 22},
        selectionRange = {16, 16},
        valueRange = {1, 22},
    },
    [2] = {
        name = 'f',
        detail = 'function ()',
        kind = define.SymbolKind.Function,
        range = {25, 58},
        selectionRange = {40, 40},
        valueRange = {25, 58},
        children = {
            [1] = {
                name = 'c',
                detail = 'local',
                kind = define.SymbolKind.Variable,
                range = {54, 54},
                selectionRange = {54, 54},
            },
        },
    }
}

TEST [[
local t = f({
    k = 1
})
]]
{
    [1] = {
        name = 't',
        detail = 'local',
        kind = define.SymbolKind.Variable,
        range = {7, 26},
        selectionRange = {7, 7},
        valueRange = {11, 26},
        children = {
            [1] = {
                name = 'k',
                detail = 'field number = 1',
                kind = define.SymbolKind.Property,
                range = {19, 23},
                selectionRange = {19, 19},
            }
        }
    }
}

TEST [[
local t = {}

local function f(a, b)
end
]]
{
    [1] = {
        name = 't',
        detail = 'local {}',
        kind = define.SymbolKind.Variable,
        range = {7, 12},
        selectionRange = {7, 7},
        valueRange = {11, 12},
    },
    [2] = {
        name = 'f',
        detail = 'function (a, b)',
        kind = define.SymbolKind.Function,
        range = {15, 40},
        selectionRange = {30, 30},
        valueRange = {15, 40},
        children = {
            [1] = {
                name = 'a',
                detail = 'param',
                kind = define.SymbolKind.Constant,
                range = {32, 32},
                selectionRange = {32, 32},
            },
            [2] = {
                name = 'b',
                detail = 'param',
                kind = define.SymbolKind.Constant,
                range = {35, 35},
                selectionRange = {35, 35},
            }
        }
    }
}

TEST [[
local a = f {
    x = function ()
    end
}
]]
{
    [1] = {
        name = 'a',
        detail = 'local',
        kind = define.SymbolKind.Variable,
        range = {7, 43},
        selectionRange = {7, 7},
        valueRange = {11, 43},
        children = {
            [1] = {
                name = 'x',
                detail = 'function ()',
                kind = define.SymbolKind.Function,
                range = {19, 41},
                selectionRange = {19, 19},
                valueRange = {23, 41},
            }
        }
    }
}

TEST [[
table.sort(t, function (a, b)
    return false
end)
]]
{
    [1] = {
        name = '',
        detail = 'table.sort -> function (a, b)',
        kind = define.SymbolKind.Function,
        range = {15, 50},
        selectionRange = {15, 15},
        valueRange = {15, 50},
        children = EXISTS,
    }
}
