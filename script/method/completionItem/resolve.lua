return function (lsp, item)
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
    local lastRow = lines[math.min(row + 5, #lines)]
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
