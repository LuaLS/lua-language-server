
-- Test @type field declaration with method override
TEST 'Buff' [[
---@class Buff
local mt = {}
---@type (fun(self: Buff, target: Buff): boolean)?
mt.on_cover = nil

---@class Buff.CommandAura : Buff
local tpl = {}
function tpl:on_cover(<?target?>)
    return true
end
]]

-- Test @field declaration with method override
TEST 'Animal' [[
---@class Animal
---@field can_eat (fun(self: Animal, other: Animal): boolean)?
local base = {}

---@class Dog : Animal
local dog = {}
function dog:can_eat(<?other?>)
    return true
end
]]

-- Test optional method with @type
TEST 'string' [[
---@class Base
local base = {}
---@type (fun(self: Base, x: string): number)?
base.callback = nil

---@class Child : Base
local child = {}
function child:callback(<?x?>)
    return 1
end
]]

-- Test non-optional @field
TEST 'number' [[
---@class Handler
---@field process fun(self: Handler, value: number): string
local handler = {}

---@class CustomHandler : Handler
local custom = {}
function custom:process(<?value?>)
    return tostring(value)
end
]]

-- Test multiple parameters with @type
TEST 'string' [[
---@class Processor
local proc = {}
---@type fun(self: Processor, a: number, b: string): boolean
proc.handle = nil

---@class MyProcessor : Processor
local my = {}
function my:handle(a, <?b?>)
    return true
end
]]
