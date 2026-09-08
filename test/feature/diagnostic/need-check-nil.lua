TEST_DIAGNOSTIC [[
---@type number?
local x
print(<?x?>.y)
]] { 'need-check-nil' }

TEST_DIAGNOSTIC [[
local m = {}
function m.getAbility(name)
    if not m.info
    or not m.info.capabilities then
        return nil
    end
    local current = m.info.capabilities
    while true do
        local parent, nextPos = name:match '^([^%.]+)()'
        if not parent then
            break
        end
        current = current[parent]
        if not current then
            return current
        end
        if nextPos > #name then
            break
        else
            name = name:sub(nextPos + 1)
        end
    end
    return current
end
m.getAbility('a.b')
]] { '-need-check-nil' }

TEST_DIAGNOSTIC [[
local x = nil
print(<?x?>.y)
]] { 'need-check-nil' }

TEST_DIAGNOSTIC [[
---@return number
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

TEST_DIAGNOSTIC [[
---@generic T: table, V
---@param t T
---@return fun<V>(table: V[], i?: integer):integer, V
---@return T
---@return integer i
function ipairs(t) end

local function f(json_data)
    for _, section in ipairs(json_data) do
        return section.DOC
    end
end
f(1)
]] { '-need-check-nil' }
