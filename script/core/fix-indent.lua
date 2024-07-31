local files = require 'files'
local guide = require 'parser.guide'
local lookBackward = require 'core.look-backward'
local proto = require 'proto.proto'

---@param state parser.state
local function insertIndentation(state, position, edits)
    local text   = state.originText or state.lua
    local lines  = state.originLines or state.lines
    local row    = guide.rowColOf(position)
    if not lines or not text then
        return
    end
    local offset = lines[row]
    local indent = text:match('^%s*', offset)
    for _, edit in ipairs(edits) do
        edit.text = edit.text:gsub('\n', '\n' .. indent)
    end
end

---@param state parser.state
local function findForward(state, position, ...)
    local lines = state.originLines or state.lines
    local offset      = guide.positionToOffsetByLines(lines, position)
    local firstOffset = state.originText:match('^[ \t]*()', offset + 1)
    if not firstOffset then
        return nil
    end
    for _, symbol in ipairs { ... } do
        if state.originText:sub(firstOffset, firstOffset + #symbol - 1) == symbol then
            return guide.offsetToPositionByLines(lines, firstOffset - 1), symbol
        end
    end
    return nil
end

---@param state parser.state
local function findBackward(state, position, ...)
    local text       = state.originText or state.lua
    local lines      = state.originLines or state.lines
    if not text or not lines then
        return nil
    end
    local offset     = guide.positionToOffsetByLines(lines, position)
    local lastOffset = lookBackward.findAnyOffset(text, offset)
    if not lastOffset then
        return nil
    end
    for _, symbol in ipairs { ... } do
        if text:sub(lastOffset - #symbol + 1, lastOffset) == symbol then
            return guide.offsetToPositionByLines(lines, lastOffset)
        end
    end
    return nil
end

---@param state parser.state
---@param change table
---@param result any[]
local function checkSplitOneLine(state, change, result)
    if  change.text ~= '\r\n'
    and change.text ~= '\n' then
        return
    end

    local lines = state.originLines or state.lines
    local position = lines[change.range.start.line + 1]

    local fPosition, fSymbol = findForward(state, position, 'end', '}')
    if not fPosition or not fSymbol then
        return
    end
    local bPosition = findBackward(state, position, 'then', 'do', ')', '{')
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
    insertIndentation(state, bPosition, edits)
    for _, edit in ipairs(edits) do
        result[#result+1] = edit
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
                [state.uri] = {
                    {
                        range = {
                            start = {
                                line = 1,
                                character = 0,
                            },
                            ['end'] = {
                                line = 1,
                                character = 0,
                            }
                        },
                        newText = '\t',
                    },
                }
            }
        },
    })
    proto.notify('$/command', {
        command = 'cursorMove',
    })
end

return function (uri, changes)
    do return end
    local state = files.compileState(uri)
    if not state then
        return
    end

    local edits = {}
    for _, change in ipairs(changes) do
        if change.range then
            checkSplitOneLine(state, change, edits)
        end
    end

    applyEdits(state, edits)
end
