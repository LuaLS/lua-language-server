-- luadoc 补全测试
-- TODO: 实现 luadoc 补全 provider 后补充用例

TEST_COMPLETION [[
---@cl<??>
]] {
	{
		label = 'class',
		kind  = ls.spec.CompletionItemKind.Event,
	},
}

TEST_COMPLETION [[
---@class ZABC
---@class ZBBC : Z<??>
]] {
	{
		label = 'ZABC',
		kind  = ls.spec.CompletionItemKind.Class,
	},
}

TEST_COMPLETION [[
---@class ZBBC
---@class ZBBC : Z<??>
]] (nil)

TEST_COMPLETION [[
---@class zabc
local abcd
---@type za<??>
]] {
	{
		label = 'zabc',
		kind  = ls.spec.CompletionItemKind.Class,
	},
}

TEST_COMPLETION [[
---@alias zabc zabb
---@type za<??>
]] {
	{
		label = 'zabc',
		kind  = ls.spec.CompletionItemKind.Class,
	},
}

TEST_COMPLETION [[
---@class ZABC
---@class ZBBC : <??>
]] (function (results)
	local ok
	for _, res in ipairs(results) do
		if res.label == 'ZABC' then
			ok = true
		end
		if res.label == 'ZBBC' then
			error('ZBBC should not be here')
		end
	end
	assert(ok, 'ZABC should be here')
end)

TEST_COMPLETION [[
---@class ZBBC
---@class ZBBC : <??>
]] (function (results)
	for _, res in ipairs(results) do
		if res.label == 'ZBBC' then
			error('ZBBC should not be here')
		end
	end
end)

TEST_COMPLETION [[
---@class ZABC
---@class ZABC
---@class ZBBC : Z<??>
]] {
	{
		label = 'ZABC',
		kind  = ls.spec.CompletionItemKind.Class,
	},
}

TEST_COMPLETION [[
---@class abc
local abcd
---@type <??>
]] (EXISTS)

TEST_COMPLETION [[
---@class zabc
local abcd
---@type zxxx|z<??>
]] {
	{
		label = 'zabc',
		kind  = ls.spec.CompletionItemKind.Class,
	}
}

TEST_COMPLETION [[
---@class ZClass
---@param x ZC<??>
]] {
	{
		label = 'ZClass',
		kind  = ls.spec.CompletionItemKind.Class,
	},
}

TEST_COMPLETION [[
---@param <??>
function f(a, b, c)
end
]] {
	{
		label = 'a, b, c',
		kind = ls.spec.CompletionItemKind.Snippet,
		insertText = [[
a ${1:any}
---@param b ${2:any}
---@param c ${3:any}]]
	},
	{
		label = 'a',
		kind = ls.spec.CompletionItemKind.Interface,
	},
	{
		label = 'b',
		kind = ls.spec.CompletionItemKind.Interface,
	},
	{
		label = 'c',
		kind = ls.spec.CompletionItemKind.Interface,
	},
}

TEST_COMPLETION [[
---@param <??>
function f(a, b, c) end

function f2(a) end
]] {
	{
		label = 'a, b, c',
		kind = ls.spec.CompletionItemKind.Snippet,
		insertText = [[
a ${1:any}
---@param b ${2:any}
---@param c ${3:any}]]
	},
	{
		label = 'a',
		kind = ls.spec.CompletionItemKind.Interface,
	},
	{
		label = 'b',
		kind = ls.spec.CompletionItemKind.Interface,
	},
	{
		label = 'c',
		kind = ls.spec.CompletionItemKind.Interface,
	},
}

TEST_COMPLETION [[
---@param aa<??>
function f(aaa, bbb, ccc)
end
]] {
	{
		label = 'aaa',
		kind = ls.spec.CompletionItemKind.Interface,
	},
}

TEST_COMPLETION [[
local function f()
	---@param <??>
	function f(a, b, c)
	end
end
]] {
	{
		label = 'a, b, c',
		kind = ls.spec.CompletionItemKind.Snippet,
		insertText = [[
a ${1:any}
---@param b ${2:any}
---@param c ${3:any}]]
	},
	{
		label = 'a',
		kind = ls.spec.CompletionItemKind.Interface,
	},
	{
		label = 'b',
		kind = ls.spec.CompletionItemKind.Interface,
	},
	{
		label = 'c',
		kind = ls.spec.CompletionItemKind.Interface,
	},
}

