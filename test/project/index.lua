do
    local scope <close> = ls.scope.create('test afs')

    local file <close> = ls.file.setServerText(test.fileUri, [[
GlobalA = 1
]])

    local globalA = scope.rt:globalGet('GlobalA')
    assert(globalA.value:view() == 'unknown')

    local vfile = scope.vm:indexFile(test.fileUri)
    assert(globalA.value:view() == '1')

    vfile:remove()
    assert(globalA.value:view() == 'unknown')
end
