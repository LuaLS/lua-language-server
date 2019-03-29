local hoverFunction = require 'core.hover.function'
local getName = require 'core.name'
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

local function buildLocal(vm, source, used, callback)
    local vars = source[1]
    local exps = source[2]
    if vars.type ~= 'list' then
        vars = {vars}
    end
    if not exps or exps.type ~= 'list' then
        exps = {exps}
    end
    for i, var in ipairs(vars) do
        local exp = exps[i]
        local data = {}
        local loc = var:bindLocal()
        data.name = loc:getName()
        data.range = { var.start, var.finish }
        data.selectionRange = { var.start, var.finish }
        if exp then
            local hvr = hover(var)
            if exp.type == 'function' then
                data.kind = SymbolKind.Function
            else
                data.kind = SymbolKind.Variable
            end
            data.detail = hvr.label:gsub('[\r\n]', '')
            data.valueRange = { exp.start, exp.finish }
            used[exp] = true
        else
            data.kind = SymbolKind.Variable
            data.detail = ''
            data.valueRange = { var.start, var.finish }
        end
        callback(data)
    end
end

local function buildSet(vm, source, used, callback)
    local vars = source[1]
    local exps = source[2]
    if vars.type ~= 'list' then
        vars = {vars}
    end
    if not exps or exps.type ~= 'list' then
        exps = {exps}
    end
    for i, var in ipairs(vars) do
        if var:bindLocal() then
            goto CONTINUE
        end
        local exp = exps[i]
        local data = {}
        data.name = getName(var)
        data.range = { var.start, var.finish }
        data.selectionRange = { var.start, var.finish }
        if exp then
            local hvr = hover(var)
            if not hvr then
                goto CONTINUE
            end
            if exp.type == 'function' then
                data.kind = SymbolKind.Function
            else
                data.kind = SymbolKind.Property
            end
            data.detail = hvr.label:gsub('[\r\n]', '')
            data.valueRange = { exp.start, exp.finish }
            used[exp] = true
        else
            data.kind = SymbolKind.Property
            data.detail = ''
            data.valueRange = { var.start, var.finish }
        end
        callback(data)
        :: CONTINUE ::
    end
end

local function buildPair(vm, source, used, callback)
    local var = source[1]
    local exp = source[2]
    local data = {}
    data.name = getName(var)
    data.range = { var.start, var.finish }
    data.selectionRange = { var.start, var.finish }
    if exp then
        local hvr = hover(var)
        if not hvr then
            return
        end
        if exp.type == 'function' then
            data.kind = SymbolKind.Function
        else
            data.kind = SymbolKind.Class
        end
        data.detail = hvr.label:gsub('[\r\n]', '')
        data.valueRange = { exp.start, exp.finish }
        used[exp] = true
    else
        data.kind = SymbolKind.Class
        data.detail = ''
        data.valueRange = { var.start, var.finish }
    end
    callback(data)
end

local function buildLocalFunction(vm, source, used, callback)
    local value = source:bindFunction()
    if not value then
        return
    end
    local name = getName(source.name)
    local hvr = hoverFunction(name, value:getFunction())
    if not hvr then
        return
    end
    local kind = SymbolKind.Function
    callback {
        name = name,
        detail = hvr.label:gsub('[\r\n]', ''),
        kind = kind,
        range = { source.start, source.finish },
        selectionRange = { source.name.start, source.name.finish },
        valueRange = { source.start, source.finish },
    }
end


local function buildFunction(vm, source, used, callback)
    if used[source] then
        return
    end
    local value = source:bindFunction()
    if not value then
        return
    end
    local name = getName(source.name)
    local func = value:getFunction()
    if not func then
        return
    end
    local hvr = hoverFunction(name, func, func:getObject())
    if not hvr then
        return
    end
    local data = {}
    data.name = name
    data.detail = hvr.label:gsub('[\r\n]', '')
    data.range = { source.start, source.finish }
    data.valueRange = { source.start, source.finish }
    if source.name then
        data.selectionRange = { source.name.start, source.name.finish }
    else
        data.selectionRange = { source.start, source.start }
    end
    if func:getObject() then
        data.kind = SymbolKind.Field
    else
        data.kind = SymbolKind.Function
    end
    callback(data)
end

local function buildSource(vm, source, used, callback)
    if source.type == 'local' then
        buildLocal(vm, source, used, callback)
        return
    end
    if source.type == 'set' then
        buildSet(vm, source, used, callback)
        return
    end
    if source.type == 'pair' then
        buildPair(vm, source, used, callback)
        return
    end
    if source.type == 'localfunction' then
        buildLocalFunction(vm, source, used, callback)
        return
    end
    if source.type == 'function' then
        buildFunction(vm, source, used, callback)
        return
    end
end

local function packChild(symbols, finish, kind)
    local t
    while true do
        local symbol = symbols[#symbols]
        if not symbol then
            break
        end
        if symbol.valueRange[1] > finish then
            break
        end
        symbols[#symbols] = nil
        symbol.children = packChild(symbols, symbol.valueRange[2], symbol.kind)
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
    return packChild(symbols, math.maxinteger, SymbolKind.Function)
end

return function (vm)
    local symbols = {}
    local used = {}

    vm:eachSource(function (source)
        buildSource(vm, source, used, function (data)
            symbols[#symbols+1] = data
        end)
    end)

    local packedSymbols = packSymbols(symbols)

    return packedSymbols
end
