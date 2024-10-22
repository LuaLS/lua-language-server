local node = test.scope.node

do
    local vm = ls.vm.create(test.scope)
    node:reset()

    local a = node.type 'A'
    assert(a.value:view() == 'A')

    local vfile = vm:createFile('test.lua')
    vfile.contribute:addField('A', {
        key = node.value 'x',
        value = node.NUMBER
    })

    assert(a.value:view() == '{ x: number }')

    vfile:resetContribute()
    assert(a.value:view() == 'A')

    vfile.contribute:addField('A', {
        key = node.value 'x',
        value = node.STRING
    })
    assert(a.value:view() == '{ x: string }')

    vfile:remove()
    assert(a.value:view() == 'A')
end

do
    local vm = ls.vm.create(test.scope)
    node:reset()

    local g = node.type 'G'

    local vfile = vm:createFile('test.lua')
    local ast = ls.parser.compile [[
        A = 1
    ]]
    vfile:indexAst(ast)

    --assert(g:get('A'):view() == '1')
end
