local matcher = require 'matcher'

local function posToRange(lines, start, finish)
    local start_row,  start_col  = lines:rowcol(start)
    local finish_row, finish_col = lines:rowcol(finish)
    return {
        start = {
            line = start_row - 1,
            character = start_col - 1,
        },
        ['end'] = {
            line = finish_row - 1,
            character = finish_col - 1,
        },
    }
end

return function (lsp, params)
    local uri = params.textDocument.uri
    local vm, lines = lsp:loadVM(uri)
    if not vm then
        return nil
    end
    -- lua是从1开始的，因此都要+1
    local position = lines:position(params.position.line + 1, params.position.character + 1)
    log.debug(table.dump(params.position))
    local items = matcher.completion(vm, position)
    if not items then
        return nil
    end
    if #items == 0 then
        return nil
    end
    for i, item in ipairs(items) do
        item.sortText = ('%04d'):format(i)
        if item.textEdit then
            item.textEdit.range = posToRange(lines, item.textEdit.start, item.textEdit.finish)
            item.textEdit.start = nil
            item.textEdit.finish = nil
        end
    end
    local response = {
        isIncomplete = true,
        items = items,
    }
    log.debug(table.dump(response))
    return response
end
