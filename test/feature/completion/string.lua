-- string 补全测试
-- TODO: 实现字符串枚举补全 provider 后补充用例

TEST_COMPLETION [[
---@param x string | "AAA" | "BBB" | "CCC"
function f(y, x)
end

f(1, <??>)
]] {
	{
		label = '"AAA"',
		kind = ls.spec.CompletionItemKind.EnumMember,
	},
	{
		label = '"BBB"',
		kind = ls.spec.CompletionItemKind.EnumMember,
	},
	{
		label = '"CCC"',
		kind = ls.spec.CompletionItemKind.EnumMember,
	}
}

TEST_COMPLETION [[
---@param x string | "AAA" | "BBB" | "CCC"
function f(y, x)
end

f(1,<??>)
]] {
	{
		label = '"AAA"',
		kind = ls.spec.CompletionItemKind.EnumMember,
	},
	{
		label = '"BBB"',
		kind = ls.spec.CompletionItemKind.EnumMember,
	},
	{
		label = '"CCC"',
		kind = ls.spec.CompletionItemKind.EnumMember,
	}
}

TEST_COMPLETION [[
---@param x string | "AAA" | "BBB" | "CCC"
function f(x)
end

f(<??>)
]] {
	{
		label = '"AAA"',
		kind = ls.spec.CompletionItemKind.EnumMember,
	},
	{
		label = '"BBB"',
		kind = ls.spec.CompletionItemKind.EnumMember,
	},
	{
		label = '"CCC"',
		kind = ls.spec.CompletionItemKind.EnumMember,
	}
}

TEST_COMPLETION [[
---@alias Option string | "AAA" | "BBB" | "CCC"
---@param x Option
function f(x)
end

f(<??>)
]] {
	{
		label = '"AAA"',
		kind = ls.spec.CompletionItemKind.EnumMember,
	},
	{
		label = '"BBB"',
		kind = ls.spec.CompletionItemKind.EnumMember,
	},
	{
		label = '"CCC"',
		kind = ls.spec.CompletionItemKind.EnumMember,
	}
}

TEST_COMPLETION [[
---@param x string | "AAA" | "BBB" | "CCC"
function f(x)
end

f('<??>')
]] {
	{
		label = "'AAA'",
		kind = ls.spec.CompletionItemKind.EnumMember,
		textEdit = EXISTS,
	},
	{
		label = "'BBB'",
		kind = ls.spec.CompletionItemKind.EnumMember,
		textEdit = EXISTS,
	},
	{
		label = "'CCC'",
		kind = ls.spec.CompletionItemKind.EnumMember,
		textEdit = EXISTS,
	}
}

TEST_COMPLETION [[
---@alias Option string | "AAA" | "BBB" | "CCC"
---@param x Option[]
function f(x)
end

f({<??>})
]] {
	{
		label = '"AAA"',
		kind = ls.spec.CompletionItemKind.EnumMember,
		textEdit = EXISTS
	},
	{
		label = '"BBB"',
		kind = ls.spec.CompletionItemKind.EnumMember,
		textEdit = EXISTS
	},
	{
		label = '"CCC"',
		kind = ls.spec.CompletionItemKind.EnumMember,
		textEdit = EXISTS
	}
}

TEST_COMPLETION [[
---@alias Option string | "AAA" | "BBB" | "CCC"
---@param x Option[]
function f(x)
end

f({"<??>"})
]] {
	{
		label = '"AAA"',
		kind = ls.spec.CompletionItemKind.EnumMember,
		textEdit = EXISTS
	},
	{
		label = '"BBB"',
		kind = ls.spec.CompletionItemKind.EnumMember,
		textEdit = EXISTS
	},
	{
		label = '"CCC"',
		kind = ls.spec.CompletionItemKind.EnumMember,
		textEdit = EXISTS
	}
}

TEST_COMPLETION [[
---@alias Option string | "AAA" | "BBB" | "CCC"
---@param x Option[]
function f(x)
end

f(<??>)
]] (nil)

TEST_COMPLETION [[
---@alias Option "AAA" | "BBB" | "CCC"

---@type Option[]
local l = {<??>}
]] {
	{
		label = '"AAA"',
		kind = ls.spec.CompletionItemKind.EnumMember,
	},
	{
		label = '"BBB"',
		kind = ls.spec.CompletionItemKind.EnumMember,
	},
	{
		label = '"CCC"',
		kind = ls.spec.CompletionItemKind.EnumMember,
	}
}

