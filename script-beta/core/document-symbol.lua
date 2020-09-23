local files = require 'files'
local guide = require 'parser.guide'
local skind = require 'define.SymbolKind'
local lname = require 'core.hover.name'

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

local function buildSet(source, used, symbols)
    local value = source.value
    if value.type == 'function' then
        used[value] = true
        buildFunction(source, symbols)
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

    return symbols
end
