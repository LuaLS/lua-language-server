local core = require 'core'

--- @param lsp LSP
--- @param params table
--- @return table
return function (lsp, params)
    local uri = params.textDocument.uri
    local newName = params.newName
    local vm, lines = lsp:loadVM(uri)
    if not vm then
        return {}
    end
    local position = lines:positionAsChar(params.position.line + 1, params.position.character)
    local positions = core.rename(vm, position, newName)
    if not positions then
        return {}
    end

    local changes = {}
    for _, position in ipairs(positions) do
        local start, finish, uri = position[1], position[2], position[3]
        local _, lines = lsp:getVM(uri)
        if not lines then
            goto CONTINUE
        end
        local start_row,  start_col  = lines:rowcol(start)
        local finish_row, finish_col = lines:rowcol(finish)
        if not changes[uri] then
            changes[uri] = {}
        end
        changes[uri][#changes[uri]+1] = {
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
        ::CONTINUE::
    end

    local response = {
        changes = changes,
    }

    return response
end
