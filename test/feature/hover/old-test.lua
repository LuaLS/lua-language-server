---@diagnostic disable

local core       = require 'core.hover'
local files      = require 'files'
local catch      = require 'catch'
local config     = require 'config'

rawset(_G, 'TEST', true)

---@diagnostic disable: await-in-sync
function TEST(script)
    return function (expect)
        local newScript, catched = catch(script, '?')
        files.setText(TESTURI, newScript)
        local hover = core.byUri(TESTURI, catched['?'][1][1], 1)
        assert(hover)
        expect = expect:gsub('^[\r\n]*(.-)[\r\n]*$', '%1'):gsub('\r\n', '\n')
        local label = hover:string():gsub('\r\n', '\n'):match('```lua[\r\n]*(.-)[\r\n]*```')
        assert(expect == label)
        files.remove(TESTURI)
    end
end

config.set(nil, 'Lua.hover.previewFields', 50)

-- [MIGRATED] basic function label cases moved to test.feature.hover.basic

-- [MIGRATED] method label cases moved to test.feature.hover.basic

--TEST [[
--local mt = {}
--mt.__index = mt
--mt.type = 'Class'
--
--function mt:init(a, b, c)
--    return
--end
--
--local obj = setmetatable({}, mt)
--
--obj:<?init?>(1, '测试')
--]]
--[[
--function Class:init(a: any, b: any, c: any)
--]]

--TEST [[
--local mt = {}
--mt.__index = mt
--mt.__name = 'Class'
--
--function mt:init(a, b, c)
--    return
--end
--
--local obj = setmetatable({}, mt)
--
--obj:<?init?>(1, '测试')
--]]
--[[
--function Class:init(a: any, b: any, c: any)
--]]

-- [MIGRATED] method return and obj.init call cases moved to test.feature.hover.basic

-- [MIGRATED] basic variable/field label cases moved to test.feature.hover.basic

--TEST [[
--local mt = {}
--mt.__name = 'class'
--
--local <?obj?> = setmetatable({}, mt)
--]]
--"local obj: class {}"

--TEST [[
--local mt = {}
--mt.name = 'class'
--mt.__index = mt
--
--local <?obj?> = setmetatable({}, mt)
--]]
--[[
--local obj: class {
--    __index: table,
--    name: string = "class",
--}
--]]

--TEST [[
--local mt = {}
--mt.TYPE = 'class'
--mt.__index = mt
--
--local <?obj?> = setmetatable({}, mt)
--]]
--[[
--local obj: class {
--    TYPE: string = "class",
--    __index: table,
--}
--]]

--TEST [[
--local mt = {}
--mt.Class = 'class'
--mt.__index = mt
--
--local <?obj?> = setmetatable({}, mt)
--]]
--[[
--local obj: class {
--    Class: string = "class",
--    __index: table,
--}
--]]

-- TODO 支持自定义的函数库
--TEST[[
--local fs = require 'bee.filesystem'
--local <?root?> = fs.current_path()
--]]
--"local root: bee::filesystem"

TEST [[
<?print?>()
]]
[[
function print(...any)
]]

TEST [[
string.<?sub?>()
]]
[[
function string.sub(s: string|number, i: integer, j?: integer)
    -> string
]]

TEST[[
('xx'):<?sub?>()
]]
[[function string.sub(s: string|number, i: integer, j?: integer)
    -> string]]

TEST [[
local <?v?> = collectgarbage()
]]
"local v: nil"

-- [MIGRATED] local type / w2l:get_default()[<?type?>] unknown hover case moved to test.feature.hover.basic

TEST [[
<?load?>()
]]
[=[
function load(chunk: string|function, chunkname?: string, mode?: "b"|"bt"|"t", env?: table)
    -> function?
    2. error_message: string?
]=]

TEST [[
string.<?lower?>()
]]
[[
function string.lower(s: string|number)
  -> string
]]

-- [MIGRATED] vararg function label case moved to test.feature.hover.basic

-- [MIGRATED] local function x() label case moved to test.feature.hover.basic

