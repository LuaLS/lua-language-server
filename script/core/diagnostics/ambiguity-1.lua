local files = require 'files'
local guide = require 'parser.guide'
local lang  = require 'language'

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

return function (uri, callback)
    local ast = files.getAst(uri)
    if not ast then
        return
    end
    local text = files.getText(uri)
    guide.eachSourceType(ast.ast, 'binary', function (source)
        if source.op.type ~= 'or' then
            return
        end
        local first  = source[1]
        local second = source[2]
        -- a + (b or 0) --> (a + b) or 0
        do
            if opMap[first.op and first.op.type]
                and first.type ~= 'unary'
                and not second.op
                and literalMap[second.type]
                and not literalMap[first[2].type]
            then
                callback {
                    start   = source.start,
                    finish  = source.finish,
                    message = lang.script('DIAG_AMBIGUITY_1', text:sub(first.start, first.finish))
                }
            end
        end
        -- (a or 0) + c --> a or (0 + c)
        do
            if opMap[second.op and second.op.type]
                and second.type ~= 'unary'
                and not first.op
                and literalMap[second[1].type]
            then
                callback {
                    start   = source.start,
                    finish  = source.finish,
                    message = lang.script('DIAG_AMBIGUITY_1', text:sub(second.start, second.finish))
                }
            end
        end
    end)
end
