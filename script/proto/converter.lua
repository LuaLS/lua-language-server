local guide = require 'parser.guide'

local m = {}


---@alias position {line: integer, character: integer}

---@param uri uri
---@param pos integer
---@return position
function m.packPosition(uri, pos)
    local row, col = guide.rowColOf(pos)
    return {
        line      = row,
        character = col,
    }
end

---@param uri      uri
---@param position position
---@return integer
function m.unpackPosition(uri, position)
    local pos = guide.positionOf(position.line, position.character)
    return pos
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

return m
