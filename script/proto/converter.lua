local guide   = require 'parser.guide'
local files   = require 'files'
local encoder = require 'encoder'

local offsetEncoding = 'utf16'

---@class converter
local m = {}

---@alias position {line: integer, character: integer}

---@param row integer
---@param col integer
---@return position
function m.position(row, col)
    return {
        line      = row,
        character = col,
    }
end

---@param state parser.state
---@param pos integer
---@return position
local function rawPackPosition(state, pos)
    local row, col = guide.rowColOf(pos)
    if col > 0 then
        local text  = state.lua
        if state and text then
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

---@param state parser.state
---@param pos integer
---@return position
local function diffedPackPosition(state, pos)
    local offset       = guide.positionToOffset(state, pos)
    local originOffset = files.diffedOffsetBack(state, offset)
    local originPos    = guide.offsetToPositionByLines(state.originLines, originOffset)
    local row, col     = guide.rowColOf(originPos)
    if col > 0 then
        local text = state.originText
        if text then
            local lineOffset  = state.originLines[row]
            local finalOffset = math.min(lineOffset + col - 1, #text + 1)
            col = encoder.len(offsetEncoding, text, lineOffset, finalOffset)
        end
    end
    return {
        line      = row,
        character = col,
    }
end

---@param state parser.state
---@param pos integer
---@return position
function m.packPosition(state, pos)
    if files.hasDiffed(state) then
        return diffedPackPosition(state, pos)
    else
        return rawPackPosition(state, pos)
    end
end

---@param state parser.state
---@param position position
---@return integer
local function rawUnpackPosition(state, position)
    local row, col = position.line, position.character
    if col > 0 then
        local text  = state.lua
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

---@param state parser.state
---@param position position
---@return integer
local function diffedUnpackPosition(state, position)
    local row, col = position.line, position.character
    if col > 0 then
        local lineOffset = state.originLines[row]
        if lineOffset then
            local textOffset = encoder.offset(offsetEncoding, state.originText, col + 1, lineOffset)
            if textOffset and lineOffset then
                col = textOffset - lineOffset
            end
        end
    end
    local originPos    = guide.positionOf(row, col)
    local originOffset = guide.positionToOffsetByLines(state.originLines, originPos)
    local offset       = files.diffedOffset(state, originOffset)
    local pos          = guide.offsetToPosition(state, offset)
    return pos
end

---@param state    parser.state
---@param position position
---@return integer
function m.unpackPosition(state, position)
    if files.hasDiffed(state) then
        return diffedUnpackPosition(state, position)
    else
        return rawUnpackPosition(state, position)
    end
end

---@alias range {start: position, end: position}

---@param state  parser.state
---@param start  integer
---@param finish integer
---@return range
function m.packRange(state, start, finish)
    local range = {
        start   = m.packPosition(state, start),
        ['end'] = m.packPosition(state, finish),
    }
    return range
end

---@param start position
---@param finish position
---@return range
function m.range(start, finish)
    return {
        start   = start,
        ['end'] = finish,
    }
end

---@param state parser.state
---@param range range
---@return integer start
---@return integer finish
function m.unpackRange(state, range)
    local start  = m.unpackPosition(state, range.start)
    local finish = m.unpackPosition(state, range['end'])
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

---@param s        string
---@param i?       integer
---@param j?       integer
---@return integer
function m.len(s, i, j)
    return encoder.len(offsetEncoding, s, i, j)
end

---@class proto.command
---@field title string
---@field command string
---@field arguments any[]

---@param title string
---@param command string
---@param arguments any[]
---@return proto.command
function m.command(title, command, arguments)
    return {
        title     = title,
        command   = command,
        arguments = arguments,
    }
end

return m