TEST_COMPLETION [[
---@param <??>
function mt:f(a, b, c, ...)
end
]] {
	{
		label = 'a, b, c, ...',
		kind = ls.spec.CompletionItemKind.Snippet,
		insertText = [[
a ${1:any}
---@param b ${2:any}
---@param c ${3:any}
---@param ... ${4:any}]],
	},
	{
		label = 'self',
		kind = ls.spec.CompletionItemKind.Interface,
	},
	{
		label = 'a',
		kind = ls.spec.CompletionItemKind.Interface,
	},
	{
		label = 'b',
		kind = ls.spec.CompletionItemKind.Interface,
	},
	{
		label = 'c',
		kind = ls.spec.CompletionItemKind.Interface,
	},
	{
		label = '...',
		kind = ls.spec.CompletionItemKind.Interface,
	},
}

TEST_COMPLETION [[
---@param aaa <??>
function f(aaa, bbb, ccc)
end
]] (EXISTS)

TEST_COMPLETION [[
---@param xyz Class
---@param xxx Class
function f(x<??>)
]] {
	{
		label = 'xyz, xxx',
		kind = ls.spec.CompletionItemKind.Snippet,
	},
	{
		label = 'xyz',
		kind = ls.spec.CompletionItemKind.Interface,
	},
	{
		label = 'xxx',
		kind = ls.spec.CompletionItemKind.Interface,
	},
}

