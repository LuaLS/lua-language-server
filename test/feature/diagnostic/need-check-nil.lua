TEST_DIAGNOSTIC [[
---@type number?
local x
print(<?x?>.y)
]] { 'need-check-nil' }

TEST_DIAGNOSTIC [[
local x = nil
print(<?x?>.y)
]] { 'need-check-nil' }

TEST_DIAGNOSTIC [[
---@type number
local x = 1
print(x.y)
]] { '-need-check-nil' }

TEST_DIAGNOSTIC [[
local x = 1
print(x.y)
]] { '-need-check-nil' }