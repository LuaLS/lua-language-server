local matcher = require 'matcher'

return function (lsp, params)
    local uri = params.textDocument.uri
    local vm, lines = lsp:loadVM(uri)
    if not vm then
        return nil
    end
    -- lua是从1开始的，因此都要+1
    local position = lines:position(params.position.line + 1, params.position.character + 1)

    local result, source = matcher.findResult(vm, position)
    if not result then
        return nil
    end

    local hover = matcher.hover(result, source, lsp)
    if not hover then
        return nil
    end

    local text = ([[
```lua
%s
```
%s
```lua
%s
```
]]):format(hover.label or '', hover.description or '', hover.enum or '')

    local response = {
        contents = {
            value = text,
            kind  = 'markdown',
        }
    }

    return response
end
