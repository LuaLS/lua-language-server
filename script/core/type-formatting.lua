local files        = require 'files'
local lookBackward = require 'core.look-backward'
local guide        = require "parser.guide"
local code_format  = require "code_format"
local log          = require "log"
local converter    = require "proto.converter"

local function insertIndentation(uri, position, edits)
    local text   = files.getText(uri)
    local state  = files.getState(uri)
    local row    = guide.rowColOf(position)
    local offset = state.lines[row]
    local indent = text:match('^%s*', offset)
    for _, edit in ipairs(edits) do
        edit.text = edit.text:gsub('\n', '\n' .. indent)
    end
end

local function findForward(uri, position, ...)
    local text        = files.getText(uri)
    local state       = files.getState(uri)
    local offset      = guide.positionToOffset(state, position)
    local firstOffset = text:match('^[ \t]*()', offset + 1)
    if not firstOffset then
        return nil
    end
    for _, symbol in ipairs { ... } do
        if text:sub(firstOffset, firstOffset + #symbol - 1) == symbol then
            return guide.offsetToPosition(state, firstOffset - 1), symbol
        end
    end
    return nil
end

local function findBackward(uri, position, ...)
    local text       = files.getText(uri)
    local state      = files.getState(uri)
    local offset     = guide.positionToOffset(state, position)
    local lastOffset = lookBackward.findAnyOffset(text, offset)
    for _, symbol in ipairs { ... } do
        if text:sub(lastOffset - #symbol + 1, lastOffset) == symbol then
            return guide.offsetToPosition(state, lastOffset)
        end
    end
    return nil
end

local function checkSplitOneLine(results, uri, position, ch)
    if ch ~= '\n' then
        return
    end

    -- local fPosition, fSymbol = findForward(uri, position, 'end', '}')
    -- if not fPosition then
    --     return
    -- end
    -- local bPosition = findBackward(uri, position, 'then', 'do', ')', '{')
    -- if not bPosition then
    --     return
    -- end
    -- local edits = {}
    -- edits[#edits+1] = {
    --     start  = bPosition,
    --     finish = position,
    --     text   = '\n\t',
    -- }
    -- edits[#edits+1] = {
    --     start  = position,
    --     finish = fPosition + 1,
    --     text   = '',
    -- }
    -- edits[#edits+1] = {
    --     start  = fPosition + 1,
    --     finish = fPosition + 1,
    --     text   = '\n' .. fSymbol:sub(1, 1)
    -- }
    -- insertIndentation(uri, bPosition, edits)
    -- for _, edit in ipairs(edits) do
    --     results[#results+1] = edit
    -- end
    local pos = converter.packPosition(uri, position)
    local text = files.getText(uri)
    local status, formattedText, startLine, endLine = code_format.range_format(
        uri, text, pos.line - 1, pos.line)

    if not status then
        if formattedText ~= nil then
            log.error(formattedText)
        end

        return
    end

    table.insert(results, {
        {
            start = converter.unpackPosition(uri, { line = startLine, character = 0 }),
            finish = converter.unpackPosition(uri, { line = endLine + 1, character = 0 }),
            text = formattedText,
        }
    })


end

return function (uri, position, ch)
    local ast = files.getState(uri)
    if not ast then
        return nil
    end

    local results = {}
    -- split `function () $ end`
    checkSplitOneLine(results, uri, position, ch)

    return results
end
