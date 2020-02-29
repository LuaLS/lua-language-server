local guide = require 'parser.guide'
local util  = require 'utility'

local m = {}

--- 获取 position 对应的光标位置
---@param lines table
---@param text string
---@param position position
---@return integer
function m.offset(lines, text, position)
    local row    = position.line + 1
    local start  = guide.lineRange(lines, row)
    local offset = utf8.offset(text, position.character + 1, start)
    if offset > #text
    or text:sub(offset-1, offset):match '[%w_][^%w_]' then
        offset = offset - 1
    end
    return offset
end

--- 将光标位置转化为 position
---@alias position table
---@param lines table
---@param text string
---@param offset integer
---@return position
function m.position(lines, text, offset)
    local row, col = guide.positionOf(lines, offset)
    local start    = guide.lineRange(lines, row)
    if start < 1 then
        start = 1
    end
    local ucol     = util.utf8Len(text, start, start + col - 1, true)
    if row < 1 then
        row = 1
    end
    return {
        line      = row - 1,
        character = ucol,
    }
end

--- 将起点与终点位置转化为 range
---@alias range table
---@param lines table
---@param text string
---@param offset1 integer
---@param offset2 integer
function m.range(lines, text, offset1, offset2)
    local range = {
        start   = m.position(lines, text, offset1),
        ['end'] = m.position(lines, text, offset2),
    }
    if range.start.character > 0 then
        range.start.character = range.start.character - 1
    end
    return range
end

---@alias location table
---@param uri string
---@param range range
---@return location
function m.location(uri, range)
    return {
        uri   = uri,
        range = range,
    }
end

---@alias locationLink table
---@param uri string
---@param range range
---@param selection range
---@param origin range
function m.locationLink(uri, range, selection, origin)
    return {
        targetUri            = uri,
        targetRange          = range,
        targetSelectionRange = selection,
        originSelectionRange = origin,
    }
end

function m.textEdit(range, newtext)
    return {
        range   = range,
        newText = newtext,
    }
end

--- 诊断等级
m.DiagnosticSeverity = {
    Error       = 1,
    Warning     = 2,
    Information = 3,
    Hint        = 4,
}

--- 诊断类型与默认等级
m.DiagnosticDefaultSeverity = {
    ['unused-local']        = 'Hint',
    ['unused-function']     = 'Hint',
    ['undefined-global']    = 'Warning',
    ['global-in-nil-env']   = 'Warning',
    ['unused-label']        = 'Hint',
    ['unused-vararg']       = 'Hint',
    ['trailing-space']      = 'Hint',
    ['redefined-local']     = 'Hint',
    ['newline-call']        = 'Information',
    ['newfield-call']       = 'Warning',
    ['redundant-parameter'] = 'Hint',
    ['ambiguity-1']         = 'Warning',
    ['lowercase-global']    = 'Information',
    ['undefined-env-child'] = 'Information',
    ['duplicate-index']     = 'Warning',
    ['empty-block']         = 'Hint',
    ['redundant-value']     = 'Hint',
    ['emmy-lua']            = 'Warning',
}

--- 诊断报告标签
m.DiagnosticTag = {
    Unnecessary = 1,
    Deprecated  = 2,
}

m.DocumentHighlightKind = {
    Text  = 1,
    Read  = 2,
    Write = 3,
}

m.MessageType = {
    Error   = 1,
    Warning = 2,
    Info    = 3,
    Log     = 4,
}

return m
