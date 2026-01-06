local rt = test.scope.rt

local function find(name, row, col)
    local vfile = TEST_CODER.vfile
    local offset = vfile.document.positionConverter:positionToOffset(row, col)

    local var = vfile:findVariable(name, offset)
    return var
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
