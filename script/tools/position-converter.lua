local encoder = require 'tools.encoder'

local setmetatable = setmetatable

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
---@param offset integer # 字节位置
---@param encoding? Encoder.Encoding
---@return integer row # 第一行是0
---@return integer col # 第一列是0，根据编码的字符位置
function M:offsetToPosition(offset, encoding)
    local lineStarts = self._lineStarts

    if offset < 0 then
        return 0, 0
    end

    local textLen = #self._text
    if offset >= textLen then
        -- 返回最后一行
        local row = #lineStarts - 1
        local lineStart = lineStarts[#lineStarts]
        local lineText = self._text:sub(lineStart + 1)
        local col = encoding and encoder.len(encoding, lineText) or (textLen - lineStart)
        return row, col
    end

    if #lineStarts == 1 then
        local col = encoding and encoder.len(encoding, self._text, 1, offset) or offset
        return 0, col
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

    local lineStart = lineStarts[row + 1]

    if encoding then
        -- 计算从行首到当前位置的字符数
        local lineText = self._text:sub(lineStart + 1, offset)
        local col = encoder.len(encoding, lineText)
        return row, col
    else
        local col = offset - lineStart
        return row, col
    end
end

--- 将行列（0-based）转换为偏移位置（0-based）
---@param row integer # 第一行是0
---@param col integer # 第一列是0，根据编码的字符位置
---@param encoding? Encoder.Encoding
---@return integer offset # 字节位置
function M:positionToOffset(row, col, encoding)
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

    -- 获取当前行的文本范围
    local lineEnd
    if row + 1 < #lineStarts then
        lineEnd = lineStarts[row + 2] - 1
    else
        lineEnd = #self._text
    end

    local lineText = self._text:sub(lineStart + 1, lineEnd)

    if encoding then
        -- 使用 encoder.offset 将字符位置转换为字节位置
        local byteOffset = encoder.offset(encoding, lineText, col + 1, 1)
        if not byteOffset then
            -- 如果超出行尾，返回行尾位置
            return lineEnd
        end
        local offset = lineStart + byteOffset - 1

        -- 确保不超过当前行的末尾
        if offset > lineEnd then
            return lineEnd
        end

        return offset
    else
        -- 无编码时，col 直接是字节偏移
        local offset = lineStart + col

        -- 确保不超过当前行的末尾
        if offset > lineEnd then
            return lineEnd
        end

        return offset
    end
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
