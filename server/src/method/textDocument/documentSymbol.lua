local core = require 'core'
local lang = require 'language'

local timerCache = {}

local function posToRange(lines, start, finish)
    local start_row,  start_col  = lines:rowcol(start)
    local finish_row, finish_col = lines:rowcol(finish)
    return {
        start = {
            line = start_row - 1,
            character = start_col - 1,
        },
        ['end'] = {
            line = finish_row - 1,
            character = finish_col,
        },
    }
end

local function convertRange(lines, symbol)
    symbol.range = posToRange(lines, symbol.range[1], symbol.range[2])
    symbol.selectionRange = posToRange(lines, symbol.selectionRange[1], symbol.selectionRange[2])
    if symbol.name == '' then
        symbol.name = lang.script.SYMBOL_ANONYMOUS
    end

    if symbol.children then
        for _, child in ipairs(symbol.children) do
            convertRange(lines, child)
        end
    end
end

return function (lsp, params)
    local uri = params.textDocument.uri

    if timerCache[uri] then
        timerCache[uri]:remove()
        timerCache[uri] = nil
    end

    local vm, lines = lsp:loadVM(uri)
    if not vm then
        return nil
    end

    return function (response)
        local co = coroutine.create(function ()
            return core.documentSymbol(vm)
        end)
        timerCache[uri] = ac.loop(0.001, function (t)
            local suc, res = coroutine.resume(co)
            if not suc then
                t:remove()
                error(res)
                return
            end
            if coroutine.status(co) == 'suspended' then
                return
            end

            t:remove()
            if not res then
                response(nil)
            end

            for _, symbol in ipairs(res) do
                convertRange(lines, symbol)
            end

            response(res)
        end)
    end
end
