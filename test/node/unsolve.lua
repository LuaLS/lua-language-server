do
    local a = test.scope.rt.unsolve(test.scope.rt.TABLE, nil, function ()
        return test.scope.rt.table {
            x = 1,
            y = 2,
            z = 3,
        }
    end)

    assert(a:view() == '{ x: 1, y: 2, z: 3 }')
end
