do
    assert(ls.node.ANY.truly:view() == 'truly')
    assert(ls.node.ANY.falsy:view() == 'false | nil')

    assert(ls.node.UNKNOWN.truly:view() == 'truly')
    assert(ls.node.UNKNOWN.falsy:view() == 'false')

    assert(ls.node.TRULY.truly:view() == 'truly')
    assert(ls.node.TRULY.falsy:view() == 'never')

    assert(ls.node.NIL.truly:view() == 'never')
    assert(ls.node.NIL.falsy:view() == 'nil')

    assert(ls.node.BOOLEAN.truly:view() == 'true')
    assert(ls.node.BOOLEAN.falsy:view() == 'false')

    assert(ls.node.TRUE.truly:view() == 'true')
    assert(ls.node.TRUE.falsy:view() == 'never')

    assert(ls.node.FALSE.truly:view() == 'never')
    assert(ls.node.FALSE.falsy:view() == 'false')

    assert(ls.node.TABLE.truly:view() == 'table')
    assert(ls.node.TABLE.falsy:view() == 'never')

    assert(ls.node.value(0).truly:view() == '0')
    assert(ls.node.value(0).falsy:view() == 'never')

    assert(ls.node.value(1).truly:view() == '1')
    assert(ls.node.value(1).falsy:view() == 'never')
end
