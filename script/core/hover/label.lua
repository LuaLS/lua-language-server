local buildName   = require 'core.hover.name'
local buildArg    = require 'core.hover.arg'
local buildReturn = require 'core.hover.return'
local buildTable  = require 'core.hover.table'
local infer       = require 'core.infer'
local vm          = require 'vm'
local util        = require 'utility'
local lang        = require 'language'
local config      = require 'config'
local files       = require 'files'
local guide       = require 'parser.guide'

local function asFunction(source, oop)
    local name
    name, oop   = buildName(source, oop)
    local arg   = buildArg(source, oop)
    local rtn   = buildReturn(source)
    local lines = {}
    lines[1] = ('%s%s %s(%s)'):format(
        vm.isAsync(source) and 'async ' or '',
        oop and 'method' or 'function',
        name or '', arg
    )
    lines[2] = rtn
    return table.concat(lines, '\n')
end

local function asDocFunction(source)
    local name = buildName(source)
    local arg  = buildArg(source)
    local rtn  = buildReturn(source)
    local lines = {}
    lines[1] = ('function %s(%s)'):format(name or '', arg)
    lines[2] = rtn
    return table.concat(lines, '\n')
end

local function asDocTypeName(source)
    local defs = vm.getDefs(source)
    for _, doc in ipairs(defs) do
        if doc.type == 'doc.class.name' then
            return 'class ' .. doc[1]
        end
        if doc.type == 'doc.alias.name' then
            local extends = doc.parent.extends
            return lang.script('HOVER_EXTENDS', infer.searchAndViewInfers(extends))
        end
    end
end

---@async
local function asValue(source, title)
    local name    = buildName(source, false) or ''
    local type    = infer.searchAndViewInfers(source)
    local literal = infer.searchAndViewLiterals(source)
    local cont
    if  not infer.hasType(source, 'string')
    and not type:find('%[%]$') then
        if #vm.getRefs(source, '*') > 0
        or infer.hasType(source, 'table') then
            cont = buildTable(source)
        end
    end
    local pack = {}
    pack[#pack+1] = title
    pack[#pack+1] = name .. ':'
    if vm.isAsync(source, true) then
        pack[#pack+1] = 'async'
    end
    if  cont
    and (  type == 'table'
        or type == 'any'
        or type == 'nil') then
        type = nil
    end
    pack[#pack+1] = type
    if literal then
        pack[#pack+1] = '='
        pack[#pack+1] = literal
    end
    if cont then
        pack[#pack+1] = cont
    end
    return table.concat(pack, ' ')
end

---@async
local function asLocal(source)
    return asValue(source, 'local')
end

---@async
local function asGlobal(source)
    return asValue(source, 'global')
end

local function isGlobalField(source)
    if source.type == 'field'
    or source.type == 'method' then
        source = source.parent
    end
    if source.type == 'setfield'
    or source.type == 'getfield'
    or source.type == 'setmethod'
    or source.type == 'getmethod' then
        local node = source.node
        if node.type == 'setglobal'
        or node.type == 'getglobal' then
            return true
        end
        return isGlobalField(node)
    elseif source.type == 'tablefield' then
        local parent = source.parent
        if parent.type == 'setglobal'
        or parent.type == 'getglobal' then
            return true
        end
        return isGlobalField(parent)
    else
        return false
    end
end

---@async
local function asField(source)
    if isGlobalField(source) then
        return asGlobal(source)
    end
    return asValue(source, 'field')
end

local function asDocFieldName(source)
    local name     = source[1]
    local docField = source.parent
    local class
    for _, doc in ipairs(docField.bindGroup) do
        if doc.type == 'doc.class' then
            class = doc
            break
        end
    end
    local view = infer.searchAndViewInfers(docField.extends)
    if not class then
        return ('field ?.%s: %s'):format(name, view)
    end
    return ('field %s.%s: %s'):format(class.class[1], name, view)
end

local function asString(source)
    local str = source[1]
    if type(str) ~= 'string' then
        return ''
    end
    local len = #str
    local charLen = util.utf8Len(str, 1, -1)
    if len == charLen then
        return lang.script('HOVER_STRING_BYTES', len)
    else
        return lang.script('HOVER_STRING_CHARACTERS', len, charLen)
    end
end

local function formatNumber(n)
    local str = ('%.10f'):format(n)
    str = str:gsub('%.?0*$', '')
    return str
end

local function asNumber(source)
    if not config.get 'Lua.hover.viewNumber' then
        return nil
    end
    local num = source[1]
    if type(num) ~= 'number' then
        return nil
    end
    local uri  = guide.getUri(source)
    local text = files.getText(uri)
    if not text then
        return nil
    end
    local raw = text:sub(source.start, source.finish)
    if not raw or not raw:find '[^%-%d%.]' then
        return nil
    end
    return formatNumber(num)
end

---@async
return function (source, oop)
    if source.type == 'function' then
        return asFunction(source, oop)
    elseif source.type == 'local'
    or     source.type == 'getlocal'
    or     source.type == 'setlocal' then
        return asLocal(source)
    elseif source.type == 'setglobal'
    or     source.type == 'getglobal' then
        return asGlobal(source)
    elseif source.type == 'getfield'
    or     source.type == 'setfield'
    or     source.type == 'getmethod'
    or     source.type == 'setmethod'
    or     source.type == 'tablefield'
    or     source.type == 'field'
    or     source.type == 'method' then
        return asField(source)
    elseif source.type == 'string' then
        return asString(source)
    elseif source.type == 'number'
    or     source.type == 'integer' then
        return asNumber(source)
    elseif source.type == 'doc.type.function' then
        return asDocFunction(source)
    elseif source.type == 'doc.type.name' then
        return asDocTypeName(source)
    elseif source.type == 'doc.field.name' then
        return asDocFieldName(source)
    end
end
