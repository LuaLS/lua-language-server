local buildName   = require 'core.hover.name'
local buildArgs   = require 'core.hover.args'
local buildReturn = require 'core.hover.return'
local buildTable  = require 'core.hover.table'
local vm          = require 'vm'
local util        = require 'utility'
local lang        = require 'language'
local config      = require 'config'
local files       = require 'files'
local guide       = require 'parser.guide'

local function asFunction(source, oop)
    local name  = buildName(source, oop)
    local args  = buildArgs(source)
    local rtn   = buildReturn(source)
    local lines = {}

    lines[1] = string.format('%s%s %s(%s)'
        , vm.isAsync(source) and '(async) ' or ''
        , oop and '(method)' or 'function'
        , name or ''
        , oop and table.concat(args, ', ', 2) or table.concat(args, ', ')
    )
    lines[2] = rtn

    return table.concat(lines, '\n')
end

local function asDocTypeName(source)
    local defs = vm.getDefs(source)
    for _, doc in ipairs(defs) do
        if doc.type == 'doc.class' then
            return '(class) ' .. doc.class[1]
        end
        if doc.type == 'doc.alias' then
            return '(alias) ' .. doc.alias[1] .. ' ' .. lang.script('HOVER_EXTENDS', vm.getInfer(doc.extends):view(guide.getUri(source)))
        end
        if doc.type == 'doc.enum' then
            return '(enum) ' .. doc.enum[1]
        end
    end
end

---@async
local function asValue(source, title)
    local name    = buildName(source, false) or ''
    local ifr     = vm.getInfer(source)
    local type    = ifr:view(guide.getUri(source))
    local literal = ifr:viewLiterals()
    local cont    = buildTable(source)
    local pack = {}
    pack[#pack+1] = title
    pack[#pack+1] = name .. ':'
    if vm.isAsync(source, true) then
        pack[#pack+1] = 'async'
    end
    if  cont
    and (  type == 'table'
        or type == 'any'
        or type == 'unknown'
        or type == 'nil') then
    else
        pack[#pack+1] = type
    end
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
    local node
    if source.type == 'local'
    or source.type == 'self' then
        node = source
    else
        node = source.node
    end
    if node.type == 'self' then
        return asValue(source, '(self)')
    end
    if node.parent.type == 'funcargs' then
        return asValue(source, '(parameter)')
    elseif guide.getParentFunction(source) ~= guide.getParentFunction(node) then
        return asValue(source, '(upvalue)')
    else
        return asValue(source, 'local')
    end
end

---@async
local function asGlobal(source)
    return asValue(source, '(global)')
end

local function isGlobalField(source)
    if source.type == 'field'
    or source.type == 'method' then
        source = source.parent
    end
    if     source.type == 'setfield'
    or     source.type == 'getfield'
    or     source.type == 'setmethod'
    or     source.type == 'getmethod' then
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
    return asValue(source, '(field)')
end

local function asDocFieldName(source)
    local name = vm.viewKey(source, guide.getUri(source)) or '?'
    local class
    for _, doc in ipairs(source.bindGroup) do
        if doc.type == 'doc.class' then
            class = doc
            break
        end
    end
    local view = vm.getInfer(source.extends):view(guide.getUri(source))
    local className = class and class.class[1] or '?'
    if name:match(guide.namePatternFull) then
        return ('(field) %s.%s: %s'):format(className, name, view)
    else
        return ('(field) %s%s: %s'):format(className, name, view)
    end
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
    if not config.get(guide.getUri(source), 'Lua.hover.viewNumber') then
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
    local raw = text:sub(source.start + 1, source.finish)
    if not raw or not raw:find '[^%-%d%.]' then
        return nil
    end
    return formatNumber(num)
end

---@async
return function (source, oop)
    if     source.type == 'function'
    or     source.type == 'doc.type.function' then
        return asFunction(source, oop)
    elseif source.type == 'local'
    or     source.type == 'self'
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
    elseif source.type == 'doc.type.name'
    or     source.type == 'doc.enum.name' then
        return asDocTypeName(source)
    elseif source.type == 'doc.field' then
        return asDocFieldName(source)
    end
end
