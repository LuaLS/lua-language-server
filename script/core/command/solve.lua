local files  = require 'files'
local define = require 'proto.define'
local guide  = require 'parser.guide'
local proto  = require 'proto'
local lang   = require 'language'

local opMap = {
    ['+']  = true,
    ['-']  = true,
    ['*']  = true,
    ['/']  = true,
    ['//'] = true,
    ['^']  = true,
    ['<<'] = true,
    ['>>'] = true,
    ['&']  = true,
    ['|']  = true,
    ['~']  = true,
    ['..'] = true,
}

local literalMap = {
    ['number']  = true,
    ['boolean'] = true,
    ['string']  = true,
    ['table']   = true,
}

return function (data)
    local uri   = data.uri
    local text  = files.getText(uri)
    local ast   = files.getAst(uri)
    if not ast then
        return
    end

    local start  = files.offsetOfWord(uri, data.range.start)
    local finish = files.offsetOfWord(uri, data.range['end'])

    local result = guide.eachSourceContain(ast.ast, start, function (source)
        if source.start ~= start
        or source.finish ~= finish then
            return
        end
        if not source.op or source.op.type ~= 'or' then
            return
        end
        local first  = source[1]
        local second = source[2]
        -- a + b or 0 --> a + (b or 0)
        do
            if  first.op
            and opMap[first.op.type]
            and first.type ~= 'unary'
            and not second.op
            and literalMap[second.type] then
                return {
                    start  = source[1][2].start,
                    finish = source[2].finish,
                }
            end
        end
        -- a or b + c --> (a or b) + c
        do
            if  second.op
            and opMap[second.op.type]
            and second.type ~= 'unary'
            and not first.op
            and literalMap[second[1].type] then
                return {
                    start  = source[1].start,
                    finish = source[2][1].finish,
                }
            end
        end
    end)

    if not result then
        return
    end

    proto.awaitRequest('workspace/applyEdit', {
        label = lang.script.COMMAND_REMOVE_SPACE,
        edit = {
            changes = {
                [uri] = {
                    {
                        range   = files.range(uri, result.start, result.finish),
                        newText = ('(%s)'):format(text:sub(result.start, result.finish)),
                    }
                },
            }
        },
    })
end
