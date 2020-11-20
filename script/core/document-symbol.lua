local await  = require 'await'
local files  = require 'files'
local guide  = require 'parser.guide'
local define = require 'proto.define'
local util   = require 'utility'

local function buildName(source, text)
    if source.type == 'setmethod'
    or source.type == 'getmethod' then
        if source.method then
            return text:sub(source.start, source.method.finish)
        end
    end
    if source.type == 'setfield'
    or source.type == 'tablefield'
    or source.type == 'getfield' then
        if source.field then
            return text:sub(source.start, source.field.finish)
        end
    end
    return text:sub(source.start, source.finish)
end

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

local function buildFunction(source, text, symbols)
    local name = buildName(source, text)
    local func = source.value
    if source.type == 'tablefield'
    or source.type == 'setfield' then
        source = source.field
        if not source then
            return
        end
    end
    local range, kind
    if func.start > source.finish then
        -- a = function()
        range = { source.start, func.finish }
    else
        -- function f()
        range = { func.start, func.finish }
    end
    if source.type == 'setmethod' then
        kind = define.SymbolKind.Method
    else
        kind = define.SymbolKind.Function
    end
    symbols[#symbols+1] = {
        name           = name,
        detail         = ('function (%s)'):format(buildFunctionParams(func)),
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

local function buildValue(source, text, symbols)
    local name  = buildName(source, text)
    local range, sRange, valueRange, kind
    local details = {}
    if source.type == 'local' then
        if source.parent.type == 'funcargs' then
            details[1] = 'param'
            range      = { source.start, source.finish }
            sRange     = { source.start, source.finish }
            kind       = define.SymbolKind.Constant
        else
            details[1] = 'local'
            range      = { source.start, source.finish }
            sRange     = { source.start, source.finish }
            kind       = define.SymbolKind.Variable
        end
    elseif source.type == 'setlocal' then
        details[1] = 'setlocal'
        range      = { source.start, source.finish }
        sRange     = { source.start, source.finish }
        kind       = define.SymbolKind.Variable
    elseif source.type == 'setglobal' then
        details[1] = 'global'
        range      = { source.start, source.finish }
        sRange     = { source.start, source.finish }
        kind       = define.SymbolKind.Class
    elseif source.type == 'tablefield' then
        if not source.field then
            return
        end
        details[1] = 'field'
        range      = { source.field.start, source.field.finish }
        sRange     = { source.field.start, source.field.finish }
        kind       = define.SymbolKind.Property
    elseif source.type == 'setfield' then
        if not source.field then
            return
        end
        details[1] = 'field'
        range      = { source.field.start, source.field.finish }
        sRange     = { source.field.start, source.field.finish }
        kind       = define.SymbolKind.Field
    else
        return
    end
    if source.value then
        local literal = source.value[1]
        if source.value.type == 'boolean' then
            details[2] = ' boolean'
            if literal ~= nil then
                details[3] = ' = '
                details[4] = util.viewLiteral(source.value[1])
            end
        elseif source.value.type == 'string' then
            details[2] = ' string'
            if literal ~= nil then
                details[3] = ' = '
                details[4] = util.viewLiteral(source.value[1])
            end
        elseif source.value.type == 'number' then
            details[2] = ' number'
            if literal ~= nil then
                details[3] = ' = '
                details[4] = util.viewLiteral(source.value[1])
            end
        elseif source.value.type == 'table' then
            details[2] = ' {'
            details[3] = buildTable(source.value)
            details[4] = '}'
            valueRange = { source.value.start, source.value.finish }
        elseif source.value.type == 'select' then
            if source.value.vararg and source.value.vararg.type == 'call' then
                valueRange = { source.value.start, source.value.finish }
            end
        end
        range      = { range[1], source.value.finish }
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

local function buildSet(source, text, used, symbols)
    local value = source.value
    if value and value.type == 'function' then
        used[value] = true
        buildFunction(source, text, symbols)
    else
        buildValue(source, text, symbols)
    end
end

local function buildAnonymousFunction(source, text, used, symbols)
    if used[source] then
        return
    end
    used[source] = true
    local head = ''
    local parent = source.parent
    if parent.type == 'return' then
        head = 'return '
    elseif parent.type == 'callargs' then
        local call = parent.parent
        local node = call.node
        head = buildName(node, text) .. ' -> '
    end
    symbols[#symbols+1] = {
        name           = '',
        detail         = ('%sfunction (%s)'):format(head, buildFunctionParams(source)),
        kind           = define.SymbolKind.Function,
        range          = { source.start, source.finish },
        selectionRange = { source.start, source.start },
        valueRange     = { source.start, source.finish },
    }
end

local function buildSource(source, text, used, symbols)
    if     source.type == 'local'
    or     source.type == 'setlocal'
    or     source.type == 'setglobal'
    or     source.type == 'setfield'
    or     source.type == 'setmethod'
    or     source.type == 'tablefield' then
        await.delay()
        buildSet(source, text, used, symbols)
    elseif source.type == 'function' then
        await.delay()
        buildAnonymousFunction(source, text, used, symbols)
    end
end

local function makeSymbol(uri)
    local ast = files.getAst(uri)
    if not ast then
        return nil
    end

    local text = files.getText(uri)
    local symbols = {}
    local used = {}
    guide.eachSource(ast.ast, function (source)
        buildSource(source, text, used, symbols)
    end)

    return symbols
end

local function packChild(ranges, symbols)
    await.delay()
    table.sort(symbols, function (a, b)
        return a.selectionRange[1] < b.selectionRange[1]
    end)
    await.delay()
    local root = {
        valueRange = { 0, math.maxinteger },
        children   = {},
    }
    local stacks = { root }
    for _, symbol in ipairs(symbols) do
        local parent = stacks[#stacks]
        -- 移除已经超出生效范围的区间
        while symbol.selectionRange[1] > parent.valueRange[2] do
            stacks[#stacks] = nil
            parent = stacks[#stacks]
        end
        -- 向后看，找出当前可能生效的区间
        local nextRange
        while #ranges > 0
        and   symbol.selectionRange[1] >= ranges[#ranges].valueRange[1] do
            if symbol.selectionRange[1] <= ranges[#ranges].valueRange[2] then
                nextRange = ranges[#ranges]
            end
            ranges[#ranges] = nil
        end
        if nextRange then
            stacks[#stacks+1] = nextRange
            parent = nextRange
        end
        if parent == symbol then
            -- function f() end 的情况，selectionRange 在 valueRange 内部，
            -- 当前区间置为上一层
            parent = stacks[#stacks-1]
        end
        -- 把自己放到当前区间中
        if not parent.children then
            parent.children = {}
        end
        parent.children[#parent.children+1] = symbol
    end
    return root.children
end

local function packSymbols(symbols)
    local ranges = {}
    for _, symbol in ipairs(symbols) do
        if symbol.valueRange then
            ranges[#ranges+1] = symbol
        end
    end
    await.delay()
    table.sort(ranges, function (a, b)
        return a.valueRange[1] > b.valueRange[1]
    end)
    -- 处理嵌套
    return packChild(ranges, symbols)
end

return function (uri)
    local symbols = makeSymbol(uri)
    if not symbols then
        return nil
    end

    local packedSymbols = packSymbols(symbols)

    return packedSymbols
end
