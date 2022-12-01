local files        = require 'files'
local lookBackward = require 'core.look-backward'
local guide        = require 'parser.guide'
local config       = require 'config'
local util         = require 'utility'


local function insertIndentation(uri, position, edits)
    local text   = files.getText(uri)
    local state  = files.getState(uri)
    local row    = guide.rowColOf(position)
    if not state or not text then
        return
    end
    local offset = state.lines[row]
    local indent = text:match('^%s*', offset)
    for _, edit in ipairs(edits) do
        edit.text = edit.text:gsub('\n', '\n' .. indent)
    end
end

local function findForward(uri, position, ...)
    local text        = files.getText(uri)
    local state       = files.getState(uri)
    if not state or not text then
        return nil
    end
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
    if not state or not text then
        return nil
    end
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

    local fPosition, fSymbol = findForward(uri, position, 'end', '}')
    if not fPosition or not fSymbol then
        return
    end
    local bPosition = findBackward(uri, position, 'then', 'do', ')', '{')
    if not bPosition then
        return
    end
    local edits = {}
    edits[#edits+1] = {
        start  = bPosition,
        finish = position,
        text   = '\n\t',
    }
    edits[#edits+1] = {
        start  = position,
        finish = fPosition + 1,
        text   = '',
    }
    edits[#edits+1] = {
        start  = fPosition + 1,
        finish = fPosition + 1,
        text   = '\n' .. fSymbol:sub(1, 1)
    }
    insertIndentation(uri, bPosition, edits)
    for _, edit in ipairs(edits) do
        results[#results+1] = edit
    end
end

local function getIndent(state, row)
    local offset    = state.lines[row]
    local indent    = state.lua:match('^[\t ]*', offset)
    return indent
end

local function isInBlock(state, position)
    local block = guide.eachSourceContain(state.ast, position, function(source)
        if source.type == 'ifblock'
        or source.type == 'elseifblock' then
            if source.keyword[4] and source.keyword[4] <= position then
                return true
            end
        end
        if source.type == 'else' then
            if source.keyword[2] and source.keyword[2] <= position then
                return true
            end
        end
        if source.type == 'while' then
            if source.keyword[4] and source.keyword[4] <= position then
                return true
            end
        end
        if source.type == 'repeat' then
            if source.keyword[2] and source.keyword[2] <= position then
                return true
            end
        end
        if source.type == 'loop' then
            if source.keyword[4] and source.keyword[4] <= position then
                return true
            end
        end
        if source.type == 'in' then
            if source.keyword[6] and source.keyword[6] <= position then
                return true
            end
        end
        if source.type == 'do' then
            if source.keyword[2] and source.keyword[2] <= position then
                return true
            end
        end
        if source.type == 'function' then
            if source.args and source.args.finish <= position then
                return true
            end
            if not source.keyword[3] or source.keyword[3] >= position then
                return true
            end
        end
        if source.type == 'table' then
            if source.start + 1 == position then
                return true
            end
        end
    end)
    return block ~= nil
end

local function checkWrongIndentation(results, uri, position, ch)
    if ch ~= '\n' then
        return
    end
    local state = files.getState(uri)
    if not state then
        return
    end
    local row = guide.rowColOf(position)
    if row <= 0 then
        return
    end
    local myIndent   = getIndent(state, row)
    local lastIndent = getIndent(state, row - 1)
    if #myIndent <= #lastIndent then
        return
    end
    if not util.stringStartWith(myIndent, lastIndent) then
        return
    end
    local lastOffset = lookBackward.findAnyOffset(state.lua, guide.positionToOffset(state, position) - 1)
    if not lastOffset then
        return
    end
    local lastPosition = guide.offsetToPosition(state, lastOffset)
    if isInBlock(state, lastPosition) then
        return
    end
    results[#results+1] = {
        start  = position - #myIndent + #lastIndent,
        finish = position,
        text   = '',
    }
end

local function typeFormat(results, uri, position, ch, options)
    if ch ~= '\n' then
        return
    end
    local suc, codeFormat = pcall(require, "code_format")
    if not suc then
        return
    end
    local text = files.getOriginText(uri)
    local state = files.getState(uri)
    if not state then
        return
    end
    local converter = require("proto.converter")
    local pos = converter.packPosition(state, position)
    local typeFormatOptions = config.get(uri, 'Lua.typeFormat.config')
    local success, result = codeFormat.type_format(uri, text, pos.line, pos.character, options, typeFormatOptions)
    if success then
        local range = result.range
        results[#results+1] = {
            text   = result.newText,
            start  = converter.unpackPosition(state, { line = range.start.line, character = range.start.character }),
            finish = converter.unpackPosition(state, { line = range["end"].line, character = range["end"].character }),
        }
    end
end

return function (uri, position, ch, options)
    local state = files.getState(uri)
    if not state then
        return nil
    end

    local results = {}
    -- split `function () $ end`
    checkSplitOneLine(results, uri, position, ch)
    if #results > 0 then
        return results
    end

    checkWrongIndentation(results, uri, position, ch)
    if #results > 0 then
        return results
    end

    if TEST then
        return nil
    end

    typeFormat(results, uri, position, ch, options)
    if #results > 0 then
        return results
    end

    return nil
end
