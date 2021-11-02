local files     = require 'files'
local guide     = require 'parser.guide'
local proto     = require 'proto'
local lang      = require 'language'
local converter = require 'proto.converter'

local function isInString(ast, offset)
    return guide.eachSourceContain(ast.ast, offset, function (source)
        if source.type == 'string' then
            return true
        end
    end) or false
end

---@async
return function (data)
    local uri   = data.uri
    local text  = files.getText(uri)
    local state = files.getState(uri)
    if not state then
        return
    end

    local lines = state.lines
    local textEdit = {}
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
        textEdit[#textEdit+1] = {
            range = converter.packRange(uri, firstPos, lastPos),
            newText = '',
        }

        ::NEXT_LINE::
    end

    if #textEdit == 0 then
        return
    end

    proto.awaitRequest('workspace/applyEdit', {
        label = lang.script.COMMAND_REMOVE_SPACE,
        edit = {
            changes = {
                [uri] = textEdit,
            }
        },
    })
end
