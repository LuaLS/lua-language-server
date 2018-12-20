local matcher = require 'matcher'

return function (lsp, params)
    local uri = params.textDocument.uri
    local vm, lines = lsp:loadVM(uri)
    if not vm then
        return {}
    end
    -- lua是从1开始的，因此都要+1
    local position = lines:position(params.position.line + 1, params.position.character + 1)
    local items = matcher.completion(vm, position)
    if not items then
        return nil
    end
    if #items == 0 then
        return nil
    end
    for i, item in ipairs(items) do
        item.sortText = ('%04d'):format(i)
    end
    if items[5] then
    items[5].preselect = true
    end
    local response = {
        isIncomplete = true,
        items = items,
    }
    return response
end
