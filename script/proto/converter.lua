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

return m
