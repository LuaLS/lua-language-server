local node = test.scope.node

do
    local vm = ls.vm.create(test.scope)
    node:reset()

    local a = node.type 'A'
    assert(a.value:view() == 'A')

    local vfile = vm:createFile('test.lua')
    vfile.contribute:commit {
        kind = 'field',
        typeName = 'A',
        field = {
            key = node.value 'x',
            value = node.NUMBER,
        }
    }

    assert(a.value:view() == '{ x: number }')

    vfile:resetContribute()
    assert(a.value:view() == 'A')

    vfile.contribute:commit {
        kind = 'field',
        typeName = 'A',
        field = {
            key = node.value 'x',
            value = node.STRING,
        }
    }
    assert(a.value:view() == '{ x: string }')

    vfile:remove()
    assert(a.value:view() == 'A')
end

do
    local vm = ls.vm.create(test.scope)
    node:reset()

    local g = node.type '_G'
    assert(g.value:view() == '{}')
    assert(node:globalGet('x').value:view() == 'unknown')

    local vfile = vm:createFile('test.lua')
    vfile.contribute:commit {
        kind = 'global',
        field = {
            key = node.value 'x',
            value = node.NUMBER,
        }
    }

    assert(g.value:view() == '{ x: number }')
    assert(node:globalGet('x').value:view() == 'number')

    vfile:resetContribute()
    assert(g.value:view() == '{}')

    vfile.contribute:commit {
        kind = 'global',
        field = {
            key = node.value 'x',
            value = node.STRING,
        }
    }
    assert(g.value:view() == '{ x: string }')
    assert(node:globalGet('x').value:view() == 'string')

    vfile:remove()
    assert(g.value:view() == '{}')
    assert(node:globalGet('x').value:view() == 'unknown')
end

do
    local vm = ls.vm.create(test.scope)
    node:reset()

    local g = node.type '_G'

    local vfile = vm:createFile('test.lua')
    local ast = ls.parser.compile [[
        A = 1
    ]]
    vfile:indexAst(ast)

    --assert(g:get('A'):view() == '1')
end
