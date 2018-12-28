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

local function buildFunc(vm, func, nextFunction, nextFinish)
    local source = func.source
    local var = vm.results.sources[source.name] or vm.results.sources[source]
    if not var then
        return
    end
    local hvr = hover(var, source.name or source)
    if not hvr then
        return
    end
    return {
        name = hvr.name,
        -- 前端不支持多行
        detail = hvr.label:gsub('[\r\n]', ''),
        kind = SymbolKind.Function,
        range = { source.start, source.finish },
        selectionRange = { source.name.start, source.name.finish },
    }
end

return function (vm)
    local i = 0
    local function nextFunction()
        i = i + 1
        local func = vm.results.funcs[i]
        return func
    end

    local function nextFinish()
        local func = vm.results.funcs[i+1]
        if not func then
            return 0
        end
        return func.source.finish
    end

    local symbols = {}
    while true do
        local func = nextFunction()
        if not func then
            break
        end
        symbols[#symbols+1] = buildFunc(vm, func, nextFunction, nextFinish)
    end

    return symbols
end
