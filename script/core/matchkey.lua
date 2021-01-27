return function (input, other, fast)
    if input == other then
        return true
    end
    if input == '' then
        return true
    end
    if #input > #other then
        return false
    end
    local lMe = input:lower()
    local lOther = other:lower()
    if lMe == lOther:sub(1, #lMe) then
        return true
    end
    if fast and input:sub(1, 1) ~= other:sub(1, 1) then
        return false
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
