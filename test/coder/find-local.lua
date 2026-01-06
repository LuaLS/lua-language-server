local rt = test.scope.rt

local function find(name, row, col)
    local vfile = TEST_CODER.vfile
    local offset = vfile.document.positionConverter:positionToOffset(row, col)

    local var = TEST_CODER:findVariable(name, offset)
    return var
end

local function all(row, col)
    local vfile = TEST_CODER.vfile
    local offset = vfile.document.positionConverter:positionToOffset(row, col)

    local vars = TEST_CODER:findVisibleVariables(offset)

    local result = ls.util.map(vars, function (v, k)
        return v.key.literal
    end)

    table.sort(result, ls.util.stringLess)

    return result
end

do
    TEST_INDEX [[
    ---@type string?
    local x

    if x then

    else

    end

    ]]

    assert(find('x', 0, 0) == nil)
    assert(find('x', 2, 5):view() == 'string | nil')
    assert(find('x', 4, 5):view() == 'string')
    assert(find('x', 100, 5):view() == 'string | nil')
end

do
    TEST_INDEX [[
    local x = 10

    if X then
        local x = x

        local y = 10
    else
        local y = 5

    end
    ]]

    assert(ls.util.equal(all(0, 0),  {'...', '_ENV'}))
    assert(ls.util.equal(all(4, 0),  {'...', 'x', '_ENV'}))
    assert(ls.util.equal(all(5, 99), {'...', 'x', 'y', '_ENV'}))
    assert(ls.util.equal(all(8, 0),  {'...', 'x', 'y', '_ENV'}))
    assert(ls.util.equal(all(10, 0), {'...', 'x', '_ENV'}))
end
