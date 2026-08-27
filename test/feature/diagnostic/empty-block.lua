TEST_DIAGNOSTIC [[
<?while true do
end?>
]] { 'empty-block' }

TEST_DIAGNOSTIC [[
while true do
    local _ = 1
end
]] {}

TEST_DIAGNOSTIC [[
<?for i = 1, 10 do
end?>
]] { 'empty-block' }

TEST_DIAGNOSTIC [[
--!include pairs
<?for k, v in pairs({}) do
end?>
]] { 'empty-block' }

TEST_DIAGNOSTIC [[
<?repeat
until true?>
]] { 'empty-block' }

TEST_DIAGNOSTIC [[
<?if true then
end?>
]] { 'empty-block' }

TEST_DIAGNOSTIC [[
<?if true then
else
end?>
]] { 'empty-block' }

TEST_DIAGNOSTIC [[
if true then
    local _ = 1
end
]] {}

TEST_DIAGNOSTIC [[
if true then
    local _ = 1
else
end
]] {}

TEST_DIAGNOSTIC [[
local function _()
end
]] {}

TEST_DIAGNOSTIC [[
do
end
]] {}