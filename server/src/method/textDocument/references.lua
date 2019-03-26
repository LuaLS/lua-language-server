local core = require 'core'
local LastTask

return function (lsp, params)
    local uri = params.textDocument.uri
    local declarat = params.context.includeDeclaration
    local vm, lines = lsp:loadVM(uri)
    if not vm then
        return nil
    end

    if LastTask then
        LastTask:remove()
        LastTask = nil
    end

    -- lua是从1开始的，因此都要+1
    local position = lines:positionAsChar(params.position.line + 1, params.position.character)

    return function (response)
        LastTask = ac.timer(0.1, 100, function (t)
            if lsp:isWaitingCompile() then
                return
            end
            t:remove()
            vm, lines = lsp:getVM(uri)

            local positions = core.references(vm, position, declarat)
            if not positions then
                response(nil)
                return
            end

            local locations = {}
            for i, position in ipairs(positions) do
                local start, finish, valueUri = position[1], position[2], (position[3] or uri)
                local _, valueLines = lsp:getVM(valueUri)
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

            if #locations == 0 then
                response(nil)
                return
            end

            response(locations)
        end)
    end
end
