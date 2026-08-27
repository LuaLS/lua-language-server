TEST_DIAGNOSTIC [[
while true do
    break
    <?print('x')?>
end
]] { 'code-after-break' }

TEST_DIAGNOSTIC [[
while true do
    break
end
]] {}

TEST_DIAGNOSTIC [[
while true do
    if true then
        break
    end
end
]] {}

TEST_DIAGNOSTIC [[
while true do
    if true then
        break
        <?print('x')?>
    end
end
]] { 'code-after-break' }

TEST_DIAGNOSTIC [[
for i = 1, 10 do
    break
    <?i = i + 1?>
end
]] { 'code-after-break' }