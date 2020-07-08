local core = require 'core'
local config = require 'config'

local function convertRange(lines, range)
    local start_row,  start_col  = lines:rowcol(range.start)
    local finish_row, finish_col = lines:rowcol(range.finish)
    local result = {
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
    return result
end

--- @param lsp LSP
--- @param params table
--- @return table
return function (lsp, params)
    if not config.config.hover.enable then
        return nil
    end
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
        },
        range = hover.range and convertRange(lines, hover.range),
    }

    return response
end
