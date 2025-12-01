local parser = require 'parser'

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

local function getLine(offset, lns)
    for i = 0, #lns do
        if  offset >= lns[i]
        and offset < lns[i+1] then
            return i
        end
    end
end

local function getPosition(offset, lns)
    for i = 0, #lns do
        if  offset >= lns[i]
        and offset < lns[i+1] then
            return 10000 * i + offset - lns[i]
        end
    end
end

---@param script string
---@param sep string
local function catchTarget(script, sep)
    local pattern = ('()<%%%s.-%%%s>()'):format(sep, sep)
    local lns = {}
    lns[0] = 0
    for pos in script:gmatch '()\n' do
        lns[#lns+1] = pos
    end
    lns[#lns+1] = math.maxinteger
    local codes = {}
    local pos   = 1
    local list = {}
    local cuted = 0
    local lastLine = 0
    for a, b in script:gmatch(pattern) do
        codes[#codes+1] = script:sub(pos, a - 1)
        codes[#codes+1] = script:sub(a + 2, b - 3)
        pos = b
        local line1 = getLine(a + 1, lns)
        if line1 ~= lastLine then
            cuted = 0
            lastLine = line1
        end
        cuted = cuted + 2
        local left = getPosition(a + 1, lns) - cuted
        local line2 = getLine(b - 3, lns)
        if line2 ~= lastLine then
            cuted = 0
            lastLine = line2
        end
        local right = getPosition(b - 3, lns) - cuted
        cuted = cuted + 2
        list[#list+1] = { left, right }
    end
    codes[#codes+1] = script:sub(pos)
    return table.concat(codes), list
end

local Version

local function TEST(script)
    return function (expect)
        local newScript, list = catchTarget(script, '!')
        local ast = parser.compile(newScript, 'Lua', Version)
        assert(ast)
        local errs = ast.errs
        local first = errs[1]
        local target = list[1]
        if not expect then
            assert(#errs == 0)
            return
        end
        if expect.multi then
            assert(#errs > 1)
            first = errs[expect.multi]
        else
            assert(#errs == 1)
        end
        assert(first)
        assert(first.type == expect.type)
        assert(first.start == target[1])
        assert(first.finish == target[2])
        assert(eq(first.version, expect.version))
        assert(eq(first.info, expect.info))
    end
end

function TestWith(version)
    return function (script)
        return function (expect)
            Version = version
            TEST(script)(expect)
            Version = 'Lua 5.4'
        end
    end
end

TEST [[
local <!true!> = 1
]]
{
    type = 'KEYWORD'
}

TEST [[
local function f(<!true!>)
end
]]
{
    type = 'KEYWORD'
}

TEST[[
function f()
    return <!...!>
end
]]
{
    type = 'UNEXPECT_DOTS',
}

TEST[[
function f(...)
    return function ()
        return <!...!>
    end
end
]]
{
    type = 'UNEXPECT_DOTS',
}

TEST[[
function f(...)
    return ...
end
]]
(nil)

TEST[[
for i = 1, 10 do
    break
end
]]
(nil)

TEST[[
for k, v in pairs(t) do
    break
end
]]
(nil)

TEST[[
while true do
    break
end
]]
(nil)

TEST[[
repeat
    break
until true
]]
(nil)

TEST[[
<!break!>
]]
{
    type = 'BREAK_OUTSIDE',
}

TEST[[
function f (x)
    if 1 then <!break!> end
end
]]
{
    type = 'BREAK_OUTSIDE',
}

TEST[[
while 1 do
end
<!break!>
]]
{
    type = 'BREAK_OUTSIDE',
}

TEST[[
while 1 do
    local function f()
        <!break!>
    end
end
]]
{
    type = 'BREAK_OUTSIDE',
}

TEST[[
:: label :: <!return!>
goto label
]]
{
    type = 'ACTION_AFTER_RETURN',
}

TEST[[
::label::
goto label
]]
(nil)

TEST[[
goto label
::label::
]]
(nil)

TEST[[
do
    goto label
end
::label::
]]
(nil)

TEST[[
::label::
do
    goto label
end
]]
(nil)

TEST[[
goto label
local x = 1
x = 2
::label::
]]
(nil)

TEST[[
local x = 1
goto label
x = 2
::label::
print(x)
]]
(nil)

TEST[[
local x = 1
::label::
print(x)
local x
goto label
]]
(nil)

TEST[[
goto <!label!>
]]
{
    type = 'NO_VISIBLE_LABEL',
    info = {
        label = 'label',
    }
}

TEST[[
::other_label::
do do do goto <!label!> end end end
]]
{
    type = 'NO_VISIBLE_LABEL',
    info = {
        label = 'label',
    }
}

TEST[[
goto <!label!>
do
    ::label::
end
]]
{
    type = 'NO_VISIBLE_LABEL',
    info = {
        label = 'label',
    }
}

TEST[[
goto <!label!>
local x = 1
::label::
x = 2
]]
{
    type = 'JUMP_LOCAL_SCOPE',
    info = {
        loc = 'x',
    },
    relative = {
        {
            start = 26,
            finish = 30,
        },
        {
            start = 18,
            finish = 18,
        },
    }
}

TEST[[
goto <!label!>
local x = 1
::label::
return x
]]
{
    type = 'JUMP_LOCAL_SCOPE',
    info = {
        loc = 'x',
    },
    relative = {
        {
            start = 26,
            finish = 30,
        },
        {
            start = 18,
            finish = 18,
        },
    }
}

TEST[[
::label::
::other_label::
::<!label!>::
]]
{
    type = 'REDEFINED_LABEL',
    related = {
        {
            start  = 3,
            finish = 7,
        },
    }
}

Version = 'Lua 5.4'
TEST[[
::label::
::other_label::
if true then
    ::<!label!>::
end
]]
{
    type = 'REDEFINED_LABEL',
    related = {
        {
            start  = 3,
            finish = 7,
        },
    }
}

TEST[[
if true then
    ::label::
end
::label::
]]
(nil)

Version = 'Lua 5.3'
TEST[[
::label::
::other_label::
if true then
    ::label::
end
]]
(nil)

TEST[[
if true then
    ::label::
end
::label::
]]
(nil)

Version = 'Lua 5.4'
TEST[[
local x <const> = 1
<!x!> = 2
]]
{
    type = 'SET_CONST',
}

TEST[[
local x <const> = 1
function <!x!>() end
]]
{
    type = 'SET_CONST',
}

TEST[[
local x <close> = 1
<!x!> = 2
]]
{
    type = 'SET_CONST',
}

TEST[[
local x <<!what!>> = 1
]]
{
    type = 'UNKNOWN_ATTRIBUTE',
}

TEST [[
return function () local l1, l2, l3, l4, l5, l6, l7, l8, l9, l10, l11, l12, l13, l14, l15, l16, l17, l18, l19, l20, l21, l22, l23, l24, l25, l26, l27, l28, l29, l30, l31, l32, l33, l34, l35, l36, l37, l38, l39, l40, l41, l42, l43, l44, l45, l46, l47, l48, l49, l50, l51, l52, l53, l54, l55, l56, l57, l58, l59, l60, l61, l62, l63, l64, l65, l66, l67, l68, l69, l70, l71, l72, l73, l74, l75, l76, l77, l78, l79, l80, l81, l82, l83, l84, l85, l86, l87, l88, l89, l90, l91, l92, l93, l94, l95, l96, l97, l98, l99, l100, l101, l102, l103, l104, l105, l106, l107, l108, l109, l110, l111, l112, l113, l114, l115, l116, l117, l118, l119, l120, l121, l122, l123, l124, l125, l126, l127, l128, l129, l130, l131, l132, l133, l134, l135, l136, l137, l138, l139, l140, l141, l142, l143, l144, l145, l146, l147, l148, l149, l150, l151, l152, l153, l154, l155, l156, l157, l158, l159, l160, l161, l162, l163, l164, l165, l166, l167, l168, l169, l170, l171, l172, l173, l174, l175, l176, l177, l178, l179, l180, l181, l182, l183, l184, l185, l186, l187, l188, l189, l190, l191, l192, l193, l194, l195, l196, l197, l198, l199, l200, <!l201!>, l202 end
]]
{
    type = 'LOCAL_LIMIT',
}

TEST [[
local l1, l2, l3, l4, l5, l6, l7, l8, l9, l10, l11, l12, l13, l14, l15, l16, l17, l18, l19, l20, l21, l22, l23, l24, l25, l26, l27, l28, l29, l30, l31, l32, l33, l34, l35, l36, l37, l38, l39, l40, l41, l42, l43, l44, l45, l46, l47, l48, l49, l50, l51, l52, l53, l54, l55, l56, l57, l58, l59, l60, l61, l62, l63, l64, l65, l66, l67, l68, l69, l70, l71, l72, l73, l74, l75, l76, l77, l78, l79, l80, l81, l82, l83, l84, l85, l86, l87, l88, l89, l90, l91, l92, l93, l94, l95, l96, l97, l98, l99, l100, l101, l102, l103, l104, l105, l106, l107, l108, l109, l110, l111, l112, l113, l114, l115, l116, l117, l118, l119, l120, l121, l122, l123, l124, l125, l126, l127, l128, l129, l130, l131, l132, l133, l134, l135, l136, l137, l138, l139, l140, l141, l142, l143, l144, l145, l146, l147, l148, l149, l150, l151, l152, l153, l154, l155, l156, l157, l158, l159, l160, l161, l162, l163, l164, l165, l166, l167, l168, l169, l170, l171, l172, l173, l174, l175, l176, l177, l178, l179, l180, l181, l182, l183, l184, l185, l186, l187, l188, l189, l190, l191, l192, l193, l194, l195, l196, l197, l198, l199, l200, <!l201!>, l202
]]
{
    type = 'LOCAL_LIMIT',
}

TEST [[
return function (l1, l2, l3, l4, l5, l6, l7, l8, l9, l10, l11, l12, l13, l14, l15, l16, l17, l18, l19, l20, l21, l22, l23, l24, l25, l26, l27, l28, l29, l30, l31, l32, l33, l34, l35, l36, l37, l38, l39, l40, l41, l42, l43, l44, l45, l46, l47, l48, l49, l50, l51, l52, l53, l54, l55, l56, l57, l58, l59, l60, l61, l62, l63, l64, l65, l66, l67, l68, l69, l70, l71, l72, l73, l74, l75, l76, l77, l78, l79, l80, l81, l82, l83, l84, l85, l86, l87, l88, l89, l90, l91, l92, l93, l94, l95, l96, l97, l98, l99, l100, l101, l102, l103, l104, l105, l106, l107, l108, l109, l110, l111, l112, l113, l114, l115, l116, l117, l118, l119, l120, l121, l122, l123, l124, l125, l126, l127, l128, l129, l130, l131, l132, l133, l134, l135, l136, l137, l138, l139, l140, l141, l142, l143, l144, l145, l146, l147, l148, l149, l150, l151, l152, l153, l154, l155, l156, l157, l158, l159, l160, l161, l162, l163, l164, l165, l166, l167, l168, l169, l170, l171, l172, l173, l174, l175, l176, l177, l178, l179, l180, l181, l182, l183, l184, l185, l186, l187, l188, l189, l190, l191, l192, l193, l194, l195, l196, l197, l198, l199, l200, <!l201!>, l202) end
]]
{
    type = 'LOCAL_LIMIT',
}

TEST [[
return function (l1, l2, l3, l4, l5, l6, l7, l8, l9, l10, l11, l12, l13, l14, l15, l16, l17, l18, l19, l20, l21, l22, l23, l24, l25, l26, l27, l28, l29, l30, l31, l32, l33, l34, l35, l36, l37, l38, l39, l40, l41, l42, l43, l44, l45, l46, l47, l48, l49, l50, l51, l52, l53, l54, l55, l56, l57, l58, l59, l60, l61, l62, l63, l64, l65, l66, l67, l68, l69, l70, l71, l72, l73, l74, l75, l76, l77, l78, l79, l80, l81, l82, l83, l84, l85, l86, l87, l88, l89, l90, l91, l92, l93, l94, l95, l96, l97, l98, l99, l100, l101, l102, l103, l104, l105, l106, l107, l108, l109, l110, l111, l112, l113, l114, l115, l116, l117, l118, l119, l120, l121, l122, l123, l124, l125, l126, l127, l128, l129, l130, l131, l132, l133, l134, l135, l136, l137, l138, l139, l140, l141, l142, l143, l144, l145, l146, l147, l148, l149, l150, l151, l152, l153, l154, l155, l156, l157, l158, l159, l160, l161, l162, l163, l164, l165, l166, l167, l168, l169, l170, l171, l172, l173, l174, l175, l176, l177, l178, l179, l180, l181, l182, l183, l184, l185, l186, l187, l188, l189, l190, l191, l192, l193, l194, l195, l196, l197, l198, l199)
    do
        local x
    end
    local x
    do
        local <!x!>
    end
end
]]
{
    type = 'LOCAL_LIMIT',
}

TEST [[
return function (l1, l2, l3, l4, l5, l6, l7, l8, l9, l10, l11, l12, l13, l14, l15, l16, l17, l18, l19, l20, l21, l22, l23, l24, l25, l26, l27, l28, l29, l30, l31, l32, l33, l34, l35, l36, l37, l38, l39, l40, l41, l42, l43, l44, l45, l46, l47, l48, l49, l50, l51, l52, l53, l54, l55, l56, l57, l58, l59, l60, l61, l62, l63, l64, l65, l66, l67, l68, l69, l70, l71, l72, l73, l74, l75, l76, l77, l78, l79, l80, l81, l82, l83, l84, l85, l86, l87, l88, l89, l90, l91, l92, l93, l94, l95, l96, l97, l98, l99, l100, l101, l102, l103, l104, l105, l106, l107, l108, l109, l110, l111, l112, l113, l114, l115, l116, l117, l118, l119, l120, l121, l122, l123, l124, l125, l126, l127, l128, l129, l130, l131, l132, l133, l134, l135, l136, l137, l138, l139, l140, l141, l142, l143, l144, l145, l146, l147, l148, l149, l150, l151, l152, l153, l154, l155, l156, l157, l158, l159, l160, l161, l162, l163, l164, l165, l166, l167, l168, l169, l170, l171, l172, l173, l174, l175, l176, l177, l178, l179, l180, l181, l182, l183, l184, l185, l186, l187, l188, l189, l190, l191, l192, l193, l194, l195, l196, l197, l198, l199)
    local function F() end
    local <!x!>
end
]]
{
    type = 'LOCAL_LIMIT',
}

TEST [[
local l1, l2, l3, l4, l5, l6, l7, l8, l9, l10, l11, l12, l13, l14, l15, l16, l17, l18, l19, l20, l21, l22, l23, l24, l25, l26, l27, l28, l29, l30, l31, l32, l33, l34, l35, l36, l37, l38, l39, l40, l41, l42, l43, l44, l45, l46, l47, l48, l49, l50, l51, l52, l53, l54, l55, l56, l57, l58, l59, l60, l61, l62, l63, l64, l65, l66, l67, l68, l69, l70, l71, l72, l73, l74, l75, l76, l77, l78, l79, l80, l81, l82, l83, l84, l85, l86, l87, l88, l89, l90, l91, l92, l93, l94, l95, l96, l97, l98, l99, l100, l101, l102, l103, l104, l105, l106, l107, l108, l109, l110, l111, l112, l113, l114, l115, l116, l117, l118, l119, l120, l121, l122, l123, l124, l125, l126, l127, l128, l129, l130, l131, l132, l133, l134, l135, l136, l137, l138, l139, l140, l141, l142, l143, l144, l145, l146, l147, l148, l149, l150, l151, l152, l153, l154, l155, l156, l157, l158, l159, l160, l161, l162, l163, l164, l165, l166, l167, l168, l169, l170, l171, l172, l173, l174, l175, l176, l177, l178, l179, l180, l181, l182, l183, l184, l185, l186, l187, l188, l189, l190, l191, l192, l193, l194, l195, l196, l197

for <!i!> = 1, 10 do end -- use 4 local variables
]]
{
    type = 'LOCAL_LIMIT',
}

TEST [[
local l1, l2, l3, l4, l5, l6, l7, l8, l9, l10, l11, l12, l13, l14, l15, l16, l17, l18, l19, l20, l21, l22, l23, l24, l25, l26, l27, l28, l29, l30, l31, l32, l33, l34, l35, l36, l37, l38, l39, l40, l41, l42, l43, l44, l45, l46, l47, l48, l49, l50, l51, l52, l53, l54, l55, l56, l57, l58, l59, l60, l61, l62, l63, l64, l65, l66, l67, l68, l69, l70, l71, l72, l73, l74, l75, l76, l77, l78, l79, l80, l81, l82, l83, l84, l85, l86, l87, l88, l89, l90, l91, l92, l93, l94, l95, l96, l97, l98, l99, l100, l101, l102, l103, l104, l105, l106, l107, l108, l109, l110, l111, l112, l113, l114, l115, l116, l117, l118, l119, l120, l121, l122, l123, l124, l125, l126, l127, l128, l129, l130, l131, l132, l133, l134, l135, l136, l137, l138, l139, l140, l141, l142, l143, l144, l145, l146, l147, l148, l149, l150, l151, l152, l153, l154, l155, l156, l157, l158, l159, l160, l161, l162, l163, l164, l165, l166, l167, l168, l169, l170, l171, l172, l173, l174, l175, l176, l177, l178, l179, l180, l181, l182, l183, l184, l185, l186, l187, l188, l189, l190, l191, l192, l193, l194, l195, l196

for i = 1, 10 do end
]]
(nil)

TEST [[
local l1, l2, l3, l4, l5, l6, l7, l8, l9, l10, l11, l12, l13, l14, l15, l16, l17, l18, l19, l20, l21, l22, l23, l24, l25, l26, l27, l28, l29, l30, l31, l32, l33, l34, l35, l36, l37, l38, l39, l40, l41, l42, l43, l44, l45, l46, l47, l48, l49, l50, l51, l52, l53, l54, l55, l56, l57, l58, l59, l60, l61, l62, l63, l64, l65, l66, l67, l68, l69, l70, l71, l72, l73, l74, l75, l76, l77, l78, l79, l80, l81, l82, l83, l84, l85, l86, l87, l88, l89, l90, l91, l92, l93, l94, l95, l96, l97, l98, l99, l100, l101, l102, l103, l104, l105, l106, l107, l108, l109, l110, l111, l112, l113, l114, l115, l116, l117, l118, l119, l120, l121, l122, l123, l124, l125, l126, l127, l128, l129, l130, l131, l132, l133, l134, l135, l136, l137, l138, l139, l140, l141, l142, l143, l144, l145, l146, l147, l148, l149, l150, l151, l152, l153, l154, l155, l156, l157, l158, l159, l160, l161, l162, l163, l164, l165, l166, l167, l168, l169, l170, l171, l172, l173, l174, l175, l176, l177, l178, l179, l180, l181, l182, l183, l184, l185, l186, l187, l188, l189, l190, l191, l192, l193, l194, l195, l196

for <!x!> in _ do end
]]
{
    type = 'LOCAL_LIMIT',
}

TEST [[
local l1, l2, l3, l4, l5, l6, l7, l8, l9, l10, l11, l12, l13, l14, l15, l16, l17, l18, l19, l20, l21, l22, l23, l24, l25, l26, l27, l28, l29, l30, l31, l32, l33, l34, l35, l36, l37, l38, l39, l40, l41, l42, l43, l44, l45, l46, l47, l48, l49, l50, l51, l52, l53, l54, l55, l56, l57, l58, l59, l60, l61, l62, l63, l64, l65, l66, l67, l68, l69, l70, l71, l72, l73, l74, l75, l76, l77, l78, l79, l80, l81, l82, l83, l84, l85, l86, l87, l88, l89, l90, l91, l92, l93, l94, l95, l96, l97, l98, l99, l100, l101, l102, l103, l104, l105, l106, l107, l108, l109, l110, l111, l112, l113, l114, l115, l116, l117, l118, l119, l120, l121, l122, l123, l124, l125, l126, l127, l128, l129, l130, l131, l132, l133, l134, l135, l136, l137, l138, l139, l140, l141, l142, l143, l144, l145, l146, l147, l148, l149, l150, l151, l152, l153, l154, l155, l156, l157, l158, l159, l160, l161, l162, l163, l164, l165, l166, l167, l168, l169, l170, l171, l172, l173, l174, l175, l176, l177, l178, l179, l180, l181, l182, l183, l184, l185, l186, l187, l188, l189, l190, l191, l192, l193, l194, l195

for x in _ do end
]]
(nil)

Version = 'Lua 5.1'

TEST [[
local l1, l2, l3, l4, l5, l6, l7, l8, l9, l10, l11, l12, l13, l14, l15, l16, l17, l18, l19, l20, l21, l22, l23, l24, l25, l26, l27, l28, l29, l30, l31, l32, l33, l34, l35, l36, l37, l38, l39, l40, l41, l42, l43, l44, l45, l46, l47, l48, l49, l50, l51, l52, l53, l54, l55, l56, l57, l58, l59, l60, l61, l62, l63, l64, l65, l66, l67, l68, l69, l70, l71, l72, l73, l74, l75, l76, l77, l78, l79, l80, l81, l82, l83, l84, l85, l86, l87, l88, l89, l90, l91, l92, l93, l94, l95, l96, l97, l98, l99, l100, l101, l102, l103, l104, l105, l106, l107, l108, l109, l110, l111, l112, l113, l114, l115, l116, l117, l118, l119, l120, l121, l122, l123, l124, l125, l126, l127, l128, l129, l130, l131, l132, l133, l134, l135, l136, l137, l138, l139, l140, l141, l142, l143, l144, l145, l146, l147, l148, l149, l150, l151, l152, l153, l154, l155, l156, l157, l158, l159, l160, l161, l162, l163, l164, l165, l166, l167, l168, l169, l170, l171, l172, l173, l174, l175, l176, l177, l178, l179, l180, l181, l182, l183, l184, l185, l186, l187, l188, l189, l190, l191, l192, l193, l194, l195, l196, l197

for <!x!> in _ do end
]]
{
    type = 'LOCAL_LIMIT',
}

TEST [[
local l1, l2, l3, l4, l5, l6, l7, l8, l9, l10, l11, l12, l13, l14, l15, l16, l17, l18, l19, l20, l21, l22, l23, l24, l25, l26, l27, l28, l29, l30, l31, l32, l33, l34, l35, l36, l37, l38, l39, l40, l41, l42, l43, l44, l45, l46, l47, l48, l49, l50, l51, l52, l53, l54, l55, l56, l57, l58, l59, l60, l61, l62, l63, l64, l65, l66, l67, l68, l69, l70, l71, l72, l73, l74, l75, l76, l77, l78, l79, l80, l81, l82, l83, l84, l85, l86, l87, l88, l89, l90, l91, l92, l93, l94, l95, l96, l97, l98, l99, l100, l101, l102, l103, l104, l105, l106, l107, l108, l109, l110, l111, l112, l113, l114, l115, l116, l117, l118, l119, l120, l121, l122, l123, l124, l125, l126, l127, l128, l129, l130, l131, l132, l133, l134, l135, l136, l137, l138, l139, l140, l141, l142, l143, l144, l145, l146, l147, l148, l149, l150, l151, l152, l153, l154, l155, l156, l157, l158, l159, l160, l161, l162, l163, l164, l165, l166, l167, l168, l169, l170, l171, l172, l173, l174, l175, l176, l177, l178, l179, l180, l181, l182, l183, l184, l185, l186, l187, l188, l189, l190, l191, l192, l193, l194, l195, l196

for x in _ do end
]]
(nil)

TEST [[
local l1, l2, l3, l4, l5, l6, l7, l8, l9, l10, l11, l12, l13, l14, l15, l16, l17, l18, l19, l20, l21, l22, l23, l24, l25, l26, l27, l28, l29, l30, l31, l32, l33, l34, l35, l36, l37, l38, l39, l40, l41, l42, l43, l44, l45, l46, l47, l48, l49, l50, l51, l52, l53, l54, l55, l56, l57, l58, l59, l60, l61, l62, l63, l64, l65, l66, l67, l68, l69, l70, l71, l72, l73, l74, l75, l76, l77, l78, l79, l80, l81, l82, l83, l84, l85, l86, l87, l88, l89, l90, l91, l92, l93, l94, l95, l96, l97, l98, l99, l100, l101, l102, l103, l104, l105, l106, l107, l108, l109, l110, l111, l112, l113, l114, l115, l116, l117, l118, l119, l120, l121, l122, l123, l124, l125, l126, l127, l128, l129, l130, l131, l132, l133, l134, l135, l136, l137, l138, l139, l140, l141, l142, l143, l144, l145, l146, l147, l148, l149, l150, l151, l152, l153, l154, l155, l156, l157, l158, l159, l160, l161, l162, l163, l164, l165, l166, l167, l168, l169, l170, l171, l172, l173, l174, l175, l176, l177, l178, l179, l180, l181, l182, l183, l184, l185, l186, l187, l188, l189, l190, l191, l192, l193, l194, l195, l196, l197, l198, l199, l200

_ENV = nil
]]
(nil)

TEST [[
local l1, l2, l3, l4, l5, l6, l7, l8, l9, l10, l11, l12, l13, l14, l15, l16, l17, l18, l19, l20, l21, l22, l23, l24, l25, l26, l27, l28, l29, l30, l31, l32, l33, l34, l35, l36, l37, l38, l39, l40, l41, l42, l43, l44, l45, l46, l47, l48, l49, l50, l51, l52, l53, l54, l55, l56, l57, l58, l59, l60, l61, l62, l63, l64, l65, l66, l67, l68, l69, l70, l71, l72, l73, l74, l75, l76, l77, l78, l79, l80, l81, l82, l83, l84, l85, l86, l87, l88, l89, l90, l91, l92, l93, l94, l95, l96, l97, l98, l99, l100, l101, l102, l103, l104, l105, l106, l107, l108, l109, l110, l111, l112, l113, l114, l115, l116, l117, l118, l119, l120, l121, l122, l123, l124, l125, l126, l127, l128, l129, l130, l131, l132, l133, l134, l135, l136, l137, l138, l139, l140, l141, l142, l143, l144, l145, l146, l147, l148, l149, l150, l151, l152, l153, l154, l155, l156, l157, l158, l159, l160, l161, l162, l163, l164, l165, l166, l167, l168, l169, l170, l171, l172, l173, l174, l175, l176, l177, l178, l179, l180, l181, l182, l183, l184, l185, l186, l187, l188, l189, l190, l191, l192, l193, l194, l195, l196, l197, l198, l199, l200

local <!_ENV!> = nil
]]
{
    type = 'LOCAL_LIMIT',
}

Version = 'Lua 5.4'

TEST [[
local x <const<!>=!> 1
]]
{
    multi = 1,
    type = 'MISS_SPACE_BETWEEN',
}

TEST [[
function mt<!['']!>() end
]]
{
    type = 'INDEX_IN_FUNC_NAME'
}

TEST [[
function mt<![]!>() end
]]
{
    multi = 2,
    type  = 'INDEX_IN_FUNC_NAME'
}

Version = 'Lua 5.4'
TEST [[
goto<!!> = 1
]]
{
    multi = 1,
    type  = 'MISS_NAME'
}

Version = 'Lua 5.1'
TEST [[
goto = 1
]]
(nil)

TEST [[
return {
    function () end
}
]]
(nil)

TEST [[
<!return 1!>
print(1)
]]
{
    type = 'ACTION_AFTER_RETURN',
}

TEST [[
<!return 1!>
return 1
]]
{
    type = 'ACTION_AFTER_RETURN',
}

TEST [[
f
<!()!>
]]
{
    type = 'AMBIGUOUS_SYNTAX',
}

TEST [[
f:xx
<!()!>
]]
{
    type = 'AMBIGUOUS_SYNTAX',
}

TEST [[
f
<!()!>
.x = 1
]]
{
    type = 'AMBIGUOUS_SYNTAX',
}

TEST [===[
print [[
<![[!>
]]
]===]
{
    type = 'NESTING_LONG_MARK',
}

TEST [===[
print [[
<![[!>
]]
]===]
{
    type = 'NESTING_LONG_MARK',
}

TEST [===[
print [=[
[=[
]=]
]===]
(nil)

TEST [===[
print [=[
[=[
]=]
]===]
(nil)

TEST [===[
print [[]]
print [[]]
]===]
(nil)

Version = 'Lua 5.4'
TEST [===[
print [[
[[
]]
]===]
(nil)

TEST [===[
print [[
[[
]]
]===]
(nil)

Version = 'Lua 5.4'

TEST [[
f
''
]]
(nil)

TEST [[
f
{}
]]
(nil)

TEST '\v\f'
(nil)

TEST [=[
print(<![[]]!>:gsub())
]=]
{
    type = 'NEED_PAREN',
}

TEST [=[
print(<!''!>:gsub())
]=]
{
    type = 'NEED_PAREN',
}

TEST [=[
print(<!""!>:gsub())
]=]
{
    type = 'NEED_PAREN',
}

TEST [=[
print(<!{}!>:gsub())
]=]
{
    type = 'NEED_PAREN',
}

TEST [[
local t = ''
(function () end)()
]]
(nil)

TEST [[
local t = ""
(function () end)()
]]
(nil)

TEST [[
local t = {}
(function () end)()
]]
(nil)

TEST [=[
local t = [[]]
(function () end)()
]=]
(nil)

TestWith 'LuaJIT' [[
goto LABEL
::LABEL::
]]
(nil)

TestWith 'LuaJIT' [[
local goto = 1
]]
(nil)

TestWith 'LuaJIT' [[
local goto]]
(nil)

TestWith 'LuaJIT' [[
f(1, goto, 2)
]]
(nil)

TestWith 'LuaJIT' [[
local function f(x, goto, y) end
]]
(nil)

Version = 'Lua 5.5'

TEST [[
global <!<close>!> x
]]
{
    type = 'GLOBAL_CLOSE_ATTRIBUTE',
}

TEST [[
global <const> x = 1
<!x!> = 2
]]
{
    type = 'ASSIGN_CONST_GLOBAL',
}

TEST [[
global <const> *
<!x!> = 1
]]
{
    type = 'ASSIGN_CONST_GLOBAL',
}

TEST [[
global x
<!y!> = 1
]]
{
    type = 'VARIABLE_NOT_DECLARED',
}

TEST [[
global *
x = 1
]]
(nil)

TEST [[
global function f() end
]]
(nil)

TEST [[
global x, y = 1, 2
]]
(nil)

TEST [[
global <const> x = 1
]]
(nil)

-- Shadowing rules (Lua 5.5): local variables shadow globals within lexical scope

TEST [[
global x
local x = 1
x = 2
]]
(nil)

TEST [[
global x
do
    local x = 1
    x = 2
end
]]
(nil)

TEST [[
global <const> x = 1
local x = 2
x = 3
]]
(nil)

TEST [[
global <const> *
local x = 1
x = 2
]]
(nil)

TEST [[
global x
function <!f!>()
    local x
    x = 1
end
]]
{
    type = 'VARIABLE_NOT_DECLARED',
}

-- Still error when assigning to truly undefined name under strict global scope
TEST [[
global x
do
    <!y!> = 1
end
]]
{
    type = 'VARIABLE_NOT_DECLARED',
}

TEST [[
global X <const> = 1
global X

X = 2
]]
(nil)

TEST [[
global X

do
    global X <const> = 1
end

X = 2
]]
(nil)

TEST [[
do
    global X
    <!Y!> = 1
end

Y = 1
]]
{
    type = 'VARIABLE_NOT_DECLARED',
}

TEST [[
global *

do
    global X
    do
        global X <const> = 10
        <!X!> = 1
        Y = 1
    end
    X = 1
end

Y = 1
]]
{
    type = 'ASSIGN_CONST_GLOBAL',
}

TEST [[
global x, y, z = 1, 2, 3

local n = x + y + z
]]
(nil)

TEST [[
global function f()
    <!print!>(1)
end
]]
{
    type = 'VARIABLE_NOT_DECLARED',
}
