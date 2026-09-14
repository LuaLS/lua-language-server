test.scope.config:set(test.rootUri, 'Lua.runtime.version', 'Lua 5.5')

TEST_DIAGNOSTIC [[
---@type number
local <?x?> = 'str'
]] { 'assign-type-mismatch' }

TEST_DIAGNOSTIC [[
---@type number
local x = 1
]] { '-assign-type-mismatch' }

TEST_DIAGNOSTIC [[
---@type number?
local x = nil
]] { '-assign-type-mismatch' }

TEST_DIAGNOSTIC [[
---@type string
X = 1
]] { 'assign-type-mismatch' }

TEST_DIAGNOSTIC [[
---@type integer
local <?x?> = 1.5
]] { 'assign-type-mismatch' }

TEST_DIAGNOSTIC [[
---@type number
local x
<?x?> = 'str'
]] { 'assign-type-mismatch' }

-- 实际存在的字段仍要比较类型
TEST_DIAGNOSTIC [[
---@type { a: integer }
local <?t?> = 1
]] { 'assign-type-mismatch' }

TEST_DIAGNOSTIC [[
---@type { a: integer }[]
local vars = {
    { a = 'str' },
}
]] { 'assign-type-mismatch' }

-- Lua 5.5 命名不定长 `...args`：元素类型跟随 `---@param ... T`
TEST_DIAGNOSTIC [[
---@param ... string
local function f(...args)
    ---@type integer
    local <?s?> = args[1]
end
]] { 'assign-type-mismatch' }

TEST_DIAGNOSTIC [[
---@param ... string
local function f(...args)
    ---@type string
    local ok = args[1]
end
]] { '-assign-type-mismatch' }

-- `n` 固定为 integer
TEST_DIAGNOSTIC [[
---@param ... string
local function f(...args)
    ---@type string
    local <?n?> = args.n
end
]] { 'assign-type-mismatch' }

-- `---@vararg` 同理
TEST_DIAGNOSTIC [[
---@vararg integer
local function f(...args)
    ---@type string
    local <?s?> = args[1]
end
]] { 'assign-type-mismatch' }
