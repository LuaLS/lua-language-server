local type         = type
local pairs        = pairs
local setmetatable = setmetatable

_ENV = nil

---@class PositionConverter
---@field private _text string
---@field private _lineStarts integer[]
local M = {}
M.__index = M

---@param text string
function M:parse(text)
    self._text = text
    local lineStarts = { 0 }
    local pos = 1
    while true do
        local p = text:find('[\r\n]', pos)
        if not p then
            break
        end
        if text:sub(p, p) == '\r' and text:sub(p + 1, p + 1) == '\n' then
            lineStarts[#lineStarts + 1] = p + 1
            pos = p + 2
        else
            lineStarts[#lineStarts + 1] = p
            pos = p + 1
        end
    end
    self._lineStarts = lineStarts
end

--- 将偏移位置（0-based）转换为行列（0-based）
---@param offset integer
---@return integer row # 第一行是0
---@return integer col # 第一列是0
function M:offsetToPosition(offset)
    local lineStarts = self._lineStarts

    if offset < 0 then
        return 0, 0
    end

    local textLen = #self._text
    if offset >= textLen then
        -- 返回最后一行，列为文本长度减去最后一行起始位置
        return #lineStarts - 1, textLen - lineStarts[#lineStarts]
    end

    if #lineStarts == 1 then
        return 0, offset
    end

    -- 二分查找行号
    local left = 1
    local right = #lineStarts
    local row = 0

    while left <= right do
        local mid = (left + right) // 2
        if offset < lineStarts[mid] then
            right = mid - 1
        elseif mid == #lineStarts or offset < lineStarts[mid + 1] then
            row = mid - 1
            break
        else
            left = mid + 1
        end
    end

    local col = offset - lineStarts[row + 1]
    return row, col
end

--- 将行列（0-based）转换为偏移位置（0-based）
---@param row integer # 第一行是0
---@param col integer # 第一列是0
---@return integer offset
function M:positionToOffset(row, col)
    local lineStarts = self._lineStarts

    if row < 0 then
        return 0
    end
    if row >= #lineStarts then
        return #self._text
    end

    local lineStart = lineStarts[row + 1]
    if col <= 0 then
        return lineStart
    end

    local offset = lineStart + col

    -- 确保不超过当前行的末尾
    if row + 1 < #lineStarts then
        local nextLineStart = lineStarts[row + 2]
        if offset >= nextLineStart then
            offset = nextLineStart - 1
        end
    else
        local textLen = #self._text
        if offset >= textLen then
            offset = textLen
        end
    end

    return offset
end

---@param text string
---@return PositionConverter
local function parse(text)
    local self = setmetatable({}, M)
    self:parse(text)
    return self
end

return {
    parse = parse,
}
