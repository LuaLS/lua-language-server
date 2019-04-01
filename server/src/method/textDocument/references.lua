local core = require 'core'
local LastTask

local function findReferences(lsp, uri, position, declarat)
    local vm = lsp:getVM(uri)

    local positions = core.references(vm, position, declarat)
    if not positions then
        return nil
    end

    local locations = {}
    for i, position in ipairs(positions) do
        local start, finish, valueUri = position[1], position[2], (position[3] or uri)
        local _, valueLines = lsp:getVM(valueUri)
        if valueLines then
            local start_row,  start_col  = valueLines:rowcol(start)
            local finish_row, finish_col = valueLines:rowcol(finish)
            locations[#locations] = {
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
        else
            locations[#locations] = {
                uri =  valueUri,
                range = {
                    start = {
                        line = 0,
                        character = 0,
                    },
                    ['end'] = {
                        line = 0,
                        character = 0,
                    },
                }
            }
        end
    end

    if #locations == 0 then
        return nil
    end

    return locations
end

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
        LastTask = ac.loop(0.1, function (t)
            local positions = findReferences(lsp, uri, position, declarat)
            if positions then
                response(positions)
            end
            if lsp:isWaitingCompile() then
                return
            end
            t:remove()
            LastTask = nil
            if not positions then
                response(nil)
            end
        end)
    end
end
