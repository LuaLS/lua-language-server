local core = require 'core'

--- @param lsp LSP
--- @param params table
--- @return table
return function (lsp, params)
    local uri = params.textDocument.uri
    local vm, lines = lsp:loadVM(uri)
    if not vm then
        return nil
    end
    local position = lines:positionAsChar(params.position.line + 1, params.position.character)
    local positions = core.highlight(vm, position)
    if not positions then
        return nil
    end

    local result = {}
    for i, position in ipairs(positions) do
        local start, finish = position[1], position[2]
        local start_row,  start_col  = lines:rowcol(start)
        local finish_row, finish_col = lines:rowcol(finish)
        result[i] = {
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
            },
            kind = position[3],
        }
    end

    return result
end
