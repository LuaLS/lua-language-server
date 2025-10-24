local node = test.scope.node

do
    local vm = ls.vm.create(test.scope)
    node:reset()

    local vfile = vm:createFile('test.lua')
    ls.file.setText('test.lua', [[
        ---@class A
        ---@field x number
        ---@field y number
        ---@field z number
    ]])

    vfile:index()

    assert(node.type('A').value:view() == '{ x: number, y: number, z: number }')
end

do
    local vm = ls.vm.create(test.scope)
    node:reset()

    local vfile = vm:createFile('test.lua')
    ls.file.setText('test.lua', [[
        ---@class A
        A = {}

        A.x = 1
        A.y = 2
    ]])

    vfile:index()

    assert(node.type('A').value:view() == '{ x: 1, y: 2 }')
end

do
    local vm = ls.vm.create(test.scope)
    node:reset()

    local vfile = vm:createFile('test.lua')
    ls.file.setText('test.lua', [[
        ---@class A
        A.B = {}

        A.B.x = 1
        A.B.y = 2
    ]])

    vfile:index()

    assert(node.type('A').value:view() == '{ x: 1, y: 2 }')
end

do
    local vm = ls.vm.create(test.scope)
    node:reset()

    local vfile = vm:createFile('test.lua')
    ls.file.setText('test.lua', [[
        ---@class A
        local A = {}

        A.x = 1
        A.y = 2
    ]])

    vfile:index()

    assert(node.type('A').value:view() == '{ x: 1, y: 2 }')
end

do
    local vm = ls.vm.create(test.scope)
    node:reset()

    local vfile = vm:createFile('test.lua')
    ls.file.setText('test.lua', [[
        local A = {}

        ---@class A
        A.B = {}

        A.B.x = 1
        A.B.y = 2
    ]])

    vfile:index()

    assert(node.type('A').value:view() == '{ x: 1, y: 2 }')
end

do
    local vm = ls.vm.create(test.scope)
    node:reset()

    local vfile = vm:createFile('test.lua')
    ls.file.setText('test.lua', [[
        function type(o)
        end
    ]])

    vfile:index()

    assert(node:globalGet('type').value:view() == 'fun(o: any)')
end

do
    local vm = ls.vm.create(test.scope)
    node:reset()

    local vfile = vm:createFile('test.lua')
    ls.file.setText('test.lua', [[
        ---@param o table
        ---@return string
        function type(o)
        end
    ]])

    vfile:index()

    assert(node:globalGet('type').value:view() == 'fun(o: table):string')
end
