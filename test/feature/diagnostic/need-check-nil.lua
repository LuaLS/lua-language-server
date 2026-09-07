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

TEST_DIAGNOSTIC [[
---@param has_seen table?
local function f(has_seen)
    if not has_seen then
        has_seen = {}
    end
    local x = has_seen[1]
end
]] { '-need-check-nil' }

TEST_DIAGNOSTIC [[
---@param has_seen table?
local function f(has_seen)
    if has_seen == nil then
        has_seen = {}
    end
    local x = has_seen[1]
end
]] { '-need-check-nil' }

TEST_DIAGNOSTIC [[
---@type table?
local t
if not t then
    t = {}
end
t.x = 1
local y = t.x
]] { '-need-check-nil' }