local files  = require 'files'
local furi   = require 'file-uri'
local core   = require 'core.hover'
local config = require 'config'
local catch  = require 'catch'

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

---@diagnostic disable: await-in-sync
function TEST(expect)
    files.removeAll()

    local targetScript, targetList = catch(expect[1].content, '?')
    local targetUri = furi.encode(expect[1].path)

    local sourceScript, sourceList = catch(expect[2].content, '?')
    local sourceUri = furi.encode(expect[2].path)

    files.setText(targetUri, targetScript)
    files.setText(sourceUri, sourceScript)

    if targetList['?'] then
        local targetPos = (targetList['?'][1][1] + targetList['?'][1][2]) // 2
        core.byUri(targetUri, targetPos)
    end
    local sourcePos = (sourceList['?'][1][1] + sourceList['?'][1][2]) // 2
    local hover = core.byUri(sourceUri, sourcePos)
    assert(hover)
    hover = tostring(hover):gsub('\r\n', '\n')
    assert(eq(hover, expect.hover))
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
    hover = [[
```lua
1 个字节
```

---
* [a.lua](file:///a.lua) （搜索路径： `?.lua`）]],
}

TEST {
    {
        path = 'a.lua',
        content = '',
    },
    {
        path = 'b.lua',
        content = '---@module "<?a?>"',
    },
    hover = [[
* [a.lua](file:///a.lua) （搜索路径： `?.lua`）]],
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
    hover = [[
```lua
1 个字节
```

---
* [Folder\a.lua](file:///Folder/a.lua) （搜索路径： `Folder\?.lua`）]],
}

TEST {
    {
        path = 'Folder/a.lua',
        content = '',
    },
    {
        path = 'b.lua',
        content = 'require <?"Folder.a"?>',
    },
    hover = [[
```lua
8 个字节
```

---
* [Folder\a.lua](file:///Folder/a.lua) （搜索路径： `?.lua`）]],
}

TEST {
    {
        path = 'Folder/a.lua',
        content = '',
    },
    {
        path = 'b.lua',
        content = 'require <?"Folder/a"?>',
    },
    hover = [[
```lua
8 个字节
```

---
* [Folder\a.lua](file:///Folder/a.lua) （搜索路径： `?.lua`）]],
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
    hover = [[
```lua
1 个字节
```

---
* [Folder/a.lua](file:///Folder/a.lua) （搜索路径： `Folder/?.lua`）]],
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
    hover = [[
```lua
function f(a: any, b: any)
```]]
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
    hover = [[
```lua
function (a: any, b: any)
```]]
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
    hover = [[
```lua
method mt:add(a: any, b: any)
```]]
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
    hover = [[
```lua
global t: {
    [1]: integer = 1|2,
}
```]],
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
    hover = [[
```lua
global t: {
    [1]: integer = 2,
}
```]],
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
    hover = [[
```lua
local t: {
    a: integer = 1,
    b: integer = 2,
}
```]],
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
    hover = [[
```lua
function f(x: number)
```

---
 abc]]
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
    hover = [[
```lua
global x: integer = 1
```

---
 abc]]
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
    hover = [[
```lua
function f(x: string|'选项1'|'选项2')
```

---

```lua
x: string
    | '选项1' -- 注释1
   -> '选项2' -- 注释2
```]]
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
    hover = [[
```lua
function f(x: '选项1'|'选项2')
```

---

```lua
x: option
    | '选项1' -- 注释1
   -> '选项2' -- 注释2
```]]
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
    hover = [[
```lua
function f()
  -> x: '选项1'|'选项2'
```

---

```lua
x: option
    | '选项1' -- 注释1
   -> '选项2' -- 注释2
```]]
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
    hover = [[
```lua
function f()
  -> '选项1'|'选项2'
```

---

```lua
return #1: option
    | '选项1' -- 注释1
   -> '选项2' -- 注释2
```]]
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
    hover = [[
```lua
local x: string
```

---
this is comment]]
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
    hover = [[
```lua
function f(x: string, y: table)
  -> name: boolean
  2. number
```

---

@*param* `x` — this is comment

@*param* `y` —  comment 1

@*return* `name` — comment 2

@*return* — comment 3]]
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
hover = [[
```lua
local x: string
```]]}


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
hover = [[
```lua
function f(arg1: integer, arg2: integer)
  -> boolean
```

---
comment1

@*param* `arg2` — comment2

comment3]]}


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
hover = [[
```lua
function f(arg1: integer, arg2: integer)
  -> boolean
```

---

@*param* `arg3` — comment3

---

@*param* `arg1` — comment1

@*param* `arg2` — comment2

---

```lua
function f(arg3: any)
```]]}


TEST {{ path = 'a.lua', content = '', }, {
    path = 'b.lua',
    content = [[
            ---@return boolean, string #comment
            function <?f?>() end
    ]]
},
hover = [[
```lua
function f()
  -> boolean
  2. string
```

---

@*return* — comment]]}

TEST {{ path = 'a.lua', content = '', }, {
    path = 'b.lua',
    content = [[
        ---@return boolean
        ---@return string #comment
        function <?f?>() end
    ]]
},
hover = [[
```lua
function f()
  -> boolean
  2. string
```

---

@*return*

@*return* — comment]]}

TEST {{ path = 'a.lua', content = '', }, {
    path = 'b.lua',
    content = [[
        ---@return boolean
        ---@return string
        function <?f?>() end
    ]]
},
hover = [[
```lua
function f()
  -> boolean
  2. string
```]]}

TEST {{ path = 'a.lua', content = '', }, {
    path = 'b.lua',
    content = [[
        ---comment1
        ---comment2
        function <?f?>() end
    ]]
},
hover = [[
```lua
function f()
```

---
comment1
comment2]]}

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
hover = [[
```lua
function f(a: boolean|true|false)
```

---

@*param* `a` —  xxx

```lua
a: boolean
    | true -- ttt
    | false -- fff
```]]}

TEST {{ path = 'a.lua', content = '', }, {
    path = 'b.lua',
    content = [[
---AAA
---@class A

---@type A
local <?x?>
    ]]
},
hover = [[
```lua
local x: A
```

---
AAA]]}

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
hover = [[
```lua
local x: A {
    n: string,
}
```

---
AAA]]}

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
hover = [[
```lua
local x: A
```

---
BBB

---
AAA]]}

TEST {{ path = 'a.lua', content = '', }, {
    path = 'b.lua',
    content = [[
---AAA
G.<?A?> = 1

---BBB
G.A = 1
    ]]
},
hover = [[
```lua
global G.A: integer = 1
```

---
AAA

---
BBB]]}

TEST {{ path = 'a.lua', content = '', }, {
    path = 'b.lua',
    content = [[
---AAA
G.A = 1

---BBB
G.<?A?> = 1
    ]]
},
hover = [[
```lua
global G.A: integer = 1
```

---
BBB

---
AAA]]}

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
hover = [[
```lua
field Food.firstField: number = 0
```]]}

TEST {{ path = 'a.lua', content = '', }, {
    path = 'b.lua',
    content = [[
--[=[
I'm a multiline comment
]=]
local <?food?>
]]
},
hover = [[
```lua
local food: any
```

---
I'm a multiline comment
]]}

TEST {{ path = 'a.lua', content = '', }, {
    path = 'b.lua',
    content = [[
---@return string # 'this is a tab `\t`'
local function <?f?>() end
]]
},
hover = [[
```lua
function f()
  -> string
```

---

@*return* — this is a tab `	`]]}

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
    hover = [[
```lua
local k: string
```]]
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
    hover = [[
```lua
local k: string
```]]
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
hover = [[
```lua
function bthci.rawhci(hcibytes: any, callback: any)
```

---
 Sends a raw HCI command to the BlueTooth controller.]]}

TEST {{ path = 'a.lua', content = '', }, {
    path = 'b.lua',
    content = [[
---@type string | fun(): string
local <?t?>
]]
},
hover = [[
```lua
local t: string|fun():string
```

---

```lua
function t()
  -> string
```]]}

TEST {{ path = 'a.lua', content = '', }, {
    path = 'b.lua',
    content = [[
---@alias T
---comment 1
---comment 2
---| 'a'
---comment 3
---comment 4
---| 'b'

---@param p T
local function <?f?>(p)
end
]]
},
hover = [[
```lua
function f(p: a|b)
```

---

```lua
p: T
    | a -- comment 1
        -- comment 2
    | b -- comment 3
        -- comment 4
```]]}

TEST {{ path = 'a.lua', content = '', }, {
    path = 'b.lua',
    content = [[
---@param x number # aaa
local f

function f(<?x?>) end
]]
},
hover = [[
```lua
local x: number
```

---
 aaa]]}

TEST {{ path = 'a.lua', content = '', }, {
    path = 'b.lua',
    content = [[
---line1
---
---line2
local function <?fn?>() end
]]
},
hover = [[
```lua
function fn()
```

---
line1

line2]]}

TEST {
    {
        path = 'a.lua',
        content = [[
---@type string[]
local ss

for _, s in ipairs(ss) do
    print(<?s?>)
end
]],
    },
    {
        path = 'b.lua',
        content = [[



for _, x in ipairs({} and {}) do
    print(<?x?>) -- `x` is infered as `string`
end
]],
    },
    hover = [[
```lua
local x: any
```]]
}

TEST {
    {
        path = 'a.lua',
        content = [[
---@class A
---@field x number
G = {}
]],
    },
    {
        path = 'b.lua',
        content = [[
<?G?>
]],
    },
    hover = [[
```lua
global G: A {
    x: number,
}
```]]
}
