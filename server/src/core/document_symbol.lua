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

local function buildLocal(vm, source, callback)
    local loc = source:bindLocal()
    local value = loc:getInitValue()
    local hvr = hover(source)
    if not hvr then
        return
    end
    local kind
    if value:getType() == 'function' then
        kind = SymbolKind.Function
    elseif source:get 'table index' then
        kind = SymbolKind.Class
    else
        kind = SymbolKind.Variable
    end
    local valueSource = value.source
    if valueSource.start == 0 or value.uri ~= vm.uri then
        valueSource = source
    end
    local name = hvr.name
    if vm.uri ~= value.uri then
        name = tostring(source[1] or '')
    end
    -- 由于范围不允许交叉，为了支持 local x, y, z = 1, 2, 3 的形式
    -- 范围只能限定在变量上
    -- 而 local function xx() 的形式范围会包含整个 function
    if source.start > valueSource.start then
        callback {
            name = name,
            detail = hvr.label:gsub('[\r\n]', ''),
            kind = kind,
            range = { valueSource.start, valueSource.finish },
            selectionRange = { source.start, source.finish },
            valueRange = { valueSource.start, valueSource.finish },
        }
    else
        callback {
            name = name,
            detail = hvr.label:gsub('[\r\n]', ''),
            kind = kind,
            range = { source.start, source.finish },
            selectionRange = { source.start, source.finish },
            valueRange = { valueSource.start, valueSource.finish },
        }
    end
end

local function buildSet(vm, source, callback)
    if source:bindLocal() then
        return
    end
    local value = source:bindValue()
    local hvr = hover(source)
    if not hvr then
        return
    end
    local kind
    if value:getFunction() then
        local func = value:getFunction()
        if func:getObject() then
            kind = SymbolKind.Field
        else
            kind = SymbolKind.Function
        end
    elseif source:get 'table index' then
        kind = SymbolKind.Class
    else
        kind = SymbolKind.Object
    end
    local valueSource = value.source
    if valueSource.start == 0 or value.uri ~= vm.uri then
        valueSource = source
    end
    local name = hvr.name
    if vm.uri ~= value.uri then
        name = tostring(source[1] or '')
    end
    -- 由于范围不允许交叉，为了支持 x, y, z = 1, 2, 3 的形式
    -- 范围只能限定在变量上
    -- 而 function xx() 的形式范围会包含整个 function
    if source.start > valueSource.start then
        callback {
            name = name,
            -- 前端不支持多行
            detail = hvr.label:gsub('[\r\n]', ''),
            kind = kind,
            range = { valueSource.start, valueSource.finish },
            selectionRange = { source.start, source.finish },
            valueRange = { valueSource.start, valueSource.finish },
        }
    else
        callback {
            name = name,
            -- 前端不支持多行
            detail = hvr.label:gsub('[\r\n]', ''),
            kind = kind,
            range = { source.start, source.finish },
            selectionRange = { source.start, source.finish },
            valueRange = { valueSource.start, valueSource.finish },
        }
    end
end

local function buildReturn(vm, source, callback)
    local value = source:bindFunction()
    if not value then
        return
    end
    local hvr = hoverFunction('', value:getFunction())
    if not hvr then
        return
    end
    local kind = SymbolKind.Function
    callback {
        name = '',
        -- 前端不支持多行
        detail = hvr.label:gsub('[\r\n]', ''),
        kind = kind,
        range = { source.start, source.finish },
        selectionRange = { source.start, source.start },
        valueRange = { source.start, source.finish },
    }
end

local function buildSource(vm, source, callback)
    if source:action() == 'local' then
        buildLocal(vm, source, callback)
        return
    end
    if source:action() == 'set' then
        buildSet(vm, source, callback)
        return
    end
    if source.type == 'return' then
        for _, src in ipairs(source) do
            buildReturn(vm, src, callback)
        end
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
        return a.valueRange[1] > b.valueRange[1]
    end)
    -- 处理嵌套
    return packChild(symbols, math.maxinteger, SymbolKind.Function)
end

return function (vm)
    local symbols = {}

    for _, source in ipairs(vm.sources) do
        buildSource(vm, source, function (data)
            symbols[#symbols+1] = data
        end)
    end

    local packedSymbols = packSymbols(symbols)

    return packedSymbols
end
