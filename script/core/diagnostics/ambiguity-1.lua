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
    ['integer'] = true,
    ['boolean'] = true,
    ['string']  = true,
    ['table']   = true,
}

return function (uri, callback)
    local state = files.getState(uri)
    local text = files.getText(uri)
    if not state or not text then
        return
    end
    guide.eachSourceType(state.ast, 'binary', function (source)
        if source.op.type ~= 'or' then
            return
        end
        local first  = source[1]
        local second = source[2]
        if not first or not second then
            return
        end
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
                    message = lang.script('DIAG_AMBIGUITY_1', text:sub(
                                guide.positionToOffset(state, first.start + 1),
                                guide.positionToOffset(state, first.finish)
                              ))
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
                    message = lang.script('DIAG_AMBIGUITY_1', text:sub(
                                guide.positionToOffset(state, second.start + 1),
                                guide.positionToOffset(state, second.finish)
                              ))
                }
            end
        end
    end)
end
