local await    = require 'await'
local files    = require 'files'
local guide    = require 'parser.guide'
local define   = require 'proto.define'
local util     = require 'utility'
local subber   = require 'core.substring'

---@param text string
---@return string
local function clipLastLine(text)
    if text:find '[\r\n]' then
        return '... ' .. util.trim(text:match '[^\r\n]*$')
    else
        return text
    end
end

local function buildName(source, sub)
    if source.type == 'setmethod'
    or source.type == 'getmethod' then
        if source.method then
            return clipLastLine(sub(source.start + 1, source.method.finish))
        end
    end
    if source.type == 'setfield'
    or source.type == 'tablefield'
    or source.type == 'getfield' then
        if source.field then
            return clipLastLine(sub(source.start + 1, source.field.finish))
        end
    end
    if source.type == 'tableindex' then
        if source.index then
            return ('[%s]'):format(clipLastLine(sub(source.index.start + 1, source.index.finish)))
        end
    end
    if source.type == 'tableexp' then
        return ('[%d]'):format(source.tindex)
    end
    return clipLastLine(sub(source.start + 1, source.finish))
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

local function buildTable(tbl, sub)
    local buf = {}
    for i = 1, 5 do
        local field = tbl[i]
        if not field then
            break
        end
        if  field.type == 'tablefield'
        and field.field then
            buf[#buf+1] = ('%s'):format(field.field[1])
        elseif field.type == 'tableindex'
        and    field.index then
            buf[#buf+1] = ('[%s]'):format(sub(field.index.start + 1, field.index.finish))
        elseif field.type == 'tableexp' then
            buf[#buf+1] = ('[%s]'):format(field.tindex)
        end
    end
    if #tbl > 5 then
        buf[#buf+1] = ('...(+%d)'):format(#tbl - 5)
    end
    return table.concat(buf, ', ')
end

local function buildArray(tbl, sub)
    local buf = {}
    for i = 1, 5 do
        local field = tbl[i]
        if not field then
            break
        end
        buf[#buf+1] = sub(field.start + 1, field.finish)
    end
    if #tbl > 5 then
        buf[#buf+1] = ('...(+%d)'):format(#tbl - 5)
    end
    return table.concat(buf, ', ')
end

local function buildValue(source, sub, used, symbols)
    local name = buildName(source, sub)
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
    elseif source.type == 'tableexp' then
        range      = { source.value.start, source.value.finish }
        sRange     = { source.value.start, source.value.finish }
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
            local lastField = source.value[#source.value]
            if #source.value > 0 then
                if  lastField.type == 'tableexp'
                and lastField.tindex == #source.value then
                    -- Array
                    kind = define.SymbolKind.Array
                    details[#details+1] = '['
                    details[#details+1] = buildArray(source.value, sub)
                    details[#details+1] = ']'
                else
                    -- Object
                    details[#details+1] = '{'
                    details[#details+1] = buildTable(source.value, sub)
                    details[#details+1] = '}'
                end
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

local function buildAnonymous(source, sub, used, symbols)
    if used[source] then
        return
    end
    used[source] = true
    local head = ''
    local detail = ''
    local parent = source.parent
    if     parent.type == 'return' then
        head = 'return'
    elseif parent.type == 'callargs' then
        local call = parent.parent
        local node = call.node
        head = buildName(node, sub)
        detail = '-> '
    end
    if source.type == 'function' then
        symbols[#symbols+1] = {
            name           = head,
            detail         = detail .. ('function (%s)'):format(buildFunctionParams(source)),
            kind           = define.SymbolKind.Function,
            range          = { source.start, source.finish },
            selectionRange = { source.keyword[1], source.keyword[2] },
            valueRange     = { source.start, source.finish },
        }
    elseif source.type == 'table' then
        local kind      = define.SymbolKind.Object
        local details   = {}
        local lastField = source[#source]
        if lastField then
            if  lastField.type == 'tableexp'
            and lastField.tindex == #source then
                -- Array
                kind = define.SymbolKind.Array
                details[#details+1] = '['
                details[#details+1] = buildArray(source, sub)
                details[#details+1] = ']'
            else
                -- Object
                details[#details+1] = '{'
                details[#details+1] = buildTable(source, sub)
                details[#details+1] = '}'
            end
        end
        symbols[#symbols+1] = {
            name           = head,
            detail         = detail .. table.concat(details),
            kind           = kind,
            range          = { source.start, source.finish },
            selectionRange = { source.start, source.finish },
            valueRange     = { source.start, source.finish },
        }
    end
end

local function buildBlock(source, sub, used, symbols)
    if used[source] then
        return
    end
    used[source] = true
    if source.type == 'if' then
        for _, block in ipairs(source) do
            symbols[#symbols+1] = {
                name           = block.type:gsub('block$', ''),
                detail         = sub(block.start + 1, block.keyword[4] or block.keyword[2]),
                kind           = define.SymbolKind.Package,
                range          = { block.start, block.finish },
                valueRange     = { block.start, block.finish },
                selectionRange = { block.keyword[1], block.keyword[2] },
            }
        end
    elseif source.type == 'while' then
        symbols[#symbols+1] = {
            name           = 'while',
            detail         = sub(source.start + 1, source.keyword[4] or source.keyword[2]),
            kind           = define.SymbolKind.Package,
            range          = { source.start, source.finish },
            valueRange     = { source.start, source.finish },
            selectionRange = { source.keyword[1], source.keyword[2] },
        }
    elseif source.type == 'repeat' then
        symbols[#symbols+1] = {
            name           = 'repeat',
            detail         = source.filter and sub(source.keyword[3] + 1, source.filter.finish) or '',
            kind           = define.SymbolKind.Package,
            range          = { source.start, source.finish },
            valueRange     = { source.start, source.finish },
            selectionRange = { source.keyword[1], source.keyword[2] },
        }
    elseif source.type == 'loop'
    or     source.type == 'in' then
        symbols[#symbols+1] = {
            name           = 'for',
            detail         = sub(source.start, source.keyword[4] or source.keyword[2]),
            kind           = define.SymbolKind.Package,
            range          = { source.start, source.finish },
            valueRange     = { source.start, source.finish },
            selectionRange = { source.keyword[1], source.keyword[2] },
        }
    end
end

local function buildSource(source, sub, used, symbols)
    if     source.type == 'local'
    or     source.type == 'setlocal'
    or     source.type == 'setglobal'
    or     source.type == 'setfield'
    or     source.type == 'setmethod'
    or     source.type == 'tablefield'
    or     source.type == 'tableexp'
    or     source.type == 'tableindex' then
        buildValue(source, sub, used, symbols)
    elseif source.type == 'function'
    or     source.type == 'table' then
        buildAnonymous(source, sub, used, symbols)
    elseif source.type == 'if'
    or     source.type == 'while'
    or     source.type == 'in'
    or     source.type == 'loop'
    or     source.type == 'repeat' then
        buildBlock(source, sub, used, symbols)
    end
end

---@async
local function makeSymbol(uri)
    local state = files.getState(uri)
    if not state then
        return nil
    end

    local sub = subber(state)
    local symbols = {}
    local used = {}
    local i = 0
    ---@async
    guide.eachSource(state.ast, function (source)
        buildSource(source, sub, used, symbols)
        i = i + 1
        if i % 1000 == 0 then
            await.delay()
        end
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
