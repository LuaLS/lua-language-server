---@param input string
---@param other string
---@param fast  boolean
---@return boolean isMatch
---@return number  deviation
return function (input, other, fast)
    if input == other then
        return true, 0
    end
    if input == '' then
        return true, 0
    end
    if #input > #other then
        return false, 0
    end
    local lMe = input:lower()
    local lOther = other:lower()
    if lMe == lOther:sub(1, #lMe) then
        return true, 0
    end
    if fast and input:sub(1, 1) ~= other:sub(1, 1) then
        return false, 0
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
            return false, 0
        end
    end
    return true, 1
end
