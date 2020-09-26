local files  = require 'files'
local define = require 'proto.define'
local guide  = require 'parser.guide'
local proto  = require 'proto'
local lang   = require 'language'

local function isInString(ast, offset)
    return guide.eachSourceContain(ast.ast, offset, function (source)
        if source.type == 'string' then
            return true
        end
    end) or false
end

return function (data)
    local uri   = data.uri
    local lines = files.getLines(uri)
    local text  = files.getText(uri)
    local ast   = files.getAst(uri)
    if not lines then
        return
    end

    local textEdit = {}
    for i = 1, #lines do
        local line = guide.lineContent(lines, text, i, true)
        local pos  = line:find '[ \t]+$'
        if pos then
            local start, finish = guide.lineRange(lines, i, true)
            start = start + pos - 1
            if isInString(ast, start) then
                goto NEXT_LINE
            end
            textEdit[#textEdit+1] = {
                range = define.range(lines, text, start, finish),
                newText = '',
            }
            goto NEXT_LINE
        end

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
