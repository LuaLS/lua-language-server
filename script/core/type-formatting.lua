local files        = require 'files'
local lookBackward = require 'core.look-backward'
local guide        = require "parser.guide"

local function insertIndentation(uri, offset, edits)
    local lines  = files.getLines(uri)
    local text   = files.getOriginText(uri)
    local row    = guide.positionOf(lines, offset)
    local line   = lines[row]
    local indent = text:sub(line.start, line.finish):match '^%s*'
    for _, edit in ipairs(edits) do
        edit.text = edit.text:gsub('\n', '\n' .. indent)
    end
end

local function findForward(text, offset, ...)
    local pos = text:match('^[ \t]*()', offset)
    for _, symbol in ipairs { ... } do
        if text:sub(pos, pos + #symbol - 1) == symbol then
            return pos, symbol
        end
    end
    return nil
end

local function findBackward(text, offset, ...)
    local pos = lookBackward.findAnyPos(text, offset)
    for _, symbol in ipairs { ... } do
        if text:sub(pos - #symbol + 1, pos) == symbol then
            return pos - #symbol + 1, symbol
        end
    end
    return nil
end

local function checkSplitOneLine(results, uri, offset, ch)
    if ch ~= '\n' then
        return
    end
    local text = files.getOriginText(uri)
    local fOffset, fSymbol = findForward(text, offset + 1, 'end', '}')
    if not fOffset then
        return
    end
    local bOffset, bSymbol = findBackward(text, offset, 'then', 'do', ')', '{')
    if not bOffset then
        return
    end
    local edits = {}
    edits[#edits+1] = {
        start  = bOffset + #bSymbol,
        finish = offset,
        text   = '\n\t',
    }
    edits[#edits+1] = {
        start  = offset + 1,
        finish = fOffset + #fSymbol - 1,
        text   = ''
    }
    edits[#edits+1] = {
        start  = fOffset + #fSymbol,
        finish = fOffset + #fSymbol - 1,
        text   = '\n' .. fSymbol
    }
    insertIndentation(uri, bOffset, edits)
    for _, edit in ipairs(edits) do
        results[#results+1] = edit
    end
end

return function (uri, offset, ch)
    local ast  = files.getState(uri)
    local text = files.getOriginText(uri)
    if not ast or not text then
        return nil
    end

    local results = {}
    -- split `function () $ end`
    checkSplitOneLine(results, uri, offset, ch)

    return results
end
