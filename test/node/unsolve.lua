do
    local a = test.scope.node.unsolve(test.scope.node.TABLE, nil, function ()
        return test.scope.node.table {
            x = 1,
            y = 2,
            z = 3,
        }
    end)

    assert(a:view() == '{ x: 1, y: 2, z: 3 }')
end
