print('[feature.diagnostic.undefined-doc-name] 测试中...')

TEST_DIAGNOSTIC [[
---@type <?A?>
]] { 'undefined-doc-name' }

TEST_DIAGNOSTIC [[
---@class A
---@type A|<?B?>|<?C?>
]] { 'undefined-doc-name', 'undefined-doc-name' }

TEST_DIAGNOSTIC [[
---@class AAA
---@alias B AAA
---@type B
]] {}

TEST_DIAGNOSTIC [[
---@alias B <?AAA?>
]] { 'undefined-doc-name' }

TEST_DIAGNOSTIC [[
---@type number
]] {}

TEST_DIAGNOSTIC [[
---@class Container<T>
local Container = {}

---@return T[]
function Container:getAll()
    return {}
end
]] {}

TEST_DIAGNOSTIC [[
---@class Map<K, V>
local Map = {}

---@param key K
---@return V
function Map:get(key)
end
]] {}

TEST_DIAGNOSTIC [[
---@class Container<T>
local Container = {}

---@return <!UndefinedType!>
function Container:getBad()
    return {}
end
]] { 'undefined-doc-name' }

print('[feature.diagnostic.undefined-doc-name] 测试完毕')