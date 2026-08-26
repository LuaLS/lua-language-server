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
