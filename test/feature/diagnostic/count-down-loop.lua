print('[feature.diagnostic.count-down-loop] 测试中...')

TEST_DIAGNOSTIC [[
for i = <?10, 1?> do
    print(i)
end
]] { 'count-down-loop' }

TEST_DIAGNOSTIC [[
for i = 1, 10 do
    print(i)
end
]] {}

TEST_DIAGNOSTIC [[
for i = <?10, 1, 1?> do
    print(i)
end
]] { 'count-down-loop' }

TEST_DIAGNOSTIC [[
for i = 10, 1, -1 do
    print(i)
end
]] {}

TEST_DIAGNOSTIC [[
for i = 1, 10, 2 do
    print(i)
end
]] {}

print('[feature.diagnostic.count-down-loop] 测试完毕')