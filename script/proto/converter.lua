local guide   = require 'parser.guide'
local files   = require 'files'
local encoder = require 'encoder'

local offsetEncoding = 'utf16'

local m = {}

---@alias position {line: integer, character: integer}

local function rawPackPosition(uri, pos)
    local row, col = guide.rowColOf(pos)
    if col > 0 then
        local state = files.getState(uri)
        local text  = files.getText(uri)
        if text then
            local lineOffset = state.lines[row]
            if lineOffset then
                local start = lineOffset
                local finish = lineOffset + col - 1
                if start <= #text and finish <= #text then
                    col = encoder.len(offsetEncoding, text, lineOffset, lineOffset + col - 1)
                end
            else
                col = 0
            end
        end
    end
    return {
        line      = row,
        character = col,
    }
end

local function diffedPackPosition(uri, pos)
    local state        = files.getState(uri)
    local offset       = guide.positionToOffset(state, pos)
    local originOffset = files.diffedOffsetBack(uri, offset)
    local originLines  = files.getOriginLines(uri)
    local originPos    = guide.offsetToPositionByLines(originLines, originOffset)
    local row, col     = guide.rowColOf(originPos)
    if col > 0 then
        local text = files.getOriginText(uri)
        if text then
            local lineOffset  = originLines[row]
            local finalOffset = math.min(lineOffset + col - 1, #text + 1)
            col = encoder.len(offsetEncoding, text, lineOffset, finalOffset)
        end
    end
    return {
        line      = row,
        character = col,
    }
end

---@param uri uri
---@param pos integer
---@return position
function m.packPosition(uri, pos)
    if files.hasDiffed(uri) then
        return diffedPackPosition(uri, pos)
    else
        return rawPackPosition(uri, pos)
    end
end

local function rawUnpackPosition(uri, position)
    local row, col = position.line, position.character
    if col > 0 then
        local state = files.getState(uri)
        local text  = files.getText(uri)
        if state and text then
            local lineOffset = state.lines[row]
            local textOffset = encoder.offset(offsetEncoding, text, col + 1, lineOffset)
            if textOffset and lineOffset then
                col = textOffset - lineOffset
            end
        end
    end
    local pos = guide.positionOf(row, col)
    return pos
end

local function diffedUnpackPosition(uri, position)
    local row, col     = position.line, position.character
    local originLines  = files.getOriginLines(uri)
    if col > 0 then
        local text  = files.getOriginText(uri)
        if text then
            local lineOffset = originLines[row]
            local textOffset = encoder.offset(offsetEncoding, text, col + 1, lineOffset)
            if textOffset and lineOffset then
                col = textOffset - lineOffset
            end
        end
    end
    local state        = files.getState(uri)
    local originPos    = guide.positionOf(row, col)
    local originOffset = guide.positionToOffsetByLines(originLines, originPos)
    local offset       = files.diffedOffset(uri, originOffset)
    local pos          = guide.offsetToPosition(state, offset)
    return pos
end

---@param uri      uri
---@param position position
---@return integer
function m.unpackPosition(uri, position)
    if files.hasDiffed(uri) then
        return diffedUnpackPosition(uri, position)
    else
        return rawUnpackPosition(uri, position)
    end
end

---@alias range {start: position, end: position}

---@param uri    uri
---@param start  integer
---@param finish integer
---@return range
function m.packRange(uri, start, finish)
    local range = {
        start   = m.packPosition(uri, start),
        ['end'] = m.packPosition(uri, finish),
    }
    return range
end

---@param uri   uri
---@param range range
---@return integer start
---@return integer finish
function m.unpackRange(uri, range)
    local start  = m.unpackPosition(uri, range.start)
    local finish = m.unpackPosition(uri, range['end'])
    return start, finish
end

---@alias location {uri: uri, range: range}

---@param uri string
---@param range range
---@return location
function m.location(uri, range)
    return {
        uri   = uri,
        range = range,
    }
end

---@alias locationLink {targetUri:uri, targetRange: range, targetSelectionRange: range, originSelectionRange: range}

---@param uri string
---@param range range
---@param selection range
---@param origin range
---@return locationLink
function m.locationLink(uri, range, selection, origin)
    return {
        targetUri            = uri,
        targetRange          = range,
        targetSelectionRange = selection,
        originSelectionRange = origin,
    }
end

---@alias textEdit {range: range, newText: string}

---@param range   range
---@param newtext string
---@return textEdit
function m.textEdit(range, newtext)
    return {
        range   = range,
        newText = newtext,
    }
end

function m.setOffsetEncoding(encoding)
    offsetEncoding = encoding:lower():gsub('%-', '')
end

return m
