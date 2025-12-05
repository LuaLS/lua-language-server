local posConverter = require 'tools.position-converter'
local encoder      = require 'tools.encoder'

local setmetatable = setmetatable
local sub          = string.sub

---@class TextMerge
---@field private _text string
---@field private _converter PositionConverter
---@field private _encoding Encoder.Encoding
local M = {}
M.__index = M

--- 应用单个内容变更
---@private
---@param change LSP.TextDocumentContentChangeEvent
function M:_applyChange(change)
    -- 如果是全文替换（没有 range 字段）
    if not change.range then
        self._text = change.text
        self._converter = posConverter.parse(self._text)
        return
    end

    -- 增量更新
    local range = change.range
    local startLine = range.start.line
    local startChar = range.start.character
    local endLine = range['end'].line
    local endChar = range['end'].character

    -- 将行列转换为字节偏移
    local startOffset = self._converter:positionToOffset(startLine, 0)
    local endLineOffset = self._converter:positionToOffset(endLine, 0)

    -- 计算行内的字节偏移（使用 encoder 处理编码）
    local startLineText = sub(self._text, startOffset + 1)
    local endLineText = sub(self._text, endLineOffset + 1)

    -- 找到行尾
    local startLineEnd = startLineText:find('[\r\n]') or (#startLineText + 1)
    local endLineEnd = endLineText:find('[\r\n]') or (#endLineText + 1)

    startLineText = sub(startLineText, 1, startLineEnd - 1)
    endLineText = sub(endLineText, 1, endLineEnd - 1)

    -- 使用 encoder.offset 转换字符偏移为字节偏移
    -- encoder.offset 返回的是基于 1 的字节位置
    local startCharByte = 1
    local endCharByte = 1

    if startChar > 0 then
        startCharByte = encoder.offset(self._encoding, startLineText, startChar + 1, 1)
    end

    if endChar > 0 then
        endCharByte = encoder.offset(self._encoding, endLineText, endChar + 1, 1)
    end

    -- 计算在整个文本中的绝对字节位置
    local replaceStart = startOffset + startCharByte
    local replaceEnd = endLineOffset + endCharByte

    -- 应用文本替换
    local before = sub(self._text, 1, replaceStart - 1)
    local after = sub(self._text, replaceEnd)

    self._text = before .. change.text .. after
    self._converter = posConverter.parse(self._text)
end

--- 应用内容变更数组
---@param changes LSP.TextDocumentContentChangeEvent[]
---@return self
function M:applyChanges(changes)
    if not changes then
        return self
    end

    for _, change in ipairs(changes) do
        self:_applyChange(change)
    end

    return self
end

--- 获取当前文本
---@return string
function M:getText()
    return self._text
end

--- 创建文本合并对象
---@param text string
---@param encoding? Encoder.Encoding # 默认为 'utf16le'，用于 LSP 字符偏移计算
---@return TextMerge
local function create(text, encoding)
    encoding = encoding or 'utf16'
    local self = setmetatable({
        _text = text,
        _converter = posConverter.parse(text),
        _encoding = encoding,
    }, M)
    return self
end

return {
    create = create,
}
