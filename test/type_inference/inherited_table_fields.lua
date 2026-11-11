-- Issue #3443: fields declared in an anonymous table base survive inheritance.
TEST 'boolean|string' [[
---@alias UnionBase<T> { value: T }|{ value: boolean }
---@class Specific: UnionBase<string>
---@type Specific
local t
local <?value?> = t.value
]]

TEST 'boolean|string' [[
---@alias UnionBase { value: string }|{ value: boolean }
---@type UnionBase
local t
local <?value?> = t.value
]]

TEST 'boolean|string' [[
---@alias UnionBase { value: string }|{ value: boolean }
---@class Specific: UnionBase
---@type Specific
local t
local <?value?> = t.value
]]

TEST 'unknown' [[
---@class Recursive: Recursive
---@type Recursive
local t
local <?value?> = t.value
]]

TEST 'boolean' [[
---@class GenericSuper<T>: { value: T }
---@field value boolean
---@class Specific: GenericSuper<string>
---@type Specific
local t
local <?value?> = t.value
]]

TEST 'string' [[
---@class First
---@field value string
---@class Second
---@field value boolean
---@class Specific: First, Second
---@type Specific
local t
local <?value?> = t.value
]]

TEST 'string' [[
---@class First: { value: string }
---@class Second: { value: boolean }
---@class Specific: First, Second
---@type Specific
local t
local <?value?> = t.value
]]

TEST 'string' [[
---@class First: Second
---@class Second: First, { value: string }
---@type First
local t
local <?value?> = t.value
]]

TEST 'string' [[
---@class GenericSuper<T>: { value: T }
---@class Specific: GenericSuper<string>
---@class Grandchild: Specific
---@type Grandchild
local t
local <?value?> = t.value
]]

TEST 'string' [[
---@class GenericSuper<T>: { value: T }
---@class Specific: GenericSuper<string>
---@type Specific
local t
local <?value?> = t.value
]]

TEST 'boolean' [[
---@class Container<K, V>: { key: K, value: V }
---@class Specific: Container<string, boolean>
---@type Specific
local t
local <?value?> = t.value
]]

TEST 'string' [[
---@class Container<K, V>: { key: K, value: V }
---@class Specific: Container<string, boolean>
---@type Specific
local t
local <?key?> = t.key
]]

TEST 'string[]' [[
---@class GenericSuper<T>: { values: T[] }
---@class Specific: GenericSuper<string>
---@type Specific
local t
local <?values?> = t.values
]]

TEST 'string?' [[
---@class Base: { value?: string }
---@class Specific: Base
---@type Specific
local t
local <?value?> = t.value
]]

TEST 'string' [[
---@class GenericSuper<T>: { [integer]: T }
---@class Specific: GenericSuper<string>
---@type Specific
local t
local <?value?> = t[1]
]]

TEST 'integer' [[
---@class GenericSuper<T>: { value: T }
---@class StringChild: GenericSuper<string>
---@class IntegerChild: GenericSuper<integer>
---@type StringChild
local a
local value = a.value
---@type IntegerChild
local b
local <?value?> = b.value
]]

TEST 'string' [[
---@class Base: { value: string }
---@class Child: Base
---@class Grandchild: Child
---@type Grandchild
local t
local <?value?> = t.value
]]

TEST 'boolean' [[
---@class GenericSuper<T>: { value: T }
---@class Specific: GenericSuper<string>
---@field value boolean
---@type Specific
local t
local <?value?> = t.value
]]

TEST 'string' [[
---@class GenericSuper<T>: { value: T }
---@type GenericSuper<string>
local t
local <?value?> = t.value
]]
