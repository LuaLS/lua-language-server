local files = require 'files'
local lang  = require 'language'
local guide = require 'parser.guide'

local function isInString(ast, offset)
    local result = false
    guide.eachSourceType(ast, 'string', function (source)
        if offset >= source.start and offset <= source.finish then
            result = true
        end
    end)
    return result
end

return function (uri, callback)
    local state = files.getState(uri)
    if not state then
        return
    end
    local text  = files.getText(uri)
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
        if isInString(state.ast, lastPos) then
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
