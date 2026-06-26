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
