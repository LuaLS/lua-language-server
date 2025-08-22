local files   = require 'files'
local furi    = require 'file-uri'
local core    = require 'core.hover'
local catch   = require 'catch'
local compare = require 'compare'

rawset(_G, 'TEST', true)

---@diagnostic disable: await-in-sync
local function TEST(expect)
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

    local hover = core.byUri(sourceUri, sourcePos, 1)
    assert(hover)
    local content = tostring(hover):gsub('\r\n', '\n')
    assert(compare.eq(content, expect.hover))
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

if require 'bee.platform'.os == 'windows' then
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
        content = '---@meta _',
    },
    {
        path = 'b.lua',
        content = 'require <?"a"?>',
    },
    hover = [[
```lua
1 个字节
```]],
}

TEST {
    {
        path = 'a.lua',
        content = '---@meta xxx',
    },
    {
        path = 'b.lua',
        content = 'require <?"a"?>',
    },
    hover = [[
```lua
1 个字节
```]],
}

TEST {
    {
        path = 'a.lua',
        content = '---@meta xxx',
    },
    {
        path = 'b.lua',
        content = 'require <?"xxx"?>',
    },
    hover = [=[
```lua
3 个字节
```

---

* [[meta]](file:///a.lua)]=],
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
(method) mt:add(a: any, b: any)
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
(global) t: {
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
(global) t: {
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
(global) x: integer = 1
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
            ---|   "选项1" # 注释1
            ---| > "选项2" # 注释2
            function <?f?>(x) end
        ]]
    },
    hover = [[
```lua
function f(x: string|"选项1"|"选项2")
```

---

#### x:
  - `"选项1"` — 注释1
  - `"选项2"` (default) — 注释2]]
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
            ---|   "选项1" # 注释1
            ---| > "选项2" # 注释2
            ---@param x option
            function <?f?>(x) end
        ]]
    },
    hover = [[
```lua
function f(x: "选项1"|"选项2")
```

---

#### x:
  - `"选项1"` — 注释1
  - `"选项2"` (default) — 注释2]]
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
            ---|   "选项1" # 注释1
            ---| > "选项2" # 注释2
            ---@return option x
            function <?f?>() end
        ]]
    },
    hover = [[
```lua
function f()
  -> x: "选项1"|"选项2"
```

---

#### x:
  - `"选项1"` — 注释1
  - `"选项2"` (default) — 注释2]]
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
            ---|   "选项1" # 注释1
            ---| > "选项2" # 注释2
            ---@return option
            function <?f?>() end
        ]]
    },
    hover = [[
```lua
function f()
  -> "选项1"|"选项2"
```

---

#### return #1:
  - `"选项1"` — 注释1
  - `"选项2"` (default) — 注释2]]
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
(parameter) x: string
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

@*param* `y` — comment 1

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
(parameter) x: string
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
        ---| true  # ttt
        ---| false # fff
        local function <?f?>(a)
        end
    ]]
},
hover = [[
```lua
function f(a: boolean)
```

---

@*param* `a` — xxx

#### a:
  - `true` — ttt
  - `false` — fff]]}

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
(global) G.A: integer = 1
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
(global) G.A: integer = 1
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
(field) Food.firstField: number
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
local food: unknown
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
function f(p: 'a'|'b')
```

---

#### p:
  - `'a'` — comment 1
             comment 2
  - `'b'` — comment 3
             comment 4]]}

--TEST {{ path = 'a.lua', content = '', }, {
--    path = 'b.lua',
--    content = [[
-----@param x number # aaa
--local f
--
--function f(<?x?>) end
--]]
--},
--hover = [[
--```lua
--local x: number
--```
--
-----
-- aaa]]}

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
    print(<?x?>) -- `x` is infered as `string` (fixed bug)
end
]],
    },
    hover = [[
```lua
local x: unknown
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
(global) G: A {
    x: number,
}
```]]
}

TEST {
    {
        path = 'a.lua',
        content = [[
            ---@overload fun(self, a)
            function C:<?f?>(a, b) end
        ]]
    },
    hover = [[
```lua
(method) C:f(a: any, b: any)
```

---

```lua
(method) C:f(a: any)
```]]
}

TEST {
    {
        path = 'a.lua',
        content = [[
            ---@overload fun(self, a)
            function C.<?f?>(a, b) end
        ]]
    },
    hover = [[
```lua
function C.f(a: any, b: any)
```

---

```lua
function C.f(self: any, a: any)
```]]
}

TEST {
    {
        path = 'a.lua',
        content = [[
            ---@async
            ---@overload async fun(self, a)
            function C:<?f?>(a, b) end
        ]]
    },
    hover = [[
```lua
(async) (method) C:f(a: any, b: any)
```

---

```lua
(async) (method) C:f(a: any)
```]]
}

TEST {
    {
        path = 'a.lua',
        content = [[
            ---@class Apple
            ---The color of your awesome apple!
            ---@field color string
            local Apple = {}

            Apple.<?color?>
        ]]
    },
    hover = [[
```lua
(field) Apple.color: string
```

---

The color of your awesome apple!]]
}

TEST {
    {
        path = 'a.lua',
        content = [[
            ---@type fun(x: number, y: number, ...: number):(x: number, y: number, ...: number)
            local <?f?>
        ]]
    },
    hover = [[
```lua
local f: fun(x: number, y: number, ...number):(x: number, y: number, ...number)
```

---

```lua
function f(x: number, y: number, ...: number)
  -> x: number
  2. y: number
  3. ...number
