-- `T[]` 用变量下标读取（`lines[firstRow]`）读出的元素类型里带 nil：
-- 基值是可选字段（`state.lines`）时，守卫收窄没有带到后续语句的字段读取上
-- 同族 = 目标工程 `script/core/completion/completion.lua:270`（`text:sub(lines[firstRow], lastOffset)`）

---@class reproState
---@field lines integer[]

---@return reproState?
local function getState()
    return nil
end

---@return integer, integer
local function rowCol()
    return 1, 1
end

---@param v integer
---@return integer
local function needInteger(v)
    return v
end

---@param text string
---@return integer
local function f(text)
    local state = getState()
    if not state then
        return 0
    end
    local lines = state.lines
    local firstRow = rowCol()
    return needInteger(lines[firstRow])
end

return f
