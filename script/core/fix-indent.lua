local files = require 'files'
local guide = require 'parser.guide'
local lookBackward = require 'core.look-backward'
local proto = require 'proto.proto'

---@param state parser.state
---@param change table
---@param edits table[]
local function removeSpacesAfterEnter(state, change, edits)
    if not change.text:match '^\r?\n[\t ]+\r?\n' then
        return
    end
    local lines = state.originLines or state.lines
    local text  = state.originText  or state.lua
    ---@cast text -?

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
    local state = files.compileState(uri)
    if not state then
        return
    end

    local edits = {}
    local firstChange = changes[1]
    if firstChange.range then
        removeSpacesAfterEnter(state, firstChange, edits)
    end

    applyEdits(state, edits)
end
