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
    local ast   = files.getAst(uri)
    if not ast then
        return
    end
    local text  = files.getText(uri)
    local lines = files.getLines(uri)
    for i = 1, #lines do
        local start  = lines[i].start
        local range  = lines[i].range
        local lastChar = text:sub(range, range)
        if lastChar ~= ' ' and lastChar ~= '\t' then
            goto NEXT_LINE
        end
        if isInString(ast.ast, range) then
            goto NEXT_LINE
        end
        local first = start
        for n = range - 1, start, -1 do
            local char = text:sub(n, n)
            if char ~= ' ' and char ~= '\t' then
                first = n + 1
                break
            end
        end
        if first == start then
            callback {
                start   = first,
                finish  = range,
                message = lang.script.DIAG_LINE_ONLY_SPACE,
            }
        else
            callback {
                start   = first,
                finish  = range,
                message = lang.script.DIAG_LINE_POST_SPACE,
            }
        end
        ::NEXT_LINE::
    end
end
