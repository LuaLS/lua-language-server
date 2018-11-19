local parser = require 'parser'
local matcher = require 'matcher'

return function (lsp, params)
    local uri = params.textDocument.uri
    local text = lsp:loadText(uri)
    if not text then
        return nil, '找不到文件：' .. uri
    end
    -- lua是从1开始的，因此都要+1
    local pos = parser.calcline.position(text, params.position.line + 1, params.position.character + 1)
    local suc, start, finish = matcher.definition(text, pos)
    if not suc then
        return {}
    end

    local start_row,  start_col  = parser.calcline.rowcol(text, start)
    local finish_row, finish_col = parser.calcline.rowcol(text, finish)

    local response = {
        uri = uri,
        range = {
            start = {
                line = start_row - 1,
                character = start_col - 1,
            },
            ['end'] = {
                line = finish_row - 1,
                character = finish_col - 1,
            },
        },
    }
    return response
end
