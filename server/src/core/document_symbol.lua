local hoverFunction = require 'core.hover_function'
local hoverName = require 'core.hover_name'
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

local function buildFunction(vm, func)
    local source = func.source
    local declarat = func.declarat
    local name
    local var
    if declarat then
        if declarat.type == 'function' then
            var = vm.results.sources[declarat.name]
        else
            var = vm.results.sources[declarat]
        end
    end
    if var then
        name = hoverName(var, declarat)
    else
        name = ''
    end
    local hvr = hoverFunction(name, func, declarat and declarat.object)
    if not hvr then
        return
    end
    local selectionRange
    local range
    local kind = SymbolKind.Function
    if var then
        range = { math.min(source.start, declarat.start), source.finish }
        selectionRange = { declarat.start, declarat.finish }
        if var.parent and var.parent.value and not var.parent.value.ENV then
            kind = SymbolKind.Field
        end
    else
        range = { source.start, source.finish }
        selectionRange = { source.start, source.start }
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

local function buildLocal(vm, loc)
    if loc.source.start == 0 then
        return nil
    end
    if loc.value and loc.value.type == 'function' then
        return nil
    end
    local range = { loc.source.start, loc.source.finish }
    local hvr = hover(loc, loc.source)
    return {
        name = loc.key,
        detail = hvr.label,
        kind = SymbolKind.Variable,
        range = range,
        selectionRange = range,
    }
end

local function packChild(symbols, finish)
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
        symbol.children = packChild(symbols, symbol.range[2])
        if not t then
            t = {}
        end
        t[#t+1] = symbol
    end
    return t
end

local function packSymbols(symbols)
    -- 按照start位置反向排序
    table.sort(symbols, function (a, b)
        return a.range[1] > b.range[1]
    end)
    -- 处理嵌套
    return packChild(symbols, math.maxinteger)
end

return function (vm)
    local symbols = {}

    for _, func in ipairs(vm.results.funcs) do
        symbols[#symbols+1] = buildFunction(vm, func)
    end
    for _, loc in ipairs(vm.results.locals) do
        symbols[#symbols+1] = buildLocal(vm, loc)
    end

    local packedSymbols = packSymbols(symbols)

    return packedSymbols
end