-- [MIGRATED] local mt / function mt:add / init() return mt / t:add() hover case moved to test.feature.hover.basic

-- [MIGRATED] local mt / function mt:add / init() return mt / t:add() hover case moved to test.feature.hover.basic
-- (not migrated: setmetatable version — setmetatable is stdlib, unavailable in test scope)

-- [MIGRATED] local integer literal label case moved to test.feature.hover.basic

-- TODO 暂不支持
--TEST [[
--for <?c?> in io.lines() do
--end
--]]
--[[local c: string]]

-- [MIGRATED] vararg return unknown label case moved to test.feature.hover.basic

-- [MIGRATED] table.unpack unknown label case moved to test.feature.hover.basic

-- [MIGRATED] unknown local label case moved to test.feature.hover.basic

-- [MIGRATED] local s = <?'abc中文'?> string literal hover case moved to test.feature.hover.basic

-- [MIGRATED] local n = <?0xff?> integer literal hover case moved to test.feature.hover.basic

-- [MIGRATED] local t={a=1,b=2,c=3} hover case moved to test.feature.hover.basic

-- [MIGRATED] local t={} t.a=1 t.a=true union field hover case moved to test.feature.hover.basic

-- [MIGRATED] mixed-key table hover case moved to test.feature.hover.basic

