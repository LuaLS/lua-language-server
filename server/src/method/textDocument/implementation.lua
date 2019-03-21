local core = require 'core'

local function checkWorkSpaceComplete(lsp, source)
    if not source:bindValue() then
        return
    end
    if not source:bindValue():get 'cross file' then
        return
    end
    lsp:checkWorkSpaceComplete()
end

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

    checkWorkSpaceComplete(lsp, source)

    local positions = core.implementation(vm, source, lsp)
    if not positions then
        return nil
    end

    local locations = {}
    for i, position in ipairs(positions) do
        local start, finish, valueUri = position[1], position[2], (position[3] or uri)
        local _, valueLines = lsp:loadVM(valueUri)
        if valueLines then
            local start_row,  start_col  = valueLines:rowcol(start)
            local finish_row, finish_col = valueLines:rowcol(finish)
            locations[i] = {
                uri =  valueUri,
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
    end

    local response = locations

    return response
end
