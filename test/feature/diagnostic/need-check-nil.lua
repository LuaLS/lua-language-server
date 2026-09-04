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

TEST_DIAGNOSTIC [[
---@type any
local lm
if not lm.notest then
    lm.notest = true
end
]] { '-need-check-nil' }

TEST_DIAGNOSTIC [[
---@type any
local x
print(x.y)
]] { '-need-check-nil' }