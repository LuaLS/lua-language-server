local hoverFunction = require 'core.hover.function'
local hoverName = require 'core.hover.name'
local hover = require 'core.hover'

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

local function buildFunction(vm, var, source)
    local func = var.value
    if func.source.start == 0 then
        return nil
    end
    local name = hoverName(var, source)
    local hvr = hoverFunction(name, func, source.object)
    if not hvr then
        return nil
    end
    local selectionRange = { source.start, source.finish }
    local range = { math.min(source.start, func.source.start), func.source.finish }
    local kind = SymbolKind.Function
    if source.isSuffix then
        kind = SymbolKind.Field
    end

    return {
        name = name,
        -- 前端不支持多行
        detail = hvr.label:gsub('[\r\n]', ''),
        kind = kind,
        range = range,
        selectionRange = selectionRange,
    }
end

local function isLocalTable(var, source)
    if not var.value or var.value:getType() ~= 'table' then
        return false
    end
    if var.value.source.start == 0 then
        return false
    end
    if source ~= var.value:getDeclarat() then
        return false
    end
    if var.value.source.finish < source.finish then
        return false
    end
    return true
end

local function buildVar(vm, var, source)
    if source.start == 0 then
        return nil
    end
    if var.value:getType() == 'function' then
        return buildFunction(vm, var, source)
    end
    if not source.isLocal and not source.isIndex then
        return nil
    end
    if var.hide then
        return nil
    end
    local key = var.key
    if key == '_' then
        return nil
    end
    if type(key) ~= 'string' then
        key = ('[%s]'):format(key)
    end
    local range
    if isLocalTable(var, source) then
        range = { source.start, var.value.source.finish }
    else
        range = { source.start, source.finish }
    end
    local hvr = hover(var, source)
    if not hvr then
        return nil
    end
    local kind
    if source.isIndex then
        kind = SymbolKind.Class
    else
        kind = SymbolKind.Variable
    end
    return {
        name = key,
        -- 前端不支持多行
        detail = hvr.label:gsub('[\r\n]', ''),
        kind = kind,
        range = range,
        selectionRange = { source.start, source.finish },
    }
end

local function packChild(symbols, finish, kind)
    local t
    while true do
        local symbol = symbols[#symbols]
        if not symbol then
            break
        end
        if symbol.range[1] > finish then
            break
        end
        symbols[#symbols] = nil
        symbol.children = packChild(symbols, symbol.range[2], symbol.kind)
        if symbol.kind == SymbolKind.Class and kind == SymbolKind.Function then
        else
            if not t then
                t = {}
            end
            t[#t+1] = symbol
        end
    end
    return t
end

local function packSymbols(symbols)
    -- 按照start位置反向排序
    table.sort(symbols, function (a, b)
        return a.range[1] > b.range[1]
    end)
    -- 处理嵌套
    return packChild(symbols, math.maxinteger, SymbolKind.Function)
end

return function (vm)
    local symbols = {}

    for _, source in ipairs(vm.results.sources) do
        if source.bind then
            symbols[#symbols+1] = buildVar(vm, source.bind, source)
        end
    end

    local packedSymbols = packSymbols(symbols)

    return packedSymbols
end
