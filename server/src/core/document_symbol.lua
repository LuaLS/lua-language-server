local hoverFunction = require 'core.hover_function'
local hoverName = require 'core.hover_name'

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

local function buildFunc(vm, func)
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
    local hover = hoverFunction(name, func, declarat and declarat.object)
    if not hover then
        return
    end
    local selectionRange
    local range
    local kind = SymbolKind.Function
    if var then
        range = { math.min(source.start, declarat.start), source.finish }
        selectionRange = { declarat.start, declarat.finish }
        if var.parent and var.parent.value and not var.parent.value.ENV then
            kind = SymbolKind.Method
        end
    else
        range = { source.start, source.finish }
        selectionRange = { source.start, source.start }
    end

    return {
        name = name,
        -- 前端不支持多行
        detail = hover.label:gsub('[\r\n]', ''),
        kind = kind,
        range = range,
        selectionRange = selectionRange,
    }
end

return function (vm)
    local symbols = {}
    for _, func in ipairs(vm.results.funcs) do
        symbols[#symbols+1] = buildFunc(vm, func)
    end

    return symbols
end
