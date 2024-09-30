local files = require 'files'
local guide = require 'parser.guide'
local proto = require 'proto.proto'
local lookBackward = require 'core.look-backward'
local util = require 'utility'
local client = require 'client'
local config = require 'config'

---@param uri uri
---@param change table
local function removeSpacesAfterEnter(uri, change)
    if not change.text:match '^\r?\n[\t ]+\r?\n$' then
        return false
    end
    local state = files.getState(uri)
    if not state then
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

---@param state parser.state
---@param pos integer
---@return parser.object
local function getBlock(state, pos)
    local block
    guide.eachSourceContain(state.ast, pos, function (src)
        if not src.bstart then
            return
        end
        if not block or block.bstart < src.bstart then
            block = src
        end
    end)
    return block
end

---@param uri uri
local function fixWrongIndent(uri, change)
    if not change.text:match '^\r?\n[\t ]+$' then
        return false
    end
    local state = files.getState(uri)
    if not state then
        return false
    end
    local position = guide.positionOf(change.range.start.line, change.range.start.character)
    local row = guide.rowColOf(position)
    local myIndent   = getIndent(state, row + 1)
    local lastOffset = lookBackward.findAnyOffset(state.lua, guide.positionToOffset(state, position))
    if not lastOffset then
        return
    end
    local lastPosition = guide.offsetToPosition(state, lastOffset)
    local lastRow = guide.rowColOf(lastPosition)
    local lastIndent = getIndent(state, lastRow)
    if #myIndent <= #lastIndent then
        return
    end
    if not util.stringStartWith(myIndent, lastIndent) then
        return
    end
    local myBlock = getBlock(state, lastPosition)
    if myBlock.bstart >= lastPosition then
        return
    end

    local endPosition = guide.positionOf(change.range.start.line + 1, #myIndent)
    local endOffset = guide.positionToOffset(state, endPosition)

    local edits = {}
    edits[#edits+1] = {
        start  = endOffset - #myIndent + #lastIndent,
        finish = endOffset,
        text   = '',
    }

    return edits
end

---@param uri uri
local function applyEdits(uri, edits)
    if #edits == 0 then
        return
    end

    local state = files.getState(uri)
    if not state then
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

    if not config.get(uri, 'Lua.language.fixIndent') then
        return
    end

    local firstChange = changes[1]
    if firstChange.range then
        local edits = removeSpacesAfterEnter(uri, firstChange)
                or    fixWrongIndent(uri, firstChange)
        if edits then
            applyEdits(uri, edits)
        end
    end
end
