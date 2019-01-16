local core = require 'core'

local function checkWorkSpaceComplete(lsp, result)
    if result.value then
        if not result.value.isRequire then
            return
        end
    else
        if not result.isRequire then
            return
        end
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
    local position = lines:position(params.position.line + 1, params.position.character + 1)
    local result = core.findResult(vm, position)
    if not result then
        return nil
    end

    checkWorkSpaceComplete(lsp, result)

    local positions = core.implementation(vm, result, lsp)
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
