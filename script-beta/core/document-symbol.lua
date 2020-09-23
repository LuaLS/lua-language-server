local files = require 'files'
local guide = require 'parser.guide'
local skind = require 'define.SymbolKind'
local lname = require 'core.hover.name'
local util  = require 'utility'

local function buildFunction(source, symbols)
    local name = lname(source)
    local func = source.value
    local range, kind
    if func.start > source.finish then
        -- a = function()
        range = { source.start, source.finish }
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
        detail         = ('function %s()'):format(name or ''),
        kind           = kind,
        range          = range,
        selectionRange = { source.start, source.finish },
        valueRange     = { func.start, func.finish },
    }
end

local function buildValue(source, symbols)
    local name  = lname(source)
    local valueRange
    local details = {}
    if source.type == 'local' then
        details[1] = 'local '
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
            details[3] = ': {}'
        end
        valueRange = { source.value.start, source.value.finish }
    else
        valueRange = { source.start, source.finish }
    end
    symbols[#symbols+1] = {
        name           = name,
        detail         = table.concat(details),
        kind           = skind.Variable,
        range          = { source.start, source.finish },
        selectionRange = { source.start, source.finish },
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
    or     source.type == 'setglobal'
    or     source.type == 'setfield'
    or     source.type == 'setmethod' then
        buildSet(source, used, symbols)
    elseif source.type == 'function' then
        buildAnonymousFunction(source, used, symbols)
    end
end

local function packChild(symbols, finish)
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
        return a.range[1] > b.range[1]
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

    local packedSymbols = packSymbols(symbols)

    return packedSymbols
end
