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

--- @param lsp LSP
--- @param params table
--- @return function
return function (lsp, params)
    local uri = params.textDocument.uri

    if timerCache[uri] then
        timerCache[uri]:remove()
        timerCache[uri] = nil
    end

    return function (response)
        local clock = os.clock()
        timerCache[uri] = ac.loop(0.1, function (t)
            local vm, lines = lsp:getVM(uri)
            if not vm then
                if os.clock() - clock > 10 then
                    t:remove()
                    timerCache[uri] = nil
                    response(nil)
                end
                return
            end

            t:remove()
            timerCache[uri] = nil

            local symbols = core.documentSymbol(vm)
            if not symbols then
                response(nil)
                return
            end

            for _, symbol in ipairs(symbols) do
                convertRange(lines, symbol)
            end

            response(symbols)
        end)
    end
end
