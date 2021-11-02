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

---@diagnostic disable: await-in-sync
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
        range = {0, 5},
        selectionRange = {0, 1},
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
        range = {6, 10003},
        selectionRange = {15, 16},
        valueRange = {6, 10003},
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
        range = {0, 10003},
        selectionRange = {9, 10},
        valueRange = {0, 10003},
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
        range = {7, 10003},
        selectionRange = {7, 15},
        valueRange = {7, 10003},
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
        range = {0, 10003},
        selectionRange = {0, 1},
        valueRange = {4, 10003},
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
        range = {6, 10003},
        selectionRange = {6, 7},
        valueRange = {10, 10003},
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
        range = {0, 10003},
        selectionRange = {9, 15},
        valueRange = {0, 10003},
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
        range = {0, 50003},
        selectionRange = {9, 10},
        valueRange = {0, 50003},
        children = {
            [1] = {
                name = 'A1',
                detail = 'function ()',
                kind = define.SymbolKind.Function,
                range = {10004, 20007},
                selectionRange = {10013, 10015},
                valueRange = {10004, 20007},
            },
            [2] = {
                name = 'A2',
                detail = 'function ()',
                kind = define.SymbolKind.Function,
                range = {30004, 40007},
                selectionRange = {30013, 30015},
                valueRange = {30004, 40007},
            },
        },
    },
    [2] = {
        name = 'B',
        detail = 'function ()',
        kind = define.SymbolKind.Function,
        range = {60000, 70003},
        selectionRange = {60009, 60010},
        valueRange = {60000, 70003},
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
        range = {6, 11},
        selectionRange = {6, 7},
    },
    [2] = {
        name = 'f',
        detail = 'function ()',
        kind = define.SymbolKind.Function,
        range = {10006, 50003},
        selectionRange = {10015, 10016},
        valueRange = {10006, 50003},
        children = {
            [1] = {
                name = 'x',
                detail = 'local string = "x"',
                kind = define.SymbolKind.Variable,
                range = {20010, 20017},
                selectionRange = {20010, 20011},
            },
            [2] = {
                name = 'y',
                detail = 'local {}',
                kind = define.SymbolKind.Variable,
                range = {30010, 30016},
                selectionRange = {30010, 30011},
                valueRange = {30014, 30016},
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
        range = {60006, 60014},
        selectionRange = {60006, 60007},
    },
    [4] = {
        name = 'z',
        detail = 'local',
        kind = define.SymbolKind.Variable,
        range = {70006, 70007},
        selectionRange = {70006, 70007},
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
        range = {6, 40001},
        selectionRange = {6, 7},
        valueRange = {10, 40001},
        children = {
            [1] = {
                name = 'a',
                detail = 'field number = 1',
                kind = define.SymbolKind.Property,
                range = {10004, 10009},
                selectionRange = {10004, 10005},
            },
            [2] = {
                name = 'b',
                detail = 'field number = 2',
                kind = define.SymbolKind.Property,
                range = {20004, 20009},
                selectionRange = {20004, 20005},
            },
            [3] = {
                name = 'c',
                detail = 'field number = 3',
                kind = define.SymbolKind.Property,
                range = {30004, 30009},
                selectionRange = {30004, 30005},
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
        range = {6, 40001},
        selectionRange = {6, 7},
        valueRange = {10, 40001},
        children = {
            [1] = {
                name = 'a',
                detail = 'field {b}',
                kind = define.SymbolKind.Property,
                range = {10004, 30005},
                selectionRange = {10004, 10005},
                valueRange = {10008, 30005},
                children = {
                    [1] = {
                        name = 'b',
                        detail = EXISTS,
                        kind = define.SymbolKind.Property,
                        range = {20008, 20013},
                        selectionRange = {20008, 20009},
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
        range = {6, 10003},
        selectionRange = {15, 16},
        valueRange = {6, 10003},
    },
    [2] = {
        name = 'g',
        detail = 'setlocal number = 1',
        kind = define.SymbolKind.Variable,
        range = {30000, 30005},
        selectionRange = {30000, 30001},
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
        range = {0, 30003},
        selectionRange = {9, 10},
        valueRange = {0, 30003},
        children = {
            [1] = {
                name = 'a',
                detail = 'param',
                kind = define.SymbolKind.Constant,
                range = {11, 12},
                selectionRange = {11, 12},
            },
            [2] = {
                name = 'b',
                detail = 'param',
                kind = define.SymbolKind.Constant,
                range = {14, 15},
                selectionRange = {14, 15},
            },
            [3] = {
                name = 'x',
                detail = 'local',
                kind = define.SymbolKind.Variable,
                range = {10010, 10017},
                selectionRange = {10010, 10011},
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
        range = {6, 30001},
        selectionRange = {6, 7},
        valueRange = {10, 30001},
        children = EXISTS,
    },
    [2] = {
        name = 'v',
        detail = 'local',
        kind = define.SymbolKind.Variable,
        range = {50006, 50011},
        selectionRange = {50006, 50007},
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
        range = {6, 7},
        selectionRange = {6, 7},
    },
    [2] = {
        name = "",
        detail = "function ()",
        kind = 12,
        range = {10006, 10014},
        selectionRange = {10006, 10014},
        valueRange = {10006, 10014},
    },
}

TEST [[
local a, b = {
    x1 = 1,
    y1 = 1,
    z1 = 1,
}, {
    x2 = 1,
    y2= 1,
    z2 = 1,
}

]]{
    [1] = {
        name = 'a',
        detail = 'local {x1, y1, z1}',
        kind = define.SymbolKind.Variable,
        range = {6, 40001},
        selectionRange = {6, 7},
        valueRange = {13, 40001},
        children = EXISTS,
    },
    [2] = {
        name = 'b',
        detail = 'local {x2, y2, z2}',
        kind = define.SymbolKind.Variable,
        range = {9, 80001},
        selectionRange = {9, 10},
        valueRange = {40003, 80001},
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
        range = {6, 10003},
        selectionRange = {15, 16},
        valueRange = {6, 10003},
    },
    [2] = {
        name = 'f',
        detail = 'function ()',
        kind = define.SymbolKind.Function,
        range = {30006, 50003},
        selectionRange = {30015, 30016},
        valueRange = {30006, 50003},
        children = {
            [1] = {
                name = 'c',
                detail = 'local',
                kind = define.SymbolKind.Variable,
                range = {40010, 40011},
                selectionRange = {40010, 40011},
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
        range = {6, 20002},
        selectionRange = {6, 7},
        valueRange = {10, 20002},
        children = {
            [1] = {
                name = 'k',
                detail = 'field number = 1',
                kind = define.SymbolKind.Property,
                range = {10004, 10009},
                selectionRange = {10004, 10005},
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
        range = {6, 12},
        selectionRange = {6, 7},
        valueRange = {10, 12},
    },
    [2] = {
        name = 'f',
        detail = 'function (a, b)',
        kind = define.SymbolKind.Function,
        range = {20006, 30003},
        selectionRange = {20015, 20016},
        valueRange = {20006, 30003},
        children = {
            [1] = {
                name = 'a',
                detail = 'param',
                kind = define.SymbolKind.Constant,
                range = {20017, 20018},
                selectionRange = {20017, 20018},
            },
            [2] = {
                name = 'b',
                detail = 'param',
                kind = define.SymbolKind.Constant,
                range = {20020, 20021},
                selectionRange = {20020, 20021},
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
        range = {6, 30001},
        selectionRange = {6, 7},
        valueRange = {10, 30001},
        children = {
            [1] = {
                name = 'x',
                detail = 'function ()',
                kind = define.SymbolKind.Function,
                range = {10004, 20007},
                selectionRange = {10004, 10005},
                valueRange = {10008, 20007},
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
        range = {14, 20003},
        selectionRange = {14, 22},
        valueRange = {14, 20003},
        children = EXISTS,
    }
}

TEST [[
local root = {
    inner_function = function ()
        local function function_inside_function()
        end
    end
}
]]
{
    [1] = {
        name = 'root',
        detail = 'local {inner_function}',
        kind = define.SymbolKind.Variable,
        range = {6, 50001},
        selectionRange = {6, 10},
        valueRange = {13, 50001},
        children = {
            [1] = {
                name = 'inner_function',
                detail = 'function ()',
                kind = define.SymbolKind.Function,
                range = {10004, 40007},
                selectionRange = {10004, 10018},
                valueRange = {10021, 40007},
                children = {
                    [1] = {
                        name = 'function_inside_function',
                        detail = 'function ()',
                        kind = define.SymbolKind.Function,
                        range = {20014, 30011},
                        selectionRange = {20023, 20047},
                        valueRange = {20014, 30011},
                    },
                },
            },
        },
    }
}
