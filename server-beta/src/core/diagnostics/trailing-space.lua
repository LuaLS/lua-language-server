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
    local lines = files.getLines(uri)
    local text  = files.getText(uri)

    for i = 1, #lines do
        local start  = lines[i].start + 1
        local finish = lines[i].finish - 1
        local line = text:sub(start, finish)
        if line:find '^[ \t]+[\r\n]*$' then
            local offset = guide.offsetOf(lines, i-1, start-1)
            if isInString(ast.ast, offset) then
                goto NEXT_LINE
            end
            callback {
                start   = start,
                finish  = finish,
                message = lang.script.DIAG_LINE_ONLY_SPACE,
            }
            goto NEXT_LINE
        end

        local pos = line:find '[ \t]+[\r\n]*$'
        if pos then
            start = start + pos - 1
            local offset = guide.offsetOf(lines, i-1, start-1)
            if isInString(ast.ast, offset) then
                goto NEXT_LINE
            end
            callback {
                start   = start,
                finish  = finish,
                message = lang.script.DIAG_LINE_POST_SPACE,
            }
            goto NEXT_LINE
        end

        ::NEXT_LINE::
    end
end
