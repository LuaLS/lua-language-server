-- @operator on generic classes: class type parameters resolve through
-- the instantiated sign (e.g. `Box<string>` + `call(): T?` -> `string?`).

-- Baseline: non-generic class (must keep working)
TEST 'string' [[
---@class Caller
---@operator call(): string
local c

local <?v?> = c()
]]

-- call(): T? on an explicit sign
TEST 'string?' [[
---@class Box<T>
---@operator call(): T?
local box

---@type Box<string>
local b

local <?v?> = b()
]]

-- Full chain: generic factory return + call operator
TEST 'string?' [[
---@class Box<T>
---@operator call(): T?

---@generic T
---@param items T[]
---@return Box<T>
local function make(items) end

local test = {} ---@type string[]
local b = make(test)
local <?v?> = b()
]]

-- Binary operator, generic in extends only
TEST 'string' [[
---@class Box<T>
---@operator add(Box): T
local box

---@type Box<string>
local b

local <?v?> = b + b
]]

-- Two type parameters
TEST 'integer' [[
---@class Pair<K, V>
---@operator call(): V
local pair

---@type Pair<string, integer>
local p

local <?v?> = p()
]]

-- Nested sign in the argument position
TEST 'Box<string>?' [[
---@class Box<T>
---@operator call(): T?
local box

---@type Box<Box<string>>
local b

local <?outer?> = b()
]]

-- Calling the nested result unwraps the inner parameter
TEST 'string?' [[
---@class Box<T>
---@operator call(): T?
local box

---@type Box<Box<string>>
local b

local outer = b()
local <?v?> = outer()
]]

-- Generic in the operand type of a binary operator
TEST 'string' [[
---@class Box<T>
---@operator add(Box<T>): T
local box

---@type Box<string>
local b

local <?v?> = b + b
]]

-- Signs on a non-generic class: no substitution, operator still works
TEST 'integer' [[
---@class Plain
---@operator call(): integer
local plain

---@type Plain<string>
local p

local <?v?> = p()
]]

-- Real-world shape: inherited generic class + factory function
TEST 'string?' [[
---@class UIObject

---@class SingleSelector<T> : UIObject
---@operator call(): T?
local SingleSelector

---@generic T
---@param items T[]
---@return SingleSelector<T>
local function AddSingleSelector(items) end

local test = {} ---@type string[]
local Items = AddSingleSelector(test)
local <?val?> = Items()
]]

-- Unparameterized reference: T stays unresolved and renders as a generic
-- (`<T>`), matching how unresolved function generics are displayed
TEST '<T>?' [[
---@class Box<T>
---@operator call(): T?
local box

---@type Box
local b

local <?v?> = b()
]]

-- Highlighting: sign names used in class annotations must be converted to
-- `doc.generic.name` by `bindGeneric`, so semantic tokens color them like
-- `@generic` parameters. The expected string lists every doc.generic.name
-- in the file (sign declarations included), sorted and comma-joined.
local files = require 'files'
local guide = require 'parser.guide'

local function TESTGENERICNAMES(expected)
    return function (script)
        files.setText(TESTURI, script)
        local state = files.getState(TESTURI)
        assert(state)
        local found = {}
        for _, doc in ipairs(state.ast.docs) do
            -- eachSource instead of eachSourceType: the latter's type cache
            -- is built during doc binding, before `bindGeneric` rewrites
            -- `doc.type.name` nodes into `doc.generic.name`
            guide.eachSource(doc, function (src)
                if src.type == 'doc.generic.name' then
                    found[#found+1] = src[1]
                end
            end)
        end
        table.sort(found)
        local got = table.concat(found, ',')
        assert(got == expected,
            ('doc.generic.name mismatch! Wanted: [%s] Got: [%s]')
            :format(expected, got))
        files.remove(TESTURI)
    end
end

-- Declaration <T> + usage in @field + usage in @operator; real types
-- (SingleSelectorModel) must stay doc.type.name
TESTGENERICNAMES 'T,T,T' [[
---@class SingleSelectorModel

---@class SingleSelector<T>
---@field Model SingleSelectorModel
---@field Default T
---@operator call(): T?
local SingleSelector
]]

-- Declarations <T> of both classes + usage in inheritance arguments
TESTGENERICNAMES 'T,T,T' [[
---@class Base<T>

---@class Child<T> : Base<T>
local Child
]]

-- No signs -> no generic names anywhere
TESTGENERICNAMES '' [[
---@class Plain
---@field x integer
---@operator call(): integer
local Plain
]]
