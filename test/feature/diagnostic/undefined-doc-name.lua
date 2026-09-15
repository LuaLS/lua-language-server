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

-- `falsy` 等预置名字在运行时是 union 类型，判定时不应按 type 节点处理（此前会抛错）
TEST_DIAGNOSTIC [[
---@param x falsy
local function f(x) end
]] { '-undefined-doc-name' }

-- `#` 描述里的 `|` 不应被当成类型的一部分
TEST_DIAGNOSTIC [[
---@param events integer # Event flags (SELECT_READ | SELECT_WRITE)
local function f(events) end
]] { '-undefined-doc-name' }

-- 反引号里的是字面名字（asCode），不参与类型解析
TEST_DIAGNOSTIC [[
---@param options? integer | `fs.copy_options.overwrite_existing`
local function f(options) end
]] { '-undefined-doc-name' }
