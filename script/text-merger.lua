local files = require 'files'
local util  = require 'utility'

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
    local left
    local length = util.utf8Len(text)

    if char == 0 then
        left = ''
    elseif char >= length then
        left = text
    else
        left = text:sub(1, utf8.offset(text, char + 1) - 1)
    end

    return left
end

local function getRight(text, char)
    if not text then
        return ''
    end
    local right
    local length = util.utf8Len(text)

    if char == 0 then
        right = text
    elseif char >= length then
        right = ''
    else
        right = text:sub(utf8.offset(text, char + 1))
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

return function (uri, changes)
    local text
    for _, change in ipairs(changes) do
        if change.range then
            local rows = files.getCachedRows(uri)
            if not rows then
                text = text or files.getOriginText(uri) or ''
                rows = splitRows(text)
            end
            mergeRows(rows, change)
            files.setCachedRows(uri, rows)
        else
            files.setCachedRows(uri, nil)
            text = change.text
        end
    end
    local rows = files.getCachedRows(uri)
    if rows then
        text = table.concat(rows)
    end
    return text
end
