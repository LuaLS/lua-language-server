local files = require 'files'
local lang  = require 'language'
local guide = require 'parser.guide'

local function isInString(ast, offset)
    return guide.eachSourceType(ast, 'string', function (source)
        if offset >= source.start and offset <= source.finish then
            return true
        end
    end)
end

local function isInComment(ast, offset)
    for _, com in ipairs(ast.state.comms) do
        if offset >= com.start and offset <= com.finish then
            return true
        end
    end
    return false
end

return function (uri, callback)
    local state = files.getState(uri)
    local text  = files.getText(uri)
    if not state or not text then
        return
    end
    local lines = state.lines
    for i = 0, #lines do
        local startOffset  = lines[i]
        local finishOffset = text:find('[\r\n]', startOffset) or (#text + 1)
        local lastOffset   = finishOffset - 1
        local lastChar     = text:sub(lastOffset, lastOffset)
        if lastChar ~= ' ' and lastChar ~= '\t' then
            goto NEXT_LINE
        end
        local lastPos = guide.offsetToPosition(state, lastOffset)
        if isInString(state.ast, lastPos)
        or isInComment(state.ast, lastPos) then
            goto NEXT_LINE
        end
        local firstOffset = startOffset
        for n = lastOffset - 1, startOffset, -1 do
            local char = text:sub(n, n)
            if char ~= ' ' and char ~= '\t' then
                firstOffset = n + 1
                break
            end
        end
        local firstPos = guide.offsetToPosition(state, firstOffset) - 1
        if firstOffset == startOffset then
            callback {
                start   = firstPos,
                finish  = lastPos,
                message = lang.script.DIAG_LINE_ONLY_SPACE,
            }
        else
            callback {
                start   = firstPos,
                finish  = lastPos,
                message = lang.script.DIAG_LINE_POST_SPACE,
            }
        end
        ::NEXT_LINE::
    end
end
