local lowers = {}
local uppers = {}
for c in ('abcdefghijklmnopqrstuvwxyz'):gmatch '.' do
    lowers[c] = true
    uppers[c:upper()] = true
end

---@param input string
---@param other string
local function isValidFirstChar(input, other)
    local first = input:sub(1, 1):upper()
    if first == other:sub(1, 1):upper() then
        return true
    end
    local pos = other:find(first, 2, true)
    if not pos and uppers[first] then
        -- word after symbol?
        if other:find('%A' .. first:lower(), 2) then
            return true
        end
    end
    if not pos then
        return false
    end
    local char = other:sub(pos, pos)
    -- symbol?
    if not uppers[char] then
        return true
    end
    -- word boundary?
    local beforeChar = other:sub(pos - 1, pos - 1)
    if not uppers[beforeChar] then
        return true
    end
    return false
end

local function isAlmostSame(input, other)
    local lMe = input:lower()
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
    if fast and input:sub(1, 1) ~= other:sub(1, 1) then
        return false, 0
    end
    if not isValidFirstChar(input, other) then
        return false, 0
    end
    if not isAlmostSame(input, other) then
        return false, 0
    end
    return true, 1
end
