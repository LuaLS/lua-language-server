local m = {}

local function tableLenEqual(t, len)
    for _key, _value in pairs(t) do
        len = len - 1
        if len < 0 then
            return false
        end
    end
    return true
end

local function isSingleNode(ast)
    if type(ast) ~= 'table' then
        return false
    end
    local len = #ast
    return len == 1 and tableLenEqual(ast, len)
end

function m.expandSingle(ast)
    if isSingleNode(ast) then
        return ast[1]
    end
    return ast
end

return m
