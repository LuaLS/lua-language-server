local await    = require 'await'
local files    = require 'files'
local guide    = require 'parser.guide'
local define   = require 'proto.define'
local util     = require 'utility'

local function buildName(source, text)
    local uri          = guide.getUri(source)
    local state        = files.getState(uri)
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
    if source.type == 'tableindex' then
        if source.index then
            local finishOffset = guide.positionToOffset(state, source.finish)
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
        if arg.type == 'self' then
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
    if #tbl > 3 then
        buf[#buf+1] = ('...(+%d)'):format(#tbl - 3)
    end
    return table.concat(buf, ', ')
end

local function buildValue(source, text, used, symbols)
    local name = buildName(source, text)
    local range, sRange, valueRange, kind
    local details = {}
    if source.type == 'local' then
        if source.parent.type == 'funcargs' then
            kind = define.SymbolKind.Constant
        else
            kind = define.SymbolKind.Variable
        end
        range      = { source.start, source.finish }
        sRange     = { source.start, source.finish }
    elseif source.type == 'setlocal' then
        range      = { source.start, source.finish }
        sRange     = { source.start, source.finish }
    elseif source.type == 'setglobal' then
        range      = { source.start, source.finish }
        sRange     = { source.start, source.finish }
    elseif source.type == 'tablefield' then
        if not source.field then
            return
        end
        range      = { source.field.start, source.field.finish }
        sRange     = { source.field.start, source.field.finish }
    elseif source.type == 'tableindex' then
        if not source.index then
            return
        end
        range      = { source.index.start, source.index.finish }
        sRange     = { source.index.start, source.index.finish }
    elseif source.type == 'setfield' then
        if not source.field then
            return
        end
        range      = { source.field.start, source.field.finish }
        sRange     = { source.field.start, source.field.finish }
    elseif source.type == 'setmethod' then
        if not source.method then
            return
        end
        range      = { source.method.start, source.method.finish }
        sRange     = { source.start, source.finish }
    else
        return
    end
    if source.value then
        used[source.value] = true
        local literal = source.value[1]
        if     source.value.type == 'boolean' then
            kind = define.SymbolKind.Boolean
            if literal ~= nil then
                details[#details+1] = util.viewLiteral(source.value[1])
            end
        elseif source.value.type == 'string' then
            kind = define.SymbolKind.String
            if literal ~= nil then
                details[#details+1] = util.viewLiteral(source.value[1])
            end
        elseif source.value.type == 'number'
        or     source.value.type == 'integer' then
            kind = define.SymbolKind.Number
            if literal ~= nil then
                details[#details+1] = util.viewLiteral(source.value[1])
            end
        elseif source.value.type == 'table' then
            kind = define.SymbolKind.Object
            if #source.value > 0 then
                details[#details+1] = '{'
                details[#details+1] = buildTable(source.value)
                details[#details+1] = '}'
            end
            valueRange = { source.value.start, source.value.finish }
        elseif source.value.type == 'select' then
            if source.value.vararg and source.value.vararg.type == 'call' then
                valueRange = { source.value.start, source.value.finish }
            end
        elseif source.value.type == 'function' then
            details[#details+1] = ('function (%s)'):format(buildFunctionParams(source.value))
            if source.type == 'setmethod' then
                kind = define.SymbolKind.Method
            else
                kind = define.SymbolKind.Function
            end
            valueRange = { source.value.start, source.value.finish }
            range[1]   = math.min(source.value.start, source.start)
        end
        range      = { range[1], source.value.finish }
    end
    symbols[#symbols+1] = {
        name           = name,
        detail         = table.concat(details),
        kind           = kind or define.SymbolKind.Variable,
        range          = range,
        selectionRange = sRange,
        valueRange     = valueRange,
    }
end

local function buildAnonymousFunction(source, text, used, symbols)
    if used[source] then
        return
    end
    used[source] = true
    local head = ''
    local parent = source.parent
    if     parent.type == 'return' then
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
    or     source.type == 'tablefield'
    or     source.type == 'tableexp'
    or     source.type == 'tableindex' then
        await.delay()
        buildValue(source, text, used, symbols)
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
