local files  = require 'files'
local furi   = require 'file-uri'
local core   = require 'core.hover'
local config = require 'config'

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
        description = [[* [a.lua](file:///a.lua) （搜索路径： `?.lua`）]],
    }
}

if require 'bee.platform'.OS == 'Windows' then
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
        description = [[* [Folder\a.lua](file:///Folder/a.lua) （搜索路径： `Folder\?.lua`）]],
    }
}
else
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
        description = [[* [Folder/a.lua](file:///Folder/a.lua) （搜索路径： `Folder/?.lua`）]],
    }
}
end

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
                [1] = 1,
            }
        ]],
    },
    {
        path = 'b.lua',
        content = [[
            <?t?>[1] = 2
        ]]
    },
    hover = {
        label = [[
global t: {
    [1]: integer = 1|2,
}]],
        name = 't',
    },
}

TEST {
    {
        path = 'a.lua',
        content = [[
            t = {
                [1] = 1,
            }
        ]],
    },
    {
        path = 'a.lua',
        content = [[
            <?t?>[1] = 2
        ]]
    },
    hover = {
        label = [[
global t: {
    [1]: integer = 2,
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
        description = [[
 abc]],
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
        label = "function f(x: string|'选项1'|'选项2')",
        name = 'f',
        description = [[
```lua
x: string
    | '选项1' -- 注释1
   -> '选项2' -- 注释2
```]]
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
        label = "function f(x: '选项1'|'选项2')",
        name = 'f',
        description = [[
```lua
x: option
    | '选项1' -- 注释1
   -> '选项2' -- 注释2
```]]
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
            ---@return option x
            function <?f?>() end
        ]]
    },
    hover = {
        label = [[
function f()
  -> x: '选项1'|'选项2']],
        name = 'f',
        description = [[
```lua
x: option
    | '选项1' -- 注释1
   -> '选项2' -- 注释2
```]]
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
            ---@return option
            function <?f?>() end
        ]]
    },
    hover = {
        label = [[
function f()
  -> '选项1'|'选项2']],
        name = 'f',
        description = [[
```lua
return #1: option
    | '选项1' -- 注释1
   -> '选项2' -- 注释2
```]]
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
---@param x string this is comment
function f(<?x?>) end
        ]]
    },
    hover = {
        label = 'local x: string',
        name  = 'x',
        description = 'this is comment',
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
---@param x string this is comment
---@param y table -- comment 1
---@return boolean name #comment 2
---@return number @comment 3
function <?f?>(x, y) end
        ]]
    },
    hover = {
        label = [[
function f(x: string, y: table)
  -> name: boolean
  2. number]],
        name  = 'f',
        description = [[
@*param* `x` — this is comment

@*param* `y` —  comment 1

@*return* `name` — comment 2

@*return* — comment 3]],
    }
}

TEST {{ path = 'a.lua', content = '', }, {
    path = 'b.lua',
    content = [[
---Comment
---@param x string
---@return string # this is comment
function f(<?x?>) end
        ]]
},
hover = {
    label = [[local x: string]],
    name  = 'x',
    description = nil,
}}


TEST {{ path = 'a.lua', content = '', }, {
    path = 'b.lua',
    content = [[
            ---comment1
            ---@param arg1 integer
            ---@param arg2 integer comment2
            ---@return boolean
            ---comment3
            function <?f?>(arg1, arg2) end
    ]]
},
hover = {
    label = [[
function f(arg1: integer, arg2: integer)
  -> boolean]],
    name = 'f',
    description = [[
comment1

@*param* `arg2` — comment2

comment3]]
}}


TEST {{ path = 'a.lua', content = '', }, {
    path = 'b.lua',
    content = [[
            ---@param arg3 integer comment3
            ---@overload fun(arg3)
            ---@param arg1 integer comment1
            ---@param arg2 integer comment2
            ---@return boolean
            function <?f?>(arg1, arg2) end
    ]]
},
hover = {
    label = EXISTS,
    name = 'f',
    description = [[
@*param* `arg3` — comment3
---
@*param* `arg1` — comment1

@*param* `arg2` — comment2]]
}}


TEST {{ path = 'a.lua', content = '', }, {
    path = 'b.lua',
    content = [[
            ---@return boolean, string #comment
            function <?f?>() end
    ]]
},
hover = {
    label = [[
function f()
  -> boolean
  2. string]],
    name = 'f',
    description = [[
@*return* — comment]]
}}

TEST {{ path = 'a.lua', content = '', }, {
    path = 'b.lua',
    content = [[
        ---@return boolean
        ---@return string #comment
        function <?f?>() end
    ]]
},
hover = {
    label = [[
function f()
  -> boolean
  2. string]],
    name = 'f',
    description = [[
@*return*

@*return* — comment]]
}}

TEST {{ path = 'a.lua', content = '', }, {
    path = 'b.lua',
    content = [[
        ---@return boolean
        ---@return string
        function <?f?>() end
    ]]
},
hover = {
    label = [[
function f()
  -> boolean
  2. string]],
    name = 'f',
    description = nil
}}

