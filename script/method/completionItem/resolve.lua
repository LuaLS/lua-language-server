local config = require 'config'

return function (lsp, item)
    local context = config.config.completion.displayContext
    if context <= 0 then
        return item
    end
    if not item.data then
        return item
    end
    local offset = item.data.offset
    local uri   = item.data.uri
    local _, lines, text = lsp:getVM(uri)
    if not lines then
        return item
    end
    local row = lines:rowcol(offset)
    local firstRow = lines[row]
    local lastRow = lines[math.min(row + context - 1, #lines)]
    local snip = text:sub(firstRow.start, lastRow.finish)
    local document = ([[
%s

------------
```lua
%s
```
]]):format(item.documentation and item.documentation.value or '', snip)
    item.documentation = {
        kind  = 'markdown',
        value = document,
    }
    return item
end
