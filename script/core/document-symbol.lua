local await    = require 'await'
local files    = require 'files'
local guide    = require 'parser.guide'
local define   = require 'proto.define'
local util     = require 'utility'

local function buildName(source, text)
    local uri   = guide.getUri(source)
    local state = files.getState(uri)
    local startOffset  = guide.positionToOffset(state, source.start)
    if source.type == 'setmethod'
    or source.type == 'getmethod' then
        if source.method then
            local finishOffset = guide.positionToOffset(state, source.method.finish)
            return text:sub(startOffset + 1, finishOffset)
        end
    end
    if source.type == 'setfield'
    or source.type == 'tablefield'
    or source.type == 'getfield' then
        if source.field then
            local finishOffset = guide.positionToOffset(state, source.field.finish)
            return text:sub(startOffset + 1, finishOffset)
        end
    end
    local finishOffset = guide.positionToOffset(state, source.finish)
    return text:sub(startOffset + 1, finishOffset)
end

local function buildFunctionParams(func)
    if not func.args then
        return ''
    end
    local params = {}
    for _, arg in ipairs(func.args) do
        if arg.dummy then
            goto CONTINUE
        end
        if arg.type == '...' then
            params[#params+1] = '...'
        else
            params[#params+1] = arg[1] or ''
        end
        ::CONTINUE::
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
        if  field.type == 'tablefield'
        and field.field then
            buf[#buf+1] = ('%s'):format(field.field[1])
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
        elseif source.value.type == 'number'
        or     source.value.type == 'integer' then
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
    if source.dummy then
        return
    end
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
        selectionRange = { source.keyword[1], source.keyword[2] },
        valueRange     = { source.start, source.finish },
    }
end

---@async
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

---@async
local function makeSymbol(uri)
    local ast = files.getState(uri)
    local text = files.getText(uri)
    if not ast or not text then
        return nil
    end

    local symbols = {}
    local used = {}
    guide.eachSource(ast.ast, function (source) ---@async
        buildSource(source, text, used, symbols)
    end)

    return symbols
end

local function packChild(symbols)
    local index = 1
    local function insertChilds(min, max)
        local list
        while true do
            local symbol = symbols[index]
            if not symbol then
                break
            end
            if symbol.selectionRange[1] < min
            or symbol.selectionRange[2] > max then
                break
            end
            if not list then
                list = {}
            end
            list[#list+1] = symbol
            index = index + 1
            if symbol.valueRange then
                symbol.children = insertChilds(symbol.valueRange[1], symbol.valueRange[2])
            end
        end
        return list
    end

    local root = insertChilds(0, math.maxinteger)
    return root
end

---@async
local function packSymbols(symbols)
    await.delay()
    table.sort(symbols, function (a, b)
        local o1 = a.valueRange and a.valueRange[1] or a.selectionRange[1]
        local o2 = b.valueRange and b.valueRange[1] or b.selectionRange[1]
        return o1 < o2
    end)
    await.delay()
    -- 处理嵌套
    return packChild(symbols)
end

---@async
return function (uri)
    local symbols = makeSymbol(uri)
    if not symbols then
        return nil
    end

    local packedSymbols = packSymbols(symbols)

    return packedSymbols
end
