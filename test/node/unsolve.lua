do
    local a = ls.node.unsolve(ls.node.TABLE, function ()
        return ls.node.table {
            x = 1,
            y = 2,
            z = 3,
        }
    end)

    assert(a:view() == '{ x: 1, y: 2, z: 3 }')
end
