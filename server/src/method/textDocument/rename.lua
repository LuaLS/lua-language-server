local parser = require 'parser'
local matcher = require 'matcher'

return function (lsp, params)
    local uri = params.textDocument.uri
    local newName = params.newName
    local results, lines = lsp:loadText(uri)
    if not results then
        return {}
    end
    -- lua是从1开始的，因此都要+1
    local position = lines:position(params.position.line + 1, params.position.character + 1, 'utf8')
    local positions = matcher.rename(results, position)
    if not positions then
        return {}
    end

    local TextEdit = {}
    for i, position in ipairs(positions) do
        local start, finish = position[1], position[2]
        local start_row,  start_col  = lines:rowcol(start,  'utf8')
        local finish_row, finish_col = lines:rowcol(finish, 'utf8')
        TextEdit[i] = {
            newText = newName,
            range = {
                start = {
                    line = start_row - 1,
                    character = start_col - 1,
                },
                ['end'] = {
                    line = finish_row - 1,
                    -- 这里不用-1，因为前端期待的是匹配完成后的位置
                    character = finish_col,
                },
            }
        }
    end

    local response = {
        changes = {
            [uri] = TextEdit,
        },
    }

    return response
end