TEST_COMPLETION [[
---@alias Option "AAA" | "BBB" | "CCC"

---@type Option[]
local l = {"<??>"}
]] {
	{
		label = '"AAA"',
		kind = ls.spec.CompletionItemKind.EnumMember,
		textEdit = EXISTS
	},
	{
		label = '"BBB"',
		kind = ls.spec.CompletionItemKind.EnumMember,
		textEdit = EXISTS
	},
	{
		label = '"CCC"',
		kind = ls.spec.CompletionItemKind.EnumMember,
		textEdit = EXISTS
	}
}

TEST_COMPLETION [[
---@alias Option "AAA" | "BBB" | "CCC"

---@type Option[]
local l = <??>
]] (nil)

TEST_COMPLETION [[
---@type "a"|"b"|"c"
local x

print(x == <??>)
]] {
	{
		label  = '"a"',
		kind   = ls.spec.CompletionItemKind.EnumMember,
	},
	{
		label  = '"b"',
		kind   = ls.spec.CompletionItemKind.EnumMember,
	},
	{
		label  = '"c"',
		kind   = ls.spec.CompletionItemKind.EnumMember,
	},
}

TEST_COMPLETION [[
---@type "a"|"b"|"c"
local x

x = <??>
]] {
	{
		label  = '"a"',
		kind   = ls.spec.CompletionItemKind.EnumMember,
	},
	{
		label  = '"b"',
		kind   = ls.spec.CompletionItemKind.EnumMember,
	},
	{
		label  = '"c"',
		kind   = ls.spec.CompletionItemKind.EnumMember,
	},
}

TEST_COMPLETION [[
---@type "a"|"b"|"c"
local x

print(x == '<??>')
]] {
	{
		label  = "'a'",
		kind   = ls.spec.CompletionItemKind.EnumMember,
		textEdit = EXISTS,
	},
	{
		label  = "'b'",
		kind   = ls.spec.CompletionItemKind.EnumMember,
		textEdit = EXISTS,
	},
	{
		label  = "'c'",
		kind   = ls.spec.CompletionItemKind.EnumMember,
		textEdit = EXISTS,
	},
}

TEST_COMPLETION [[
---@type "a"|"b"|"c"
local x

x = '<??>'
]] {
	{
		label  = "'a'",
		kind   = ls.spec.CompletionItemKind.EnumMember,
		textEdit = EXISTS,
	},
	{
		label  = "'b'",
		kind   = ls.spec.CompletionItemKind.EnumMember,
		textEdit = EXISTS,
	},
	{
		label  = "'c'",
		kind   = ls.spec.CompletionItemKind.EnumMember,
		textEdit = EXISTS,
	},
}

TEST_COMPLETION [[
---@type table<string, "a"|"b"|"c">
local x

x.a = <??>
]] {
	{
		label  = '"a"',
		kind   = ls.spec.CompletionItemKind.EnumMember,
	},
	{
		label  = '"b"',
		kind   = ls.spec.CompletionItemKind.EnumMember,
	},
	{
		label  = '"c"',
		kind   = ls.spec.CompletionItemKind.EnumMember,
	},
}

TEST_COMPLETION [[
---@type table<string, "a"|"b"|"c">
local x

x['a'] = <??>
]] {
	{
		label  = '"a"',
		kind   = ls.spec.CompletionItemKind.EnumMember,
	},
	{
		label  = '"b"',
		kind   = ls.spec.CompletionItemKind.EnumMember,
	},
	{
		label  = '"c"',
		kind   = ls.spec.CompletionItemKind.EnumMember,
	},
}

TEST_COMPLETION [[
---@type table<string, "a"|"b"|"c">
local x = {
    a = <??>
}
]] {
	{
		label  = '"a"',
		kind   = ls.spec.CompletionItemKind.EnumMember,
	},
	{
		label  = '"b"',
		kind   = ls.spec.CompletionItemKind.EnumMember,
	},
	{
		label  = '"c"',
		kind   = ls.spec.CompletionItemKind.EnumMember,
	},
}

TEST_COMPLETION [[
---@type table<string, "a"|"b"|"c">
local x = {
    ['a'] = <??>
}
]] {
	{
		label  = '"a"',
		kind   = ls.spec.CompletionItemKind.EnumMember,
	},
	{
		label  = '"b"',
		kind   = ls.spec.CompletionItemKind.EnumMember,
	},
	{
		label  = '"c"',
		kind   = ls.spec.CompletionItemKind.EnumMember,
	},
}

