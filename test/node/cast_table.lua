do
    local A = ls.node.table()
        : addField { key = ls.node.value('x'), value = ls.node.value(1) }
        : addField { key = ls.node.value('y'), value = ls.node.value(2) }

    local B = ls.node.table()
        : addField { key = ls.node.value('x'), value = ls.node.value(1) }
        : addField { key = ls.node.value('y'), value = ls.node.value(2) }
        : addField { key = ls.node.value('z'), value = ls.node.value(3) }

    assert(A >> B == false)
    assert(B >> A == true)
end