TEST {{ path = 'a.lua', content = '', }, {
    path = 'b.lua',
    content = [[
        ---comment1
        ---comment2
        function <?f?>() end
    ]]
},
hover = {
    label = "function f()",
    name = 'f',
    description =  [[
comment1
comment2]]
}}

TEST {{ path = 'a.lua', content = '', }, {
    path = 'b.lua',
    content = [[
        ---@param a boolean # xxx
        ---| 'true'  # ttt
        ---| 'false' # fff
        local function <?f?>(a)
        end
    ]]
},
hover = {
    label = "function f(a: boolean|true|false)",
    name = 'f',
    description = [[
@*param* `a` —  xxx

```lua
a: boolean
    | true -- ttt
    | false -- fff
```]]
}}

TEST {{ path = 'a.lua', content = '', }, {
    path = 'b.lua',
    content = [[
---AAA
---@class A

---@type A
local <?x?>
    ]]
},
hover = {
    label = 'local x: A',
    name  = 'x',
    description = 'AAA'
}}

TEST {{ path = 'a.lua', content = '', }, {
    path = 'b.lua',
    content = [[
---AAA
---@class A
---BBB
---@field n string
local <?x?>
    ]]
},
hover = {
    label = [[
local x: A {
    n: string,
}]],
    name  = 'x',
    description = 'AAA'
}}

TEST {{ path = 'a.lua', content = '', }, {
    path = 'b.lua',
    content = [[
---AAA
---@class A

---BBB
---@type A
local <?x?>
    ]]
},
hover = {
    label = 'local x: A',
    name  = 'x',
    description = 'BBB'
}}

TEST {{ path = 'a.lua', content = '', }, {
    path = 'b.lua',
    content = [[
---AAA
G.<?A?> = 1

---BBB
G.A = 1
    ]]
},
hover = {
    label = 'global G.A: integer = 1',
    name  = 'G.A',
    description = 'AAA'
}}

TEST {{ path = 'a.lua', content = '', }, {
    path = 'b.lua',
    content = [[
---AAA
G.A = 1

---BBB
G.<?A?> = 1
    ]]
},
hover = {
    label = 'global G.A: integer = 1',
    name  = 'G.A',
    description = 'BBB'
}}

TEST {{ path = 'a.lua', content = '', }, {
    path = 'b.lua',
    content = [[
---I am the class description.
---@class Food
---@field firstField number
---@field secondField number
local food = {}

food.<?firstField?> = 0
food.secondField = 2
]]
},
hover = {
    label = 'field Food.firstField: number = 0',
    name  = 'food.firstField',
}}

TEST {{ path = 'a.lua', content = '', }, {
    path = 'b.lua',
    content = [[
--[=[
I'm a multiline comment
]=]
local <?food?>
]]
},
hover = {
    label = 'local food: any',
    name  = 'food',
    description = "I'm a multiline comment\n"
}}

TEST {{ path = 'a.lua', content = '', }, {
    path = 'b.lua',
    content = [[
---@return string # 'this is a tab `\t`'
local function <?f?>() end
]]
},
hover = {
    label = [[
function f()
  -> string]],
    name  = 'food',
    description = "@*return* — this is a tab `\t`"
}}

TEST {
    {
        path = 'a.lua',
        content = [[
---@class string

---@generic T: table, K, V
---@param t T
---@return fun(table: table<K, V>, index?: K):K, V
---@return T
local function pairs(t) end

return pairs
        ]]
    },
    {
        path = 'b.lua',
        content = [[
local pairs = require 'a'

---@type table<string, boolean>
local t

for <?k?>, v in pairs(t) do
end
    ]]
    },
    hover = {
        label = [[local k: string]],
        name  = 'k',
    }
}

TEST {
    {
        path = 'a.lua',
        content = [[
---@class string

---@generic T: table, K, V
---@param t T
---@return fun(table: table<K, V>, index?: K):K, V
---@return T
function tpairs(t) end
        ]]
    },
    {
        path = 'b.lua',
        content = [[
local pairs = require 'a'

---@type table<string, boolean>
local t

for <?k?>, v in tpairs(t) do
end
    ]]
    },
    hover = {
        label = [[local k: string]],
        name  = 'k',
    }
}

TEST {{ path = 'a.lua', content = '', }, {
    path = 'b.lua',
    content = [[
---@class bthci
bthci = {}

---@class adv
---@field CONN_DIR_HI integer
---@field CHAN_ALL integer
bthci.adv = {}

--- Sends a raw HCI command to the BlueTooth controller.
function bthci.<?rawhci?>(hcibytes, callback) end

--- Resets the BlueTooth controller.
function bthci.reset(callback) end
]]
},
hover = {
    label = 'function bthci.rawhci(hcibytes: any, callback: any)',
    name  = 'bthci.rawhci',
    description = " Sends a raw HCI command to the BlueTooth controller."
}}

TEST {{ path = 'a.lua', content = '', }, {
    path = 'b.lua',
    content = [[
---@type string | fun(): string
local <?t?>
]]
},
hover = {
    label = 'local t: string|fun():string',
    name  = 't',
}}
