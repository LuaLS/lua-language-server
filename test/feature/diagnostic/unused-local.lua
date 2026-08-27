TEST_DIAGNOSTIC [[
local <?x?> = 1
]] { 'unused-local' }

TEST_DIAGNOSTIC [[
local x = 1
x = x
]] {}

TEST_DIAGNOSTIC [[
local <?x?> = 1
x = 2
]] { 'unused-local' }

TEST_DIAGNOSTIC [[
local _ = 1
]] {}

TEST_DIAGNOSTIC [[
local x = 1
local <?y?> = x
]] { 'unused-local' }

TEST_DIAGNOSTIC [[
local t = {}
t.x = 1
]] {}

TEST_DIAGNOSTIC [[
local function _()
end
]] {}

TEST_DIAGNOSTIC [[
for i = 1, 10 do
    local _ = 1
end
]] {}