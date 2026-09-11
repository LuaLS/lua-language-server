do
    local uri1 = ls.uri.encode(test.rootPath .. '/hover_bug_vararg_class_1.lua')
    local uri2 = ls.uri.encode(test.rootPath .. '/hover_bug_vararg_class_2.lua')

    local script1, catched = test.catch([[
---@class C
local M = ...

M.<?xxx?>
]], '!?')

    local file1 <close> = ls.file.setServerText(uri1, script1)
    local file2 <close> = ls.file.setServerText(uri2, [[
---@class C
local M

M.xxx = 1
]])

    local vfile1 <close> = test.scope.vm:indexFile(uri1)
    local vfile2 <close> = test.scope.vm:indexFile(uri2)

    local hover = ls.feature.hover(uri1, catched['?'][1][1])
    assert(hover and hover.items and hover.items[1], 'expected hover result for M.xxx')
    assert(hover.items[1].label == '(field) M.xxx: 1', hover.items[1].label)
end

do
    -- 跨文件 global 在本 block 内被收窄时，不能让 _ENV 上的聚合字段值覆盖收窄结果
    local uriA = ls.uri.encode(test.rootPath .. '/narrow_global_a.lua')
    local uriB = ls.uri.encode(test.rootPath .. '/narrow_global_b.lua')

    local fileA <close> = ls.file.setServerText(uriA, [[
---@type string | nil
GB = nil
]])

    local scriptB, catched = test.catch([[
print(<?GB?>)

if GB then
    print(<?GB?>)
end
]], '!?')

    local fileB <close> = ls.file.setServerText(uriB, scriptB)
    local vfileA <close> = test.scope.vm:indexFile(uriA)
    local vfileB <close> = test.scope.vm:indexFile(uriB)

    local hover = ls.feature.hover(uriB, catched['?'][1][1])
    assert(hover and hover.items and hover.items[1], 'expected hover result for GB')
    assert(hover.items[1].label == 'global GB: string | nil', hover.items[1].label)

    local hover2 = ls.feature.hover(uriB, catched['?'][2][1])
    assert(hover2 and hover2.items and hover2.items[1], 'expected hover result for GB')
    assert(hover2.items[1].label == 'global GB: string', hover2.items[1].label)
end