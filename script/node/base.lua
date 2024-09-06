---@param a Node
---@param b Node
---@return Node?
local function makeUnion(a, b)
    if a.cate == 'never'
    or a.cate == 'void' then
        return b
    end
    if a.cate == 'any' then
        return a
    end
end

function ls.node.bor(a, b)
    return makeUnion(a, b)
        or makeUnion(b, a)
        or ls.node.union(a, b)
end