```]]
}

TEST {
    {
        path = 'a.lua',
        content = [[
            ---@param p   'a1' | 'a2'
            ---@param ... 'a3' | 'a4'
            ---@return 'r1' | 'r2' ret1
            ---@return 'r3' | 'r4' ...
            local function <?f?>(p, ...) end
        ]]
    },
    hover = [[
```lua
function f(p: 'a1'|'a2', ...'a3'|'a4')
  -> ret1: 'r1'|'r2'
  2. ...'r3'|'r4'
```

---

#### p:
  - `'a1'`
  - `'a2'`

#### ...(param):
  - `'a3'`
  - `'a4'`

#### ret1:
  - `'r1'`
  - `'r2'`

#### ...(return):
  - `'r3'`
  - `'r4'`]]
}

TEST {
    {
        path = 'a.lua',
        content = [[
            ---@type integer @ comments
            local <?n?>
        ]]
    },
    hover = [[
```lua
local n: integer
```

---

comments]]
}

TEST {
    {
        path = 'a.lua',
        content = [[
            --- comments
            ---@type integer
            local <?n?>
        ]]
    },
    hover = [[
```lua
local n: integer
```

---

 comments]]
}

TEST {
    {
        path = 'a.lua',
        content = [[
            ---@type integer
            --- comments
            local <?n?>
        ]]
    },
    hover = [[
```lua
local n: integer
```

---

 comments]]
}

TEST {
    {
        path = 'a.lua',
        content = [[
            ---@TODO XXXX
            ---@type integer @ comments
            local <?n?>
        ]]
    },
    hover = [[
```lua
local n: integer
```

---

comments]]
}

TEST {
    {
        path = 'a.lua',
        content = [[
            ---@type integer @ comments
            ---@TODO XXXX
            local <?n?>
        ]]
    },
    hover = [[
```lua
local n: integer
```

---

comments]]
}

TEST {
    {
        path = 'a.lua',
        content = [[
            --[here](x.lua)
            local <?n?>
        ]]
    },
    hover = [[
```lua
local n: unknown
```

---

[here](file:///x.lua)]]
}

TEST {
    {
        path = 'a.lua',
        content = [[
            --[here](D:/x.lua)
            local <?n?>
        ]]
    },
    hover = [[
```lua
local n: unknown
```

---

[here](file:///d%3A/x.lua)]]
}

TEST {
    {
        path = 'a.lua',
        content = [[
            --[here](command:xxxxx)
            local <?n?>
        ]]
    },
    hover = [[
```lua
local n: unknown
```

---

[here](command:xxxxx)]]
}

TEST {
    {
        path = 'a.lua',
        content = [[
            ---@class A
            ---@field x number # comments

            ---@type A
            local t

            print(t.<?x?>)
        ]]
    },
    hover = [[
```lua
(field) A.x: number
```

---

comments]]
}

TEST {
    {
        path = 'a.lua',
        content = [[
            -- comments
            <?A?> = function () end
        ]]
    },
    hover = [[
```lua
function A()
```

---

 comments]]
}

TEST {
    {
        path = 'a.lua',
        content = [[
            local t = {
                -- comments
                <?A?> = function () end
            }
        ]]
    },
    hover = [[
```lua
function A()
```

---

 comments]]
}

TEST {
    {
        path = 'a.lua',
        content = [[
            -- comments
            ---@return number
            <?A?> = function () end
        ]]
    },
    hover = [[
```lua
function A()
  -> number
