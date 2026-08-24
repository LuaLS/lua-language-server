TEST_DIAGNOSTIC [[
<?while true do
end?>
]] { 'empty-block' }

TEST_DIAGNOSTIC [[
while true do
    x = 1
end
]] {}

TEST_DIAGNOSTIC [[
<?for i = 1, 10 do
end?>
]] { 'empty-block' }

TEST_DIAGNOSTIC [[
<?for k, v in pairs(t) do
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
    x = 1
end
]] {}

TEST_DIAGNOSTIC [[
if true then
    x = 1
else
end
]] {}

TEST_DIAGNOSTIC [[
local function f()
end
]] {}

TEST_DIAGNOSTIC [[
do
end
]] {}
