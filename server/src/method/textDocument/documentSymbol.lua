local matcher = require 'matcher'

local SymbolKind = {
	File = 1,
	Module = 2,
	Namespace = 3,
	Package = 4,
	Class = 5,
	Method = 6,
	Property = 7,
	Field = 8,
	Constructor = 9,
	Enum = 10,
	Interface = 11,
	Function = 12,
	Variable = 13,
	Constant = 14,
	String = 15,
	Number = 16,
	Boolean = 17,
	Array = 18,
	Object = 19,
	Key = 20,
	Null = 21,
	EnumMember = 22,
	Struct = 23,
	Event = 24,
	Operator = 25,
	TypeParameter = 26,
}

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

local function buildFunc(lines, func, nextFunction)
    local source = func.source
    return {
        name = 'name',
        detail = 'hover',
        kind = SymbolKind.Function,
        range = posToRange(lines, source.start, source.finish),
        selectionRange = posToRange(lines, source.start, source.start)
    }
end

return function (lsp, params)
    local uri = params.textDocument.uri
    local vm, lines = lsp:loadVM(uri)
    if not vm then
        return nil
    end

    local i = 0
    local function nextFunction()
        i = i + 1
        local func = vm.results.funcs[i]
        return func
    end

    local symbols = {}
    while true do
        local func = nextFunction()
        if not func then
            break
        end
        symbols[1] = buildFunc(lines, func, nextFunction)
        do break end
    end

    log.debug(table.dump(symbols))

    return symbols
end
