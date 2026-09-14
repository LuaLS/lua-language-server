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
