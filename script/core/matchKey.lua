return function (me, other)
    if me == other then
        return true
    end
    if me == '' then
        return true
    end
    if #me > #other then
        return false
    end
    local lMe = me:lower()
    local lOther = other:lower()
    if lMe == lOther:sub(1, #lMe) then
        return true
    end
    local chars = {}
    for i = 1, #lOther do
        local c = lOther:sub(i, i)
        chars[c] = (chars[c] or 0) + 1
    end
    for i = 1, #lMe do
        local c = lMe:sub(i, i)
        if chars[c] and chars[c] > 0 then
            chars[c] = chars[c] - 1
        else
            return false
        end
    end
    return true
end
