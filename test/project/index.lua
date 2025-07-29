do
    local scope = ls.scope.create()
    local uri = 'test://a.lua'

    ls.file.setText(uri, [[
GlobalA = 1
]])

    local global = scope.node:globalGet('GlobalA')
    assert(global.value:view() == 'unknown')
    local vfile = scope.vm:indexFile(uri)

    assert(global.value:view() == '1')

    vfile:remove()
    assert(global.value:view() == 'unknown')
end
