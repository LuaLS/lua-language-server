do
    local scope <close> = ls.scope.create('test afs')

    local file <close> = ls.file.setText(test.fileUri, [[
GlobalA = 1
]])

    local global = scope.rt:globalGet('GlobalA')
    assert(global.value:view() == 'unknown')

    local vfile = scope.vm:indexFile(test.fileUri)
    assert(global.value:view() == '1')

    vfile:remove()
    assert(global.value:view() == 'unknown')
end
