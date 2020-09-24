local files = require 'files'
local guide = require 'parser.guide'
local skind = require 'define.SymbolKind'
local lname = require 'core.hover.name'
local util  = require 'utility'
local await = require 'await'

local function buildFunctionParams(func)
    if not func.args then
        return ''
    end
    local params = {}
    for i, arg in ipairs(func.args) do
        if arg.type == '...' then
            params[i] = '...'
        else
            params[i] = arg[1] or ''
        end
    end
    return table.concat(params, ', ')
end

local function buildFunction(source, symbols)
    local name = lname(source)
    local func = source.value
    local range, kind
    if func.start > source.finish then
        -- a = function()
        range = { source.start, func.finish }
    else
        -- function f()
        range = { func.start, func.finish }
    end
    if source.type == 'setmethod' then
        kind = skind.Field
    else
        kind = skind.Function
    end
    symbols[#symbols+1] = {
        name           = name,
        detail         = ('function %s(%s)'):format(name or '', buildFunctionParams(func)),
        kind           = kind,
        range          = range,
        selectionRange = { source.start, source.finish },
        valueRange     = { func.start, func.finish },
    }
end

local function buildTable(tbl)
    local buf = {}
    for i = 1, 3 do
        local field = tbl[i]
        if not field then
            break
        end
        if field.type == 'tablefield' then
            buf[i] = ('%s'):format(field.field[1])
        end
    end
    return table.concat(buf, ', ')
end

local function buildValue(source, symbols)
    local name  = lname(source)
    local range, sRange, valueRange, kind
    local details = {}
    if source.type == 'local' then
        if source.parent.type == 'funcargs' then
            details[1] = 'param '
            range      = { source.start, source.finish }
            sRange     = { source.start, source.finish }
            kind       = skind.Constant
        else
            details[1] = 'local '
            range      = { source.start, source.finish }
            sRange     = { source.start, source.finish }
            kind       = skind.Variable
        end
    elseif source.type == 'setlocal' then
        details[1] = 'setlocal '
        range      = { source.start, source.finish }
        sRange     = { source.start, source.finish }
        kind       = skind.Variable
    elseif source.type == 'setglobal' then
        details[1] = 'global '
        range      = { source.start, source.finish }
        sRange     = { source.start, source.finish }
        kind       = skind.Constant
    elseif source.type == 'tablefield' then
        details[1] = 'field '
        range      = { source.field.start, source.field.finish }
        sRange     = { source.field.start, source.field.finish }
        kind       = skind.Property
    else
        details[1] = 'field '
        range      = { source.field.start, source.field.finish }
        sRange     = { source.field.start, source.field.finish }
        kind       = skind.Field
    end
    details[2] = name
    if source.value then
        local literal = source.value[1]
        if source.value.type == 'boolean' then
            details[3] = ': boolean'
            if literal ~= nil then
                details[4] = ' = '
                details[5] = util.viewLiteral(source.value[1])
            end
        elseif source.value.type == 'string' then
            details[3] = ': string'
            if literal ~= nil then
                details[4] = ' = '
                details[5] = util.viewLiteral(source.value[1])
            end
        elseif source.value.type == 'number' then
            details[3] = ': number'
            if literal ~= nil then
                details[4] = ' = '
                details[5] = util.viewLiteral(source.value[1])
            end
        elseif source.value.type == 'table' then
            details[3] = ': {'
            details[4] = buildTable(source.value)
            details[5] = '}'
        end
        range      = { range[1], source.value.finish }
        valueRange = { source.value.start, source.value.finish }
    else
        valueRange = range
    end
    symbols[#symbols+1] = {
        name           = name,
        detail         = table.concat(details),
        kind           = kind,
        range          = range,
        selectionRange = sRange,
        valueRange     = valueRange,
    }
end

local function buildSet(source, used, symbols)
    local value = source.value
    if value and value.type == 'function' then
        used[value] = true
        buildFunction(source, symbols)
    else
        buildValue(source, symbols)
    end
end

local function buildAnonymousFunction(source, used, symbols)
    if used[source] then
        return
    end
    used[source] = true
    symbols[#symbols+1] = {
        name           = '',
        detail         = 'function ()',
        kind           = skind.Function,
        range          = { source.start, source.finish },
        selectionRange = { source.start, source.start },
        valueRange     = { source.start, source.finish },
    }
end

local function buildSource(source, used, symbols)
    if     source.type == 'local'
    or     source.type == 'setlocal'
    or     source.type == 'setglobal'
    or     source.type == 'setfield'
    or     source.type == 'setmethod'
    or     source.type == 'tablefield' then
        await.delay()
        buildSet(source, used, symbols)
    elseif source.type == 'function' then
        await.delay()
        buildAnonymousFunction(source, used, symbols)
    end
end

local function packChild(symbols, finish)
    await.delay()
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
        symbol.children = packChild(symbols, symbol.valueRange[2])
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
        return a.selectionRange[1] > b.selectionRange[1]
    end)
    -- 处理嵌套
    return packChild(symbols, math.maxinteger)
end

return function (uri)
    local ast = files.getAst(uri)
    if not ast then
        return nil
    end

    local symbols = {}
    local used = {}
    guide.eachSource(ast.ast, function (source)
        buildSource(source, used, symbols)
    end)

    if #symbols == 0 then
        return nil
    end

    local packedSymbols = packSymbols(symbols)

    return packedSymbols
end