TEST_COMPLETION [[
---@alias enum '"aaa"'|'"bbb"'

---@param x enum
---@return enum
local function f(x)
end

local r = f('<??>')
]] {
	{
		label = "'aaa'",
		kind  = ls.spec.CompletionItemKind.EnumMember,
		textEdit = {
			newText = "'aaa'",
			start   = 70012,
			finish  = 70014,
		},
	},
	{
		label = "'bbb'",
		kind  = ls.spec.CompletionItemKind.EnumMember,
		textEdit = {
			newText = "'bbb'",
			start   = 70012,
			finish  = 70014,
		},
	},
}

TEST_COMPLETION [[
---@type fun(x: "'aaa'"|"'bbb'")
local f

f('<??>')
]] {
	{
		label = "'aaa'",
		kind  = ls.spec.CompletionItemKind.EnumMember,
		textEdit = {
			newText = "'aaa'",
			start   = 30002,
			finish  = 30004,
		},
	},
	{
		label = "'bbb'",
		kind  = ls.spec.CompletionItemKind.EnumMember,
		textEdit = {
			newText = "'bbb'",
			start   = 30002,
			finish  = 30004,
		},
	},
}

TEST_COMPLETION [[
---@type `CONST.X` | `CONST.Y`
local x

if x == <??>
]] {
	{
		label = 'CONST.X',
		kind  = ls.spec.CompletionItemKind.EnumMember,
	},
	{
		label = 'CONST.Y',
		kind  = ls.spec.CompletionItemKind.EnumMember,
	},
}

TEST_COMPLETION [[
---@param x `CONST.X` | `CONST.Y`
local function f(x) end

f(<??>)
]] {
	{
		label = 'CONST.X',
		kind  = ls.spec.CompletionItemKind.EnumMember,
	},
	{
		label = 'CONST.Y',
		kind  = ls.spec.CompletionItemKind.EnumMember,
	},
}

TEST_COMPLETION [[
---@class A
---@field xxx 'aaa'|'bbb'

---@type A
local t = {
    xxx = '<??>
}
]] {
	{
		label    = "'aaa'",
		kind     = ls.spec.CompletionItemKind.EnumMember,
		textEdit = EXISTS,
	},
	{
		label    = "'bbb'",
		kind     = ls.spec.CompletionItemKind.EnumMember,
		textEdit = EXISTS,
	},
}

if false then
TEST_COMPLETION [[
---@class optional
---@field enum enum

---@enum(key) enum
local t = {
    a = 1,
    b = 2,
}

---@param a optional
local function f(a)
end

f {
    enum = <??>
}
]] {
	{
		label    = '"a"',
		kind     = ls.spec.CompletionItemKind.EnumMember,
	},
	{
		label    = '"b"',
		kind     = ls.spec.CompletionItemKind.EnumMember,
	},
}

TEST_COMPLETION [[
---@enum(key) enum
local t = {
    a = 1,
    b = 2,
    c = 3,
}

---@class A
local M

---@param optional enum
function M:optional(optional)
end

---@return A
function M:self()
    return self
end

---@type A
local m

m:self(<??>):optional()
]] (nil)

TEST_COMPLETION [[
---@enum(key) enum
local t = {
    a = 1,
    b = 2,
    c = 3,
}

---@class A
local M

---@return A
function M.create()
    return M
end

---@param optional enum
---@return self
function M:optional(optional)
    return self
end

---@return A
function M:self()
    return self
end

M.create():optional(<??>):self()
]] {
	{
		label = '"a"',
		kind  = ls.spec.CompletionItemKind.EnumMember,
	},
	{
		label = '"b"',
		kind  = ls.spec.CompletionItemKind.EnumMember,
	},
	{
		label = '"c"',
		kind  = ls.spec.CompletionItemKind.EnumMember,
	},
}
end

TEST_COMPLETION [[
---@class A
---@field a '"hello"'|'"world"'

---@param t A
function api(t) end

api({<??>})
]] (EXISTS)

TEST_COMPLETION [[
---@class A
---@field a '"hello"'|'"world"'

---@param t A
function m:api(t) end

m:api({<??>})
]] (EXISTS)

TEST_COMPLETION [[
---@class Class
---@field on fun(self, x: "'aaa'"|"'bbb'")
local c

c:on(<??>)
]] (EXISTS)

TEST_COMPLETION [[
---@class Class
---@field on fun(x: "'aaa'"|"'bbb'")
local c

c.on('<??>')
]] (EXISTS)