```

---

 comments]]
}

TEST {
    {
        path = 'a.lua',
        content = [[
            ---@alias A
            ---| 1 # comment1
            ---| 2 # comment2

            ---@type A
            local <?x?>
        ]]
    },
    hover = [[
```lua
local x: 1|2
```

---

#### A:
  - `1` — comment1
  - `2` — comment2]]
}

TEST {
    {
        path = 'a.lua',
        content = [[
            ---@enum <?A?>
            local t = {
                x = 1,
                y = 2,
                z = 3,
            }
        ]]
    },
    hover = [[
```lua
(enum) A
```

---

```lua
{
    x: integer = 1,
    y: integer = 2,
    z: integer = 3,
}
```]]
}

TEST {
    {
        path = 'a.lua',
        content = [[
            ---@enum <?A?>
            local t =
            {
                x = 1,
                y = 2,
                z = 3,
            }
        ]]
    },
    hover = [[
```lua
(enum) A
```

---

```lua
{
    x: integer = 1,
    y: integer = 2,
    z: integer = 3,
}
```]]
}

TEST {
    {
        path = 'a.lua',
        content = [[
            ---@enum <?A?>
            local t = {
                x = 1 << 0,
                y = 1 << 1,
                z = 1 << 2,
            }
        ]]
    },
    hover = [[
```lua
(enum) A
```

---

```lua
{
    x: integer = 1,
    y: integer = 2,
    z: integer = 4,
}
```]]
}

TEST {
    {
        path = 'a.lua',
        content = [[
            ---@enum(key) <?A?>
            local t = {
                x = 1 << 0,
                y = 1 << 1,
                z = 1 << 2,
            }
        ]]
    },
    hover = [[
```lua
(enum) A
```

---

```lua
"x" | "y" | "z"
```]]
}

TEST {
    {
        path = 'a.lua',
        content = [[
            ---@alias someType
            ---| "#" # description

            ---@type someType
            local <?someValue?>
        ]]
    },
    hover = [[
```lua
local someValue: "#"
```

---

#### someType:
  - `"#"` — description]]
}

TEST { { path = 'a.lua', content = [[
---@overload fun(x: number)
---@overload fun(x: number, y: number)
local function <?f?>(...)
end
]] },
hover = [[
```lua
function f(x: number)
```

---

```lua
function f(x: number, y: number)
```]]
}

TEST { { path = 'a.lua', content = [[
---@overload fun(x: number)
---@overload fun(x: number, y: number)
local function f(...)
end

<?f?>
]] },
hover = [[
```lua
function f(x: number)
```

---

```lua
function f(x: number, y: number)
```]]
}

TEST { { path = 'a.lua', content = [[
---@overload fun(self: self, x: number)
---@overload fun(self: self, x: number, y: number)
function M:f(...)
end

M:<?f?>
]] },
hover = [[
```lua
(method) M:f(x: number)
```

---

```lua
(method) M:f(x: number, y: number)
```]]
}

TEST { {path = 'a.lua', content = [[
---@class A

---@see A # comment1
local <?x?>
]]},
hover = [[
```lua
local x: unknown
```

---

See: [A](file:///a.lua#1#10) comment1]]
}

TEST { {path = 'a.lua', content = [[
---@class A

TTT = 1

---@see A # comment1
---@see TTT # comment2
local <?x?>
]]},
hover = [[
```lua
local x: unknown
```

---

See:
  * [A](file:///a.lua#1#10) comment1
  * [TTT](file:///a.lua#3#0) comment2]]
}

TEST { {path = 'a.lua', content = [[
---comment1
---comment2
---@overload fun()
---@param x number
local function <?f?>(x) end
]]},
hover = [[
```lua
function f(x: number)
```

---

comment1
comment2

---

```lua
function f()
```]]
}

TEST { {path = 'a.lua', content = [[
---"hello world" this is ok
---@param bar any "lorem ipsum" this is ignored
---@param baz any # "dolor sit" this is ignored
local function <?foo?>(bar, baz)
end
]]},
hover = [[
```lua
function foo(bar: any, baz: any)
```

---

"hello world" this is ok

@*param* `bar` — "lorem ipsum" this is ignored

@*param* `baz` — "dolor sit" this is ignored]]
}

TEST { {path = 'a.lua', content = [[
--comment1
local x

--comment2
x = 1

print(<?x?>)
]]},
hover = [[
```lua
local x: integer = 1
```

---

comment1]]
}

TEST { {path = 'a.lua', content = [[
local t = {}

print(<?t?>['a b'])
]]},
hover = [[
```lua
local t: {
    ['a b']: unknown,
}
```]]
}