TEST [[
local <?t?> = {}
t[#t+1] = 1
t[#t+1] = 1

local any = collectgarbage()
t[any] = any
]]
[[
local t: table
]]

-- [MIGRATED] local alias integer label case moved to test.feature.hover.basic

-- [MIGRATED] setmetatable({},{__index=mt}) mt.a/b/c fields hover case moved to test.feature.hover.basic (result with --!include setmetatable: local obj: {\n    a: 1,\n    b: 2,\n    c: 3,\n})

-- [MIGRATED] mt.__index={} self:test() hover case moved to test.feature.hover.basic

-- [MIGRATED] setmetatable({id=1},mt) mt.__index/mt.__name/mt:remove hover case moved to test.feature.hover.basic (result with --!include setmetatable: local self: { id: 1 } & { remove: fun(self: { ... }), __index: { ... }, __name: "obj" })

TEST [[
print(<?utf8?>)
]]
[[
(global) utf8: utf8lib {
    char: function,
    charpattern: string,
    codepoint: function,
    codes: function,
    len: function,
    offset: function,
}
]]

TEST [[
print(io.<?stderr?>)
]]
[[
(global) io.stderr: file* {
    close: function,
    flush: function,
    lines: function,
    read: function,
    seek: function,
    setvbuf: function,
    write: function,
}
]]

TEST [[
print(<?io?>)
]]
[[
(global) io: iolib {
    close: function,
    flush: function,
    input: function,
    lines: function,
    open: function,
    output: function,
    popen: function,
    read: function,
    stderr: file*,
    stdin: file*,
    stdout: file*,
    tmpfile: function,
    type: function,
    write: function,
}
]]

TEST [[
local <?sssss?> = require 'utf8'
]]
[[
local sssss: utf8lib {
    char: function,
    charpattern: string,
    codepoint: function,
    codes: function,
    len: function,
    offset: function,
}
]]

-- [MIGRATED] repeated global function label case moved to test.feature.hover.basic

-- 不根据参数推断
--TEST[[
--function a(v)
--    print(<?v?>)
--end
--a(1)
--]]
--[[
--local v: number = 1
--]]
--
--TEST[[
--function a(v)
--    print(<?v?>)
--end
--pcall(a, 1)
--]]
--[[
--local v: number = 1
--]]

--TEST[[
--function a(v)
--    print(<?v?>)
--end
--xpcall(a, log.error, 1)
--]]
--[[
--local v: number = 1
--]]

-- [MIGRATED] function return string label case moved to test.feature.hover.basic

TEST[[
function a(v)
    return 'a'
end
local _, <?r?> = pcall(a, 1)
]]
[[
local r: string = 'a'
]]

TEST[[
local <?n?> = rawlen()
]]
[[
local n: integer
]]

-- [MIGRATED] local x = '\a' escape sequence hover case moved to test.feature.hover.basic

-- [MIGRATED] local t={b=1,...,l=11} 11-field table hover case moved to test.feature.hover.basic

-- [MIGRATED] multi-return nil function label case moved to test.feature.hover.basic

-- [MIGRATED] local nil from function call label case moved to test.feature.hover.basic

-- [MIGRATED] function return integer|nil label case moved to test.feature.hover.basic

-- [MIGRATED] local table hover case with local read moved to test.feature.hover.basic

-- [MIGRATED] local table hover case with global write moved to test.feature.hover.basic

-- [MIGRATED] self method label case moved to test.feature.hover.basic
-- [MIGRATED] orphan legacy field label snippet removed: (field) t.v table shape case

TEST [[
local <?t?> = {
    f = io.open(),
}
]]
[[
local t: {
    f?: file*,
}
]]

TEST [[
io.<?popen?>()
]]
[[
function io.popen(prog: string, mode?: "r"|"w")
  -> file*?
  2. errmsg: string?
]]

TEST [[
<?_G?>
]]
[[
(global) _G: _G {
    arg: string[],
    assert: function,
    collectgarbage: function,
    coroutine: coroutinelib,
    debug: debuglib,
    dofile: function,
    error: function,
    getfenv: function,
    getmetatable: function,
    io: iolib,
    ipairs: function,
    load: function,
    loadfile: function,
    loadstring: function,
    math: mathlib,
    module: function,
    newproxy: function,
    next: function,
    os: oslib,
    package: packagelib,
    pairs: function,
    pcall: function,
    print: function,
    rawequal: function,
    rawget: function,
    rawlen: function,
    rawset: function,
    require: function,
    select: function,
    setfenv: function,
    setmetatable: function,
    string: stringlib,
    table: tablelib,
    tonumber: function,
    tostring: function,
    type: function,
    unpack: function,
    utf8: utf8lib,
    warn: function,
    xpcall: function,
    _G: _G,
    _VERSION: string = "Lua 5.4",
}
]]

-- [MIGRATED] string-array table hover case moved to test.feature.hover.basic

-- [MIGRATED] local x number union-with-literal hover case moved to test.feature.hover.basic

-- [MIGRATED] local <close> declaration hover case moved to test.feature.hover.basic

-- [MIGRATED] local <close> usage hover case moved to test.feature.hover.basic

--TEST [[
--local function <?a?>(b)
--    return (b.c and a(b.c) or b)
--end
--]]
--[[
--function a(b: table)
--  -> table
--]]

-- [MIGRATED] boolean-key table construction hover case moved to test.feature.hover.basic

-- [MIGRATED] numeric-key table hover case moved to test.feature.hover.basic

-- [MIGRATED] class() local/global/field hover cases moved to test.feature.hover.basic
-- [MIGRATED] duplicated class() local/global hover cases removed from old-test

-- [MIGRATED] union class() hover case moved to test.feature.hover.basic

-- [MIGRATED] @class Class + literal table local hover case moved to test.feature.hover.basic

-- [MIGRATED] annotated parameter declaration hover case moved to test.feature.hover.basic

-- [MIGRATED] annotated parameter usage hover case moved to test.feature.hover.basic

-- [MIGRATED] for-in pairs key annotation hover case moved to test.feature.hover.basic

-- [MIGRATED] for-in pairs value annotation hover case moved to test.feature.hover.basic

-- [MIGRATED] annotated multi-return function hover case moved to test.feature.hover.basic

-- [MIGRATED] generic function signature hover case moved to test.feature.hover.basic

-- [MIGRATED] annotated local return hover case moved to test.feature.hover.basic

-- [MIGRATED] generic function return hover case moved to test.feature.hover.basic

-- [MIGRATED] annotated function signature hover case moved to test.feature.hover.basic

-- [MIGRATED] @vararg Class local _, x = ... hover case moved to test.feature.hover.basic
-- [MIGRATED] @vararg Class local t = {...} (no call) hover case moved to test.feature.hover.basic
-- [MIGRATED] @vararg Class local t = {...} t[1] hover case moved to test.feature.hover.basic
-- [MIGRATED] @vararg Class local t = {...} (with call) hover case moved to test.feature.hover.basic
-- [MIGRATED] @param ... Class local _, x = ... hover case moved to test.feature.hover.basic
-- [MIGRATED] @param ... Class local t = {...} t[1] hover case moved to test.feature.hover.basic
-- [MIGRATED] @param ... Class local t = {...} (with call) hover case moved to test.feature.hover.basic

-- [MIGRATED] string-array type declaration hover case moved to test.feature.hover.basic

-- [MIGRATED] union string-array type declaration hover case moved to test.feature.hover.basic

-- [MIGRATED] string-array index hover case moved to test.feature.hover.basic

-- TODO
--TEST [[
-----@type string[]
--local t
--for _, <?x?> in ipairs(t) do
--end
--]]
--[[
--local x: string
--]]

--TEST [[
-----@type string[]
--local t
--for _, <?x?> in pairs(t) do
--end
--]]
--[[
--local x: string
--]]

--TEST [[
-----@type string[]
--local t
--for <?k?>, v in pairs(t) do
--end
--]]
--[[
--local k: integer
--]]

-- [MIGRATED] table<K,V> annotation hover case moved to test.feature.hover.basic

-- [MIGRATED] [ClassA,ClassB] tuple annotation hover case moved to test.feature.hover.basic

--TEST [[
-----@class ClassA
-----@class ClassB
--
-----@type table<ClassA, ClassB>
--local t
--for _, <?x?> in pairs(t) do
--end
--]]
--[[
--local x: ClassB
--]]

--TEST [[
-----@class ClassA
-----@class ClassB
--
-----@type table<ClassA, ClassB>
--local t
--for <?k?>, v in pairs(t) do
--end
--]]
--[[
--local k: ClassA
--]]

-- [MIGRATED] fun-typed local declaration hover case moved to test.feature.hover.basic

-- [MIGRATED] fun-typed local return hover case moved to test.feature.hover.basic

-- [MIGRATED] fun():void parameter annotation hover case moved to test.feature.hover.basic

-- [MIGRATED] fun-typed field method hover case moved to test.feature.hover.basic

-- [MIGRATED] @param names string[] parameter hover case moved to test.feature.hover.basic

-- [MIGRATED] @return any function declaration hover case moved to test.feature.hover.basic
-- [MIGRATED] @return any local x=f() hover case moved to test.feature.hover.basic

-- [MIGRATED] @overload function hover case moved to test.feature.hover.basic

-- [MIGRATED] fun(x?:boolean):boolean? local declaration hover case moved to test.feature.hover.basic

-- [MIGRATED] optional-param multi-return function hover case moved to test.feature.hover.basic

-- [MIGRATED] named-return function hover case moved to test.feature.hover.basic

-- [MIGRATED] @class+@field local hover case moved to test.feature.hover.basic

-- [MIGRATED] @class A annotation type hover case moved to test.feature.hover.basic

-- [MIGRATED] string|enum literal union hover case moved to test.feature.hover.basic

-- [MIGRATED] @alias A / @type A annotation hover case moved to test.feature.hover.basic

-- [MIGRATED] @alias A / @type A local hover case moved to test.feature.hover.basic

-- [MIGRATED] multiline union annotation hover case moved to test.feature.hover.basic

-- [MIGRATED] @class c + @overload global table hover case moved to test.feature.hover.basic

-- [MIGRATED] @class c + @overload local function field hover case moved to test.feature.hover.basic

-- [MIGRATED] @class c + @overload t.f() global function hover case moved to test.feature.hover.basic

-- [MIGRATED] @class C @field / @type C local hover case moved to test.feature.hover.basic
-- [MIGRATED] @class C @field / @return C local hover case moved to test.feature.hover.basic

-- [MIGRATED] @param callback fun(x:integer,...) hover case moved to test.feature.hover.basic

-- [MIGRATED] trailing-annotation local hover case moved to test.feature.hover.basic
-- [MIGRATED] trailing-annotation second local undefined hover case moved to test.feature.hover.basic

-- [MIGRATED] @class Object @field a / @type Object[] index hover case moved to test.feature.hover.basic

-- [MIGRATED] @class Object @field a / @type Object[] t[i] hover case moved to test.feature.hover.basic

-- [MIGRATED] @class C @field x / @generic T assert(t) hover case moved to test.feature.hover.basic

-- [MIGRATED] local x--comment inline hover case moved to test.feature.hover.basic

-- [MIGRATED] @type unknown local t; t.a=1 hover case moved to test.feature.hover.basic

-- [MIGRATED] @return number / u=f(); u.x hover case moved to test.feature.hover.basic

-- [MIGRATED] @generic K,V table<string,boolean> / next(<?t?>) hover case moved to test.feature.hover.basic

-- [MIGRATED] @class A..E inheritance / self:f() return <?self?> hover case moved to test.feature.hover.basic

-- [MIGRATED] local f / f() unknown hover case moved to test.feature.hover.basic

-- (not migrated: @class直接标注local variable在新框架不生效，t类型为unknown)

-- [MIGRATED] @type { x: string, y: number, z: boolean } inline local hover case moved to test.feature.hover.basic

-- [MIGRATED] <?a?>.b = 10 * 60 global table field hover case moved to test.feature.hover.basic
-- [MIGRATED] a.<?b?> = 10 * 60 global field value hover case moved to test.feature.hover.basic
-- [MIGRATED] a.<?b?>.c = 1 * 1 nested global field hover case moved to test.feature.hover.basic

-- [MIGRATED] mixed seq+hash table {'a','b','c',[10]='d',x='e',...} hover case moved to test.feature.hover.basic

-- [MIGRATED] function f1.f2.<?f3?>() nested function hover case moved to test.feature.hover.basic

-- [MIGRATED] local t = nil / t.<?x?>() nil field hover case moved to test.feature.hover.basic

--TEST [[
-----@class A
--local a
--
--local b
--b = a
--
--print(b.<?x?>)
--]]
--[[
--(field) A.x: unknown
--]]

-- [MIGRATED] @return nil function hover case moved to test.feature.hover.basic

-- [MIGRATED] @async local function hover case moved to test.feature.hover.basic

-- [MIGRATED] @type function local hover case moved to test.feature.hover.basic
-- [MIGRATED] @type async fun() local hover case moved to test.feature.hover.basic

-- [MIGRATED] nonstandardSymbol '//' local x = 1 // 2 hover case moved to test.feature.hover.basic
config.set(nil, 'Lua.runtime.nonstandardSymbol', {})

-- [MIGRATED] @alias uri expandAlias=false hover case moved to test.feature.hover.basic
-- [MIGRATED] @alias uri expandAlias=true hover case moved to test.feature.hover.basic

-- [MIGRATED] concat literal string hover case moved to test.feature.hover.basic

-- [MIGRATED] local t={x=1,[1]='x'} / local x=t[#t] index hover case moved to test.feature.hover.basic

-- [MIGRATED] local x={a=1,b=2,[1]=10} / local y={[1]=<?x?>} mixed-key table hover case moved to test.feature.hover.basic

-- [MIGRATED] local x={_x='',_y='',x='',y=''} table with underscores hover case moved to test.feature.hover.basic

-- [MIGRATED] @class A @field x / @class B: A @field y @type B local t hover case moved to test.feature.hover.basic

-- [MIGRATED] @class A @field x / @class B: A @field x integer @field y @type B local t hover case moved to test.feature.hover.basic

-- [MIGRATED] local x / local function f() x (outer scope hover) case moved to test.feature.hover.basic

-- [MIGRATED] local x / local function f() x (upvalue hover) case moved to test.feature.hover.basic

-- [MIGRATED] @type `123 ????` | ` x | y ` literal union hover case moved to test.feature.hover.basic

-- [MIGRATED] @type any local x / x.y field hover case moved to test.feature.hover.basic

-- [MIGRATED] @async x({}, function() end) hover case moved to test.feature.hover.basic

-- [MIGRATED] @overload f() f(0) f(0,0) resolution hover cases moved to test.feature.hover.basic

-- [MIGRATED] @class A / mt.x=1 mt.y=true / @type A local t hover case moved to test.feature.hover.basic

-- [MIGRATED] @param ... boolean @return number ... function f hover case moved to test.feature.hover.basic

-- [MIGRATED] @param ... boolean @return ... function f hover case moved to test.feature.hover.basic

-- [MIGRATED] @type fun():x: number local f hover case moved to test.feature.hover.basic

-- [MIGRATED] @type fun(...: boolean):...: number local f hover case moved to test.feature.hover.basic

-- [MIGRATED] @type fun():x: number, y: boolean local f hover case moved to test.feature.hover.basic

-- [MIGRATED] @class MyClass / MyClass:Test() self hover case moved to test.feature.hover.basic

-- [MIGRATED] local bool narrowing (bool and y) hover case moved to test.feature.hover.basic

-- [MIGRATED] @type 'a' local s hover case moved to test.feature.hover.basic

-- [MIGRATED] @enum A enum declaration hover case moved to test.feature.hover.basic

-- [MIGRATED] bitshift literal hover case moved to test.feature.hover.basic

-- [MIGRATED] test2() return test1() multi-return hover case moved to test.feature.hover.basic

-- [MIGRATED] @param x number @return boolean local function f(x) hover case moved to test.feature.hover.basic

-- [MIGRATED] @class A @field private x / @field y local hover case moved to test.feature.hover.basic

-- [MIGRATED] @class A @field private x / @field y / @type A local hover case moved to test.feature.hover.basic

-- [MIGRATED] @class A @field private x / @field y / global t = {} hover case moved to test.feature.hover.basic

-- [MIGRATED] @class A @field private x / @field y / @type A global t = {} hover case moved to test.feature.hover.basic

-- (not migrated) @class A @field private x @field y @type A v.t = {} -- field-access global

-- [MIGRATED] @class A @field private/protected/z @type A local hover case moved to test.feature.hover.basic

-- [MIGRATED] @class A @field private x @field protected y @field z / @class B: A local t hover case moved to test.feature.hover.basic

-- [MIGRATED] @class A ... @class B: A @field private a local t hover case moved to test.feature.hover.basic

-- [MIGRATED] @class A ... @class B: A @field private a @type B local t hover case moved to test.feature.hover.basic

-- [MIGRATED] @class A @private init @protected update @public get / print(mt) hover case moved to test.feature.hover.basic

-- [MIGRATED] @class A @private/@protected methods + @type A local obj hover case moved to test.feature.hover.basic

-- [MIGRATED] @class B: A with @private/@protected methods hover cases moved to test.feature.hover.basic

-- [MIGRATED] @class A @private M.x @private M:init @type A local a hover case moved to test.feature.hover.basic

-- [MIGRATED] @class A @field x fun():string table<string,A> obj[''].x() hover case moved to test.feature.hover.basic

-- [MIGRATED] @class A @field x number @see A.x hover case moved to test.feature.hover.basic

-- [MIGRATED] @type { [string]: string }[] local t / t.foo hover case moved to test.feature.hover.basic

-- [MIGRATED] local t={['x']=1,['y']=2} / t.y hover case moved to test.feature.hover.basic

-- [MIGRATED] local enum={a=1,b=2} / t={[enum.a]=true,...} hover case moved to test.feature.hover.basic

-- [MIGRATED] @class A @overload fun(x:number):boolean local x hover case moved to test.feature.hover.basic

-- [MIGRATED] @type A local f / @enum A local t={x=f} / f hover case moved to test.feature.hover.basic

-- [MIGRATED] @param a number @param b string @param ... boolean function f hover case moved to test.feature.hover.basic

-- [MIGRATED] Lua 5.5 global * hover case moved to test.feature.hover.basic
