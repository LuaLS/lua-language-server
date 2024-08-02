local files = require 'files'
local guide = require 'parser.guide'
local proto = require 'proto.proto'
local lookBackward = require 'core.look-backward'
local util = require 'utility'
local client = require 'client'

---@param state parser.state
---@param change table
local function removeSpacesAfterEnter(state, change)
    if not change.text:match '^\r?\n[\t ]+\r?\n$' then
        return false
    end
    local lines = state.originLines or state.lines
    local text  = state.originText  or state.lua
    ---@cast text -?

    local edits = {}
    -- 清除前置空格
    local startPos = guide.positionOf(change.range.start.line, change.range.start.character)
    local startOffset = guide.positionToOffsetByLines(lines, startPos)
    local leftOffset
    for offset = startOffset, lines[change.range.start.line], -1 do
        leftOffset = offset
        local char = text:sub(offset, offset)
        if char ~= ' ' and char ~= '\t' then
            break
        end
    end

    if leftOffset and leftOffset < startOffset then
        edits[#edits+1] = {
            start  = leftOffset,
            finish = startOffset,
            text   = '',
        }
    end

    -- 清除后置空格
    local endOffset = startOffset + #change.text
    local _, rightOffset = text:find('^[\t ]+', endOffset + 1)
    if rightOffset then
        edits[#edits+1] = {
            start  = endOffset,
            finish = rightOffset,
            text   = '',
        }
    end

    if #edits == 0 then
        return nil
    end

    return edits
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

local function fixWrongIndent(state, change)
    if not change.text:match '^\r?\n[\t ]+$' then
        return false
    end
    local position = guide.positionOf(change.range.start.line, change.range.start.character)
    local row = guide.rowColOf(position)
    local myIndent   = getIndent(state, row + 1)
    local lastIndent = getIndent(state, row)
    if #myIndent <= #lastIndent then
        return
    end
    if not util.stringStartWith(myIndent, lastIndent) then
        return
    end
    local lastOffset = lookBackward.findAnyOffset(state.lua, guide.positionToOffset(state, position))
    if not lastOffset then
        return
    end
    local lastPosition = guide.offsetToPosition(state, lastOffset)
    if isInBlock(state, lastPosition) then
        return
    end

    local endOffset = guide.positionToOffset(state, position) + #change.text

    local edits = {}
    edits[#edits+1] = {
        start  = endOffset - #myIndent + #lastIndent,
        finish = endOffset,
        text   = '',
    }

    return edits
end

---@param state parser.state
local function applyEdits(state, edits)
    if #edits == 0 then
        return
    end

    local lines = state.originLines or state.lines

    local results = {}
    for i, edit in ipairs(edits) do
        local startPos = guide.offsetToPositionByLines(lines, edit.start)
        local endPos = guide.offsetToPositionByLines(lines, edit.finish)
        local startRow, startCol = guide.rowColOf(startPos)
        local endRow, endCol = guide.rowColOf(endPos)
        results[i] = {
            range   = {
                start = {
                    line = startRow,
                    character = startCol,
                },
                ['end'] = {
                    line = endRow,
                    character = endCol,
                }
            },
            newText = edit.text,
        }
    end

    proto.request('workspace/applyEdit', {
        label = 'Fix Indent',
        edit = {
            changes = {
                [state.uri] = results
            }
        },
    })
end

return function (uri, changes)
    if not client.getOption('fixIndents') then
        return
    end
    local state = files.compileState(uri)
    if not state then
        return
    end

    local firstChange = changes[1]
    if firstChange.range then
        local edits = removeSpacesAfterEnter(state, firstChange)
                or    fixWrongIndent(state, firstChange)
        if edits then
            applyEdits(state, edits)
        end
    end
end
