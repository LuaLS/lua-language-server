local encoder      = require 'tools.encoder'

local setmetatable = setmetatable
local concat       = table.concat

---@class TextMerge
---@field private _rows string[]|nil        -- 行数组，含行尾换行符
---@field private _textCache string|nil     -- 拼接缓存
---@field private _encoding Encoder.Encoding -- LSP 编码，默认为 utf16
local M = {}
M.__index = M

local function getOffsetEncoding(encoding)
    return encoding or 'utf16'
end

local function splitRows(text)
    local rows = {}
    for line in ls.util.eachLine(text, true) do
        rows[#rows+1] = line
    end
    if #rows == 0 then
        rows[1] = ''
    end
    return rows
end

local function getLeft(text, char, encoding)
    if not text then
        return ''
    end
    local enc = getOffsetEncoding(encoding)
    local length = encoder.len(enc, text)
    if char == 0 then
        return ''
    end
    if char >= length then
        return text
    end
    return text:sub(1, encoder.offset(enc, text, char + 1) - 1)
end

local function getRight(text, char, encoding)
    if not text then
        return ''
    end
    local enc = getOffsetEncoding(encoding)
    local length = encoder.len(enc, text)
    if char == 0 then
        return text
    end
    if char >= length then
        return ''
    end
    return text:sub(encoder.offset(enc, text, char + 1))
end

local function mergeRows(rows, change, encoding)
    local startLine = change.range['start'].line + 1
    local startChar = change.range['start'].character
    local endLine   = change.range['end'].line + 1
    local endChar   = change.range['end'].character

    local insertRows = splitRows(change.text)
    local newEndLine = startLine + #insertRows - 1
    local left       = getLeft(rows[startLine], startChar, encoding)
    local right      = getRight(rows[endLine],  endChar, encoding)

    if endLine > #rows then
        for i = #rows + 1, endLine do
            rows[i] = ''
        end
    end

    local delta = #insertRows - (endLine - startLine + 1)
    if delta ~= 0 then
        table.move(rows, endLine, #rows, endLine + delta)
        if delta < 0 then
            for i = #rows, #rows + delta + 1, -1 do
                rows[i] = nil
            end
        end
    end

    if startLine == newEndLine then
        rows[startLine]  = left .. insertRows[1] .. right
    else
        rows[startLine]  = left .. insertRows[1]
        rows[newEndLine] = insertRows[#insertRows] .. right
    end

    for i = 2, #insertRows - 1 do
        local currentLine = startLine + i - 1
        rows[currentLine] = insertRows[i] or ''
    end
end

--- 应用单个内容变更
---@private
---@param change LSP.TextDocumentContentChangeEvent
function M:_applyChange(change)
    if not change.range then
        self._textCache = change.text
        self._rows = nil
        return
    end

    local rows = self._rows
    if not rows then
        rows = splitRows(self._textCache or '')
        self._rows = rows
    end

    mergeRows(rows, change, self._encoding)
    self._textCache = nil
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
    if self._textCache then
        return self._textCache
    end

    if not self._rows then
        return self._textCache or ''
    end

    self._textCache = concat(self._rows)
    return self._textCache
end

--- 创建文本合并对象
---@param text? string
---@param encoding? Encoder.Encoding # 默认为 'utf16'，用于 LSP 字符偏移计算
---@return TextMerge
local function create(text, encoding)
    local self = setmetatable({
        _rows = nil,
        _textCache = text or '',
        _encoding = getOffsetEncoding(encoding),
    }, M)
    return self
end

return {
    create = create,
}
