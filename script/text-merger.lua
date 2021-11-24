local files   = require 'files'
local util    = require 'utility'
local encoder = require 'encoder'
local client  = require 'client'

local offsetEncoding
local function getOffsetEncoding()
    if not offsetEncoding then
        offsetEncoding = client.getOffsetEncoding():lower():gsub('%-', '')
    end
    return offsetEncoding
end

local function splitRows(text)
    local rows = {}
    for line in util.eachLine(text, true) do
        rows[#rows+1] = line
    end
    return rows
end

local function getLeft(text, char)
    if not text then
        return ''
    end
    local encoding = getOffsetEncoding()
    local left
    local length = encoder.len(encoding, text)

    if char == 0 then
        left = ''
    elseif char >= length then
        left = text
    else
        left = text:sub(1, encoder.offset(encoding, text, char + 1) - 1)
    end

    return left
end

local function getRight(text, char)
    if not text then
        return ''
    end
    local encoding = getOffsetEncoding()
    local right
    local length = encoder.len(encoding, text)

    if char == 0 then
        right = text
    elseif char >= length then
        right = ''
    else
        right = text:sub(encoder.offset(encoding, text, char + 1))
    end

    return right
end

local function mergeRows(rows, change)
    local startLine = change.range['start'].line + 1
    local startChar = change.range['start'].character
    local endLine   = change.range['end'].line + 1
    local endChar   = change.range['end'].character

    local insertRows = splitRows(change.text)
    local newEndLine = startLine + #insertRows - 1
    local left       = getLeft(rows[startLine], startChar)
    local right      = getRight(rows[endLine],  endChar)
    -- 先把双方的行数调整成一致
    if endLine > #rows then
        log.error('NMD, WSM `endLine > #rows` ?')
        for i = #rows + 1, endLine do
            rows[i] = ''
        end
    end
    local delta = #insertRows - (endLine - startLine + 1)
    if delta ~= 0 then
        table.move(rows, endLine, #rows, endLine + delta)
        -- 如果行数变少了，要清除多余的行
        if delta < 0 then
            for i = #rows, #rows + delta + 1, -1 do
                rows[i] = nil
            end
        end
    end
    -- 先处理第一行和最后一行
    if startLine == newEndLine then
        rows[startLine]  = left .. insertRows[1] .. right
    else
        rows[startLine]  = left .. insertRows[1]
        rows[newEndLine] = insertRows[#insertRows] .. right
    end
    -- 修改中间的每一行
    for i = 2, #insertRows - 1 do
        local currentLine = startLine + i - 1
        local insertText  = insertRows[i] or ''
        rows[currentLine] = insertText
    end
end

return function (text, rows, changes)
    for _, change in ipairs(changes) do
        if change.range then
            rows = rows or splitRows(text)
            mergeRows(rows, change)
        else
            rows = nil
            text = change.text
        end
    end
    if rows then
        text = table.concat(rows)
    end
    return text, rows
end
