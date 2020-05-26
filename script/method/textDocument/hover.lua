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
    -- lua是从1开始的，因此都要+1
    local position = lines:positionAsChar(params.position.line + 1, params.position.character)

    local source = core.findSource(vm, position)
    if not source then
        return nil
    end

    local hover = core.hover(source, lsp)
    if not hover then
        return nil
    end

    local text = ([[
```lua
%s
```
```lua
%s
```
%s
```lua
%s
```
%s
]]):format(hover.label or '', hover.overloads or '', hover.description or '', hover.enum or '', hover.doc or '')

    local response = {
        contents = {
            value = text:gsub("```lua\n\n```", ""),
            kind  = 'markdown',
        }
    }

    return response
end
