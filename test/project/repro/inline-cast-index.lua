-- `t[1]--[[@as string]]` 在**条件位置调用**（truthy 检测）时，实参反推是否盖掉了显式 cast
-- （同族 = 目标工程 `completion.lua:1861/1884` 的 `if ... and matchKey(source[1]--[[@as string]], name) then`）

---@class reproIc
---@field [integer] string | integer

---@param s string
---@return boolean
local function matchKey(s)
    return s ~= ''
end

---@param v reproIc
---@return boolean
local function inCondition(v)
    if matchKey(v[1]--[[@as string]]) then
        return true
    end
    return false
end

---@param v reproIc
---@return boolean
local function inReturn(v)
    return matchKey(v[1]--[[@as string]])
end

---@param v reproIc
---@return boolean
local function noCast(v)
    ---@diagnostic disable-next-line: param-type-mismatch
    if matchKey(v[1]) then
        return true
    end
    return false
end

return inCondition, inReturn, noCast