TEST_COMPLETION [[
---@param xyz Class
---@param xxx Class
function f(<??>
]] {
	{
		label = 'xyz, xxx',
		kind = ls.spec.CompletionItemKind.Snippet,
	},
	{
		label = 'xyz',
		kind = ls.spec.CompletionItemKind.Interface,
	},
	{
		label = 'xxx',
		kind = ls.spec.CompletionItemKind.Interface,
	},
}

TEST_COMPLETION [[
---@param xyz Class
---@param xxx Class
function f(<??>)
]] {
	{
		label = 'xyz, xxx',
		kind = ls.spec.CompletionItemKind.Snippet,
	},
	{
		label = 'xyz',
		kind = ls.spec.CompletionItemKind.Interface,
	},
	{
		label = 'xxx',
		kind = ls.spec.CompletionItemKind.Interface,
	},
}

TEST_COMPLETION [[
local function f()
	---@t<??>
end
]] {
	{
		label = 'type',
		kind = ls.spec.CompletionItemKind.Event,
	},
}

TEST_COMPLETION [[
---@class Class
---@field name string
---@field id integer
local mt = {}
mt.<??>
]] {
	{
		label = 'id',
		kind = ls.spec.CompletionItemKind.Field,
	},
	{
		label = 'name',
		kind = ls.spec.CompletionItemKind.Field,
	},
}

TEST_COMPLETION [[
---@overload fun(a: any, b: any)
local function zzzz(a) end
zzzz<??>
]] {
	{
		label = 'zzzz(a)',
		kind  = ls.spec.CompletionItemKind.Function,
		insertText = 'zzzz',
	},
	{
		label = 'zzzz(a)',
		kind  = ls.spec.CompletionItemKind.Snippet,
		insertText = 'zzzz(${1:a})',
	},
	{
		label = 'zzzz(a, b)',
		kind  = ls.spec.CompletionItemKind.Function,
		insertText = 'zzzz',
	},
	{
		label = 'zzzz(a, b)',
		kind  = ls.spec.CompletionItemKind.Snippet,
		insertText = 'zzzz(${1:a}, ${2:b})',
	},
}

TEST_COMPLETION [[
---@param a any
---@param b? any
---@param c? any
---@vararg any
local function foo(a, b, c, ...) end
foo<??>
]] {
	{
		label = 'foo(a, b, c, ...)',
		kind  = ls.spec.CompletionItemKind.Function,
		insertText = 'foo',
	},
	{
		label = 'foo(a, b, c, ...)',
		kind  = ls.spec.CompletionItemKind.Snippet,
		insertText = 'foo(${1:a}, ${2:b?}, ${3:c?}, ${4:...})',
	},
}

TEST_COMPLETION [[
---@param a? any
---@param b? any
---@param c? any
---@vararg any
local function foo(a, b, c, ...) end
foo<??>
]] {
	{
		label = 'foo(a, b, c, ...)',
		kind  = ls.spec.CompletionItemKind.Function,
		insertText = 'foo',
	},
	{
		label = 'foo(a, b, c, ...)',
		kind  = ls.spec.CompletionItemKind.Snippet,
		insertText = 'foo(${1:a?}, ${2:b?}, ${3:c?}, ${4:...})',
	},
}

TEST_COMPLETION [[
---@param f fun(a: any, b: any)
local function foo(f) end
foo<??>
]] {
	{
		label = 'foo(f)',
		kind  = ls.spec.CompletionItemKind.Function,
		insertText = 'foo',
	},
	{
		label = 'foo(f)',
		kind  = ls.spec.CompletionItemKind.Snippet,
		insertText = 'foo(${1:f})',
	},
}

TEST_COMPLETION [[
--- @diagnostic disable: unused-local
--- @class Test2
--- @field world integer
local Test2 = {}

--- @type Test2
local tdirect
--- @type Test2[]
local tarray

local b = tdirect
local c = tarray[1].<??>
]] (EXISTS)

TEST_COMPLETION [[
---@class C
---@field GGG number
local t = {}

t.GGG = function ()
end

t.GGG<??>
]] {
	{
		label = 'GGG',
		kind  = ls.spec.CompletionItemKind.Field,
	},
	{
		label = 'GGG()',
		kind  = ls.spec.CompletionItemKind.Function,
	},
}

TEST_COMPLETION [[
---@param f fun(a: any, b: any):boolean
local function f(f) end

f(fun<??>)
]] {
	{
		label    = 'fun(a: any, b: any):boolean',
		kind     = ls.spec.CompletionItemKind.Function,
		textEdit = {
			newText = 'function (${1:a}, ${2:b})\n\t$0\nend',
			start   = 30002,
			finish  = 30005,
		}
	},
	{
		label = 'function',
		kind  = ls.spec.CompletionItemKind.Keyword,
	},
	{
		label = 'function ()',
		kind  = ls.spec.CompletionItemKind.Snippet,
	}
}

TEST_COMPLETION [[
---@class cc
---@field aaa number # a1
---@field bbb number # a2

---@param x cc
local function f(x) end

f({
    <??>
})
]] {
	{
		label = 'aaa',
		kind  = ls.spec.CompletionItemKind.Property,
	},
	{
		label = 'bbb',
		kind  = ls.spec.CompletionItemKind.Property,
	},
}

TEST_COMPLETION [[
---@class cc
---@field aaa number # a1
---@field bbb number # a2

---@param x cc
local function f(x) end

f({
    aaa = 1,
    <??>
})
]] {
	{
		label = 'bbb',
		kind  = ls.spec.CompletionItemKind.Property,
	},
}

TEST_COMPLETION [[
---@class cc
---@field aaa number # a1
---@field bbb number # a2

---@param x cc
local function f(x) end

f({aaa = 1,<??>})
]] {
	{
		label = 'bbb',
		kind  = ls.spec.CompletionItemKind.Property,
	},
}

TEST_COMPLETION [[
---@class cc
---@field aaa number # a1
---@field bbb number # a2

---@param x cc
local function f(x) end

f({aaa <??>})
]] (nil)

TEST_COMPLETION [[
---@class cc
---@field iffff number # a1

---@param x cc
local function f(x) end

f({if<??>})
]] {
	include = true,
	{
		label = 'iffff',
		kind  = ls.spec.CompletionItemKind.Property,
	},
}

TEST_COMPLETION [[
---@class cc
---@field aaa number # a1
---@field bbb number # a2

---@param x cc
local function f(x) end

f({
    {
        <??>
    }
})
]] (nil)

TEST_COMPLETION [[
---@return string
local function f() end

local s = f()

s.<??>
]] (EXISTS)

-- [SKIPPED][description] 暂时跳过：字段 description 精确断言
-- TEST_COMPLETION [[
-- ---@class cc
-- ---@field aaa number
-- ---@field bbb number
--
-- ---@type cc
-- local t
-- print(t.aa<??>)
-- ]] {
-- 	{
-- 		label = 'aaa',
-- 		kind  = ls.spec.CompletionItemKind.Field,
-- 		description = [[
-- ```lua
-- (field) cc.aaa: number
-- ```]]
-- 	},
-- }

TEST_COMPLETION [[
---@class AAA

---@class AAA

---@type AAA<??>
]] {
	[1] = {
		label = 'AAA',
		kind  = ls.spec.CompletionItemKind.Class,
	}
}

TEST_COMPLETION [[
---@class AAA

---@class AAA

---@class BBB: AAA<??>
]] {
	[1] = {
		label = 'AAA',
		kind  = ls.spec.CompletionItemKind.Class,
	}
}

TEST_COMPLETION [[
---@class A
---@field zzzz number

---@param x A
local function f(x) end

f({zzz<??>})
]] {
	[1] = {
		label = 'zzzz',
		kind  = ls.spec.CompletionItemKind.Property,
	}
}

TEST_COMPLETION [[
---@class A
---@field zzzz number

---@param y A
local function f(x, y) end

f(1, {<??>})
]] {
	[1] = {
		label = 'zzzz',
		kind  = ls.spec.CompletionItemKind.Property,
	}
}

TEST_COMPLETION [[
---@class class1
class1 = {}

function class1:method1() end

---@class class2 : class1
class2 = {}

class2:<??>
]] {
	[1] = EXISTS,
}

TEST_COMPLETION [[
--- @class Emit
--- @field on fun(self: Emit, eventName: string, cb: function)
--- @field on fun(self: Emit, eventName: '"died"', cb: fun(i: integer))
--- @field on fun(self: Emit, eventName: '"won"', cb: fun(s: string))
local emit = {}

emit:on('<??>')
]] (EXISTS)

TEST_COMPLETION [[
--- @class Emit
--- @field on fun(eventName: string, cb: function)
--- @field on fun(eventName: '"died"', cb: fun(i: integer))
--- @field on fun(eventName: '"won"', cb: fun(s: string))
local emit = {}

emit.on('died', <??>)
]] {
	[1] = {
		label    = 'fun(i: integer)',
		kind     = ls.spec.CompletionItemKind.Function,
	}
}

TEST_COMPLETION [[
--- @class Emit
--- @field on fun(self: Emit, eventName: string, cb: function)
--- @field on fun(self: Emit, eventName: '"died"', cb: fun(i: integer))
--- @field on fun(self: Emit, eventName: '"won"', cb: fun(s: string))
local emit = {}

emit:on('won', <??>)
]] {
	[1] = {
		label    = 'fun(s: string)',
		kind     = ls.spec.CompletionItemKind.Function,
	}
}

TEST_COMPLETION [[
--- @class Emit
--- @field on fun(self: Emit, eventName: string, cb: function)
--- @field on fun(self: Emit, eventName: '"died"', cb: fun(i: integer))
--- @field on fun(self: Emit, eventName: '"won"', cb: fun(s: string))
local emit = {}

emit.on(emit, 'won', <??>)
]] {
	[1] = {
		label    = 'fun(s: string)',
		kind     = ls.spec.CompletionItemKind.Function,
	}
}

TEST_COMPLETION [[
--- @alias event.AAA "AAA"
--- @alias event.BBB "BBB"

--- @class Emit
--- @field on fun(self: Emit, eventName: string, cb: function)
--- @field on fun(self: Emit, eventName: event.AAA, cb: fun(i: integer))
--- @field on fun(self: Emit, eventName: event.BBB, cb: fun(s: string))
local emit = {}

emit:on('AAA', <??>)
]] {
	[1] = {
		label    = 'fun(i: integer)',
		kind     = ls.spec.CompletionItemKind.Function,
	}
}

-- [SKIPPED][overload-alias] method overload + multiline alias 参数枚举当前返回空，暂不迁移

TEST_COMPLETION [[
---@class ZZZZZ.XXXX
---@class ZZZZZ.XXXX
---@class ZZZZZ.XXXX
---@class ZZZZZ.XXXX
---@class ZZZZZ.XXXX

---@type <??>
]] (function (results)
	local count = 0
	for _, res in ipairs(results) do
		if res.label == 'ZZZZZ.XXXX' then
			count = count + 1
		end
	end
	assert(count == 1)
end)

-- [SKIPPED][cast-local] ---@cast 空前缀局部变量补全当前返回空，暂不迁移

-- [SKIPPED][cast-local] ---@cast 前缀局部变量补全当前返回空，暂不迁移

TEST_COMPLETION [[
--- @alias event.AAA "AAA"
--- @alias event.BBB "BBB"

--- @class Emit
--- @field on fun(self: Emit, eventName: string, cb: function)
--- @field on fun(self: Emit, eventName: event.AAA, cb: fun(i: integer))
--- @field on fun(self: Emit, eventName: event.BBB, cb: fun(s: string))
local emit = {}

emit:on('BBB', <??>)
]] {
	[1] = {
		label    = 'fun(s: string)',
		kind     = ls.spec.CompletionItemKind.Function,
	}
}

-- [SKIPPED][iolib-table] 暂时跳过：iolib 表构造字段补全存在性
-- TEST_COMPLETION [[
-- ---@type iolib
-- local t = {
--     <??>
-- ]] (EXISTS)

TEST_COMPLETION [[
---@class AAA.BBB

---@type AAA.<??>
]] {
	{
		label = 'AAA.BBB',
		kind  = ls.spec.CompletionItemKind.Class,
		textEdit = {
			range = {
				start = {
					line = 2,
						character = 10,
				},
				['end'] = {
					line = 2,
					character = 13,
				},
			},
			newText = 'AAA.BBB',
		},
	}
}

TEST_COMPLETION [[
---@type {[1]: number}
local t

t.<??>
]] {
	{
		label = '1',
		kind  = ls.spec.CompletionItemKind.Field,
		textEdit = {
			newText = '[1]',
			range = {
				start = { line = 3, character = 1 },
				['end'] = { line = 3, character = 2 },
			},
		},
	},
}

TEST_COMPLETION [[
---@class Class
---@field on fun()
local c

c:<??>
]] {
	{
		label = 'on',
		kind  = ls.spec.CompletionItemKind.Field,
	}
}

TEST_COMPLETION [[
---@class A
---@field f fun(x: string): string

---@type A
local t = {
    f = <??>
}
]] {
	{
		label = 'fun(x: string):string',
		kind  = ls.spec.CompletionItemKind.Function,
	}
}

TEST_COMPLETION [[
---@param x {damage: integer, count: integer, health:integer}
local function f(x) end

f {<??>}
]] {
	{
		label = 'count',
		kind  = ls.spec.CompletionItemKind.Property,
	},
	{
		label = 'damage',
		kind  = ls.spec.CompletionItemKind.Property,
	},
	{
		label = 'health',
		kind  = ls.spec.CompletionItemKind.Property,
	},
}

TEST_COMPLETION [[
---@alias Foo Foo[]
---@type Foo
local foo
foo = {"<??>"}
]] (EXISTS)

TEST_COMPLETION [[
---@class c
---@field abc fun()
---@field abc2 fun()

---@param p c
local function f(p) end

f({
    abc = function(s)
        local abc3
        abc<??>
    end,
})
]] {
	{
		label = 'abc3',
		kind  = ls.spec.CompletionItemKind.Variable,
	},
}

-- [SKIPPED][description] 暂时跳过：带引号字段与普通字段 description 精确断言
-- Cared['description'] = true
-- TEST_COMPLETION [[
-- ---@class Foo
-- ---@field ['with quotes'] integer
-- ---@field without_quotes integer
--
-- ---@type Foo
-- local bar = {}
--
-- bar.<??>
-- ]] {
-- 	{
-- 		label = "'with quotes'",
-- 		kind  = ls.spec.CompletionItemKind.Field,
-- 		textEdit = {
-- 			start   = 70004,
-- 			finish  = 70004,
-- 			newText = "['with quotes']"
-- 		},
-- 		additionalTextEdits = {
-- 			{
-- 				start   = 70003,
-- 				finish  = 70004,
-- 				newText = '',
-- 			}
-- 		},
-- 		description = [[
-- ```lua
-- (field) Foo['with quotes']: integer
-- ```]]
-- 	},
-- 	{
-- 		label = 'without_quotes',
-- 		kind  = ls.spec.CompletionItemKind.Field,
-- 		description = [[
-- ```lua
-- (field) Foo.without_quotes: integer
-- ```]]
-- 	},
-- }
-- Cared['description'] = false

TEST_COMPLETION [[
---@class A
local M = {}

function M:method1()
end

function M.static1(tt)
end

function M:method2()
end

function M.static2(tt)
end

---@type A
local a

a.<??>
]] {
	{
		label ='static1(tt)',
		kind  = ls.spec.CompletionItemKind.Function,
	},
	{
		label ='static2(tt)',
		kind  = ls.spec.CompletionItemKind.Function,
	},
	{
		label ='method1(self)',
		kind  = ls.spec.CompletionItemKind.Method,
	},
	{
		label ='method2(self)',
		kind  = ls.spec.CompletionItemKind.Method,
	},
}

TEST_COMPLETION [[
---@class A
local M = {}

function M:method1()
end

function M.static1(tt)
end

function M:method2()
end

function M.static2(tt)
end

---@type A
local a

a:<??>
]] {
	{
		label ='method1()',
		kind  = ls.spec.CompletionItemKind.Method,
	},
	{
		label ='method2()',
		kind  = ls.spec.CompletionItemKind.Method,
	},
	{
		label ='static1()',
		kind  = ls.spec.CompletionItemKind.Function,
	},
	{
		label ='static2()',
		kind  = ls.spec.CompletionItemKind.Function,
	},
}

TEST_COMPLETION [[
---@class A
---@field x number
---@field y? number
---@field z number

---@type A
local t = {
    <??>
}
]] {
	{
		label = 'x',
		kind  = ls.spec.CompletionItemKind.Property,
	},
	{
		label = 'z',
		kind  = ls.spec.CompletionItemKind.Property,
	},
	{
		label = 'y?',
		kind  = ls.spec.CompletionItemKind.Property,
	},
}

-- [SKIPPED][description] 暂时跳过：字面量枚举注释 description 断言
-- TEST_COMPLETION [[
-- ---@param x string
-- ---| "选项1" # 注释1
-- ---| "选项2" # 注释2
-- function f(x) end
--
-- f(<??>)
-- ]] {
-- 	{
-- 		label = '"选项1"',
-- 		kind = ls.spec.CompletionItemKind.EnumMember,
-- 		description = '注释1',
-- 	},
-- 	{
-- 		label = '"选项2"',
-- 		kind = ls.spec.CompletionItemKind.EnumMember,
-- 		description = '注释2',
-- 	},
-- }

-- [SKIPPED][description] 暂时跳过：变量补全 description 存在性断言
-- TEST_COMPLETION [[
-- ---@class C
-- local t
--
-- local vvv = assert(t)
-- vvv<??>
-- ]] {
-- 	{
-- 		label  = 'vvv',
-- 		detail = 'C',
-- 		kind   = ls.spec.CompletionItemKind.Variable,
-- 		description = EXISTS,
-- 	},
-- }

-- [SKIPPED][description] 暂时跳过：函数参数补全 description 精确断言
-- TEST_COMPLETION [[
-- ---@param callback fun(x: number, y: number):string
-- local function f(callback) end
--
-- f(<??>)
-- ]] {
-- 	{
-- 		label  = 'fun(x: number, y: number):string',
-- 		kind   = ls.spec.CompletionItemKind.Function,
-- 		insertText = "\z
-- function (${1:x}, ${2:y})\
-- 	$0\
-- end",
-- 		description = "\z
-- ```lua\
-- function (x, y)\
-- 	\
-- end\
-- ```"
-- 	},
-- }

TEST_COMPLETION [[
---@type string
local s
s.<??>
]] (EXISTS)

TEST_COMPLETION [[
---@type table<string, integer>
local x = {
    a = 1,
    b = 2,
    c = 3
}

x.<??>
]] {
	{
		label = 'a',
		kind  = ls.spec.CompletionItemKind.Enum,
	},
	{
		label = 'b',
		kind  = ls.spec.CompletionItemKind.Enum,
	},
	{
		label = 'c',
		kind  = ls.spec.CompletionItemKind.Enum,
	},
}

TEST_COMPLETION [[
---@class A.B.C
local m

function m.f()
end

m.f<??>
]] {
	{
		label  = "f()",
		kind   = ls.spec.CompletionItemKind.Function,
		insertText = EXISTS,
	},
	{
		label  = "f()",
		kind   = ls.spec.CompletionItemKind.Snippet,
		insertText = 'f()',
	},
}

TEST_COMPLETION [[
---@class A
---@overload fun(x: {id: string})

---@generic T
---@param t `T`
---@return T
local function new(t) end

new 'A' {
    <??>
}
]] {
	{
		label = 'id',
		kind  = ls.spec.CompletionItemKind.Property,
	}
}

TEST_COMPLETION [[
---@class namespace.A
---@overload fun(x: {id: string})

---@generic T
---@param t namespace.`T`
---@return T
local function new(t) end

new 'A' {
    <??>
}
]] {
	{
		label = 'id',
		kind  = ls.spec.CompletionItemKind.Property,
	}
}

TEST_COMPLETION [[
---@class Array<T>: { [integer]: T }
---@field length integer
local Array

function Array:push() end

---@type Array<string>
local a
print(a.<??>)
]] {
	include = true,
	{
		label = 'length',
		kind  = ls.spec.CompletionItemKind.Field,
	},
	{
		label = 'push(self)',
		kind  = ls.spec.CompletionItemKind.Method,
	},
}

TEST_COMPLETION [[
---@class Array<T>: { [integer]: T }
---@field length integer
local Array

function Array:push() end

---@type Array<string>
local a
print(a:<??>)
]] {
	{
		label = 'push()',
		kind  = ls.spec.CompletionItemKind.Method,
	},
}

TEST_COMPLETION [[
---@class Options
---@field page number
---@field active boolean

---@param opts Options
local function acceptOptions(opts) end

acceptOptions({
<??>
})
]] (function (results)
	assert(#results == 2)
end)

TEST_COMPLETION [[
---@overload fun(x: number)
---@overload fun(x: number, y: number)
local function fff(...)
end

fff<??>
]] {
	care = {
		kind = ls.spec.CompletionItemKind.Function,
		label = {
			'fff(x)',
			'fff(x, y)',
		},
	},
	include = true,
	{
		label    = 'fff(x)',
		kind     = ls.spec.CompletionItemKind.Function,
	},
	{
		label    = 'fff(x, y)',
		kind     = ls.spec.CompletionItemKind.Function,
	},
}

TEST_COMPLETION [[
---@overload fun(x: number)
---@overload fun(x: number, y: number)
function fff(...)
end

fff<??>
]] {
	care = {
		kind = ls.spec.CompletionItemKind.Function,
		label = {
			'fff(x)',
			'fff(x, y)',
		},
	},
	include = true,
	{
		label    = 'fff(x)',
		kind     = ls.spec.CompletionItemKind.Function,
	},
	{
		label    = 'fff(x, y)',
		kind     = ls.spec.CompletionItemKind.Function,
	},
}

TEST_COMPLETION [[
---@overload fun(x: number)
---@overload fun(x: number, y: number)
function t.fff(...)
end

t.fff<??>
]] {
	care = {
		kind = ls.spec.CompletionItemKind.Function,
		label = 'fff(...)',
	},
	{
		label    = 'fff(...)',
		kind     = ls.spec.CompletionItemKind.Function,
	},
}

TEST_COMPLETION [[
---@class A
---@field private x number
---@field y number

---@type A
local t

t.<??>
]] {
	care = {
		kind = ls.spec.CompletionItemKind.Field,
		label = 'y',
	},
	{
		label    = 'y',
		kind     = ls.spec.CompletionItemKind.Field,
	},
}

TEST_COMPLETION [[
---@class A
---@field private x number
---@field protected y number
---@field z number

---@class B: A
local t

t.<??>
]] {
	care = {
		kind = ls.spec.CompletionItemKind.Field,
		label = 'z',
	},
	{
		label    = 'z',
		kind     = ls.spec.CompletionItemKind.Field,
	},
}

TEST_COMPLETION [[
---@class A
---@field private x number
---@field protected y number
---@field z number

---@class B: A

---@type B
local t

t.<??>
]] {
	care = {
		kind = ls.spec.CompletionItemKind.Field,
		label = 'z',
	},
	{
		label    = 'z',
		kind     = ls.spec.CompletionItemKind.Field,
	},
}

TEST_COMPLETION [[
---@class ABCD

---@see ABCD<??>
]] {
	care = {
		kind = ls.spec.CompletionItemKind.Class,
		label = 'ABCD',
	},
	{
		label    = 'ABCD',
		kind     = ls.spec.CompletionItemKind.Class,
	},
}

	TEST_COMPLETION [[
	---@class OptionObj
	---@field a boolean
	---@field b boolean

	---@type OptionObj[]
	local l = { {<??>} }
	]] {
		care = {
			kind = ls.spec.CompletionItemKind.Variable,
			label = '...',
		},
		{
			label = '...',
			kind = ls.spec.CompletionItemKind.Variable,
		}
	}

	TEST_COMPLETION [[
	---@class OptionObj
	---@field a boolean
	---@field b boolean

	---@type OptionObj[]
	local l = { <??> }
	]] {
		care = {
			kind = ls.spec.CompletionItemKind.Variable,
			label = '...',
		},
		{
			label = '...',
			kind = ls.spec.CompletionItemKind.Variable,
		},
	}

	TEST_COMPLETION [[
	---@class OptionObj
	---@field a boolean
	---@field b boolean

	---@type OptionObj[]
	local l = <??>
	]] (nil)

	TEST_COMPLETION [[
	---@class OptionObj
	---@field a boolean
	---@field b boolean
	---@field children OptionObj[]

	---@type OptionObj[]
	local l = {
	    {
	        a = true,
	        children = { {<??>} }
	    }
	}
	]] {
		care = {
			kind = ls.spec.CompletionItemKind.Variable,
			label = '...',
		},
		{
			label = '...',
			kind = ls.spec.CompletionItemKind.Variable,
		}
	}

	TEST_COMPLETION [[
	---@class OptionObj
	---@field a boolean
	---@field b boolean
	---@field children OptionObj[]

	---@type OptionObj[]
	local l = {
	    {
	        children = {<??>}
	    }
	}
	]] {
		care = {
			kind = ls.spec.CompletionItemKind.Variable,
			label = '...',
		},
		{
			label = '...',
			kind = ls.spec.CompletionItemKind.Variable,
		},
	}

	TEST_COMPLETION [[
	---@class OptionObj
	---@field a boolean
	---@field b boolean
	---@field children OptionObj[]

	---@type OptionObj[]
	local l = {
	    {
	        children = <??>
	    }
	}
	]] {
		care = {
			kind = ls.spec.CompletionItemKind.Variable,
			label = '...',
		},
		{
			label = '...',
			kind = ls.spec.CompletionItemKind.Variable,
		},
	}

	TEST_COMPLETION [[
	---@class OptionObj
	---@field a boolean
	---@field b boolean
	---@param x OptionObj[]
	function f(x)
	end

	f({ {<??>} })
	]] (nil)

	TEST_COMPLETION [[
	---@class OptionObj
	---@field a boolean
	---@field b boolean
	---@param x OptionObj[]
	function f(x)
	end

	f({<??>})
	]] {
		care = {
			kind = ls.spec.CompletionItemKind.Variable,
			label = '...',
		},
		{
			label = '...',
			kind = ls.spec.CompletionItemKind.Variable,
		},
	}

	TEST_COMPLETION [[
	---@class OptionObj
	---@field a boolean
	---@field b boolean
	---@param x OptionObj[]
	function f(x)
	end

	f(<??>)
	]] (nil)

	TEST_COMPLETION [[
	---this is
	---a multi line
	---comment
	---@alias XXXX
	---comment 1
	---comment 1
	---| 1
	---comment 2
	---comment 2
	---| 2

	---@param x XXXX
	local function f(x)
	end

	f(<??>)
	]] {
		care = {
			kind = ls.spec.CompletionItemKind.EnumMember,
		},
	}

	TEST_COMPLETION [[
	---@param x function | 'function () end'
	function f(x)
	end

	f(function ()
	    <??>
	end)
	]] {
		care = function (item)
			return item.label == '...'
				or item.label == 'f'
				or item.label == 'f(x)'
		end,
		include = true,
		{
			label = '...',
		},
		{
			label = 'f',
		},
		{
			label = 'f(x)',
			insertText = 'f',
		},
		{
			label = 'f(x)',
			insertText = 'f(${1:x})',
		},
	}

	TEST_COMPLETION [[
	---@class C
	---@field x number
	---@field y number

	---@vararg C
	local function f(x, ...)
	end

	f(1, {
	    <??>
	})
	]] {
		care = function (item)
			return item.label == '...'
				or item.label == 'f(x, ...)'
		end,
		include = true,
		{
			label = '...',
		},
		{
			label = 'f(x, ...)',
			insertText = 'f',
		},
		{
			label = 'f(x, ...)',
			insertText = 'f(${1:x}, ${2:...})',
		}
	}

	TEST_COMPLETION [[
	---@class C
	---@field x number
	---@field y number

	---@vararg C
	local function f(x, ...)
	end

	f(1, {}, {}, {
	    <??>
	})
	]] {
		care = function (item)
			return item.label == '...'
				or item.label == 'f(x, ...)'
		end,
		include = true,
		{
			label = '...',
		},
		{
			label = 'f(x, ...)',
			insertText = 'f',
		},
		{
			label = 'f(x, ...)',
			insertText = 'f(${1:x}, ${2:...})',
		}
	}

	TEST_COMPLETION [[
	---@class C
	---@field x number
	---@field y number

	---@type C
	local t = {
	    <??>
	}

	]] {
		{
			label = 'x',
			kind  = ls.spec.CompletionItemKind.Property,
		},
		{
			label = 'y',
			kind  = ls.spec.CompletionItemKind.Property,
		}
	}

	TEST_COMPLETION [[
	---@class C
	---@field x number
	---@field y number

	---@type C
	local t = {
	    x<??>
	}

	]] {
		include = true,
		{
			label = 'x',
			kind  = ls.spec.CompletionItemKind.Property,
		},
	}

	TEST_COMPLETION [[
	---this is
	---a multi line
	---comment
	---@alias XXXX
	---comment 1
	---comment 1
	---| 1
	---comment 2
	---comment 2
	---| 2
	---@param x XXXX
	local function f(x)
	end

	---comment 3
	---comment 3
	---| 3

	f(<??>)
	]] {
		care = {
			kind = ls.spec.CompletionItemKind.EnumMember,
		},
	}

TEST_COMPLETION [[
---@class A
---@field x number
---@field y? number
---@field z number

---@param t A
local function f(t) end

f {
    <??>
}
]] {
	{
		label = 'x',
		kind  = ls.spec.CompletionItemKind.Property,
	},
	{
		label = 'y',
		kind  = ls.spec.CompletionItemKind.Property,
	},
	{
		label = 'z',
		kind  = ls.spec.CompletionItemKind.Property,
	},
}
