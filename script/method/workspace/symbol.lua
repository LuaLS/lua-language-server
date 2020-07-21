local matchKey = require 'core.matchKey'

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

local function collect(results, source, uri, lines)
    if source:action() ~= 'set'
    and source:action() ~= 'local' then
        return
    end
    local kind = SymbolKind.Variable
    local value = source:bindValue()
    if value and value:getFunction() then
        kind = SymbolKind.Function
    else
        if source:get 'global' then
            kind = SymbolKind.Namespace
        elseif source:get 'table index' then
            kind = SymbolKind.EnumMember
        end
    end
    results[#results+1] = {
        name = source[1],
        kind = kind,
        location = {
            uri = uri,
            range = convertRange(lines, source),
        }
    }
end

local function searchVM(lsp, results, query, uri)
    local vm, lines = lsp:getVM(uri)
    if not vm then
        return
    end
    vm:eachSource(function (src)
        if src.type == 'name' then
            if src[1] == '' then
                return
            end
            if matchKey(query, src[1]) then
                collect(results, src, uri, lines)
            end
        end
    end)
end

--- @param lsp LSP
--- @param params table
return function (lsp, params)
    local query = params.query
    local results = {}

    for uri in lsp:eachFile() do
        searchVM(lsp, results, query, uri)
    end

    return results
end
