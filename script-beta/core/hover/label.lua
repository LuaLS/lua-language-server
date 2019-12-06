local buildName   = require 'core.hover.name'
local buildArg    = require 'core.hover.arg'
local buildReturn = require 'core.hover.return'
local buildTable  = require 'core.hover.table'
local getClass    = require 'core.hover.class'
local vm          = require 'vm'
local util        = require 'utility'

local function asFunction(source, caller)
    local name = buildName(source, caller)
    local arg  = buildArg(source, caller)
    local rtn  = buildReturn(source)
    local lines = {}
    lines[1] = ('function %s(%s)'):format(name, arg)
    lines[2] = rtn
    return table.concat(lines, '\n')
end

local function asValue(source, title)
    local name = buildName(source)
    local lib  = vm.getLibrary(source)
    local class = getClass(source)
    local type = vm.getType(source)
    local literal = vm.getLiteral(source)
    local cont
    if type == 'table' then
        cont = buildTable(source)
        type = nil
    end
    local pack = {}
    pack[#pack+1] = title
    pack[#pack+1] = name .. ':'
    pack[#pack+1] = class or type
    if literal then
        pack[#pack+1] = '='
        pack[#pack+1] = util.viewLiteral(literal)
    end
    if cont then
        pack[#pack+1] = cont
    end
    return table.concat(pack, ' ')
end

local function asLocal(source)
    return asValue(source, 'local')
end

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

local function asField(source)
    if isGlobalField(source) then
        return asGlobal(source)
    end
    return asValue(source, 'field')
end

local function asLibrary(source)
    local lib = source.library
    if lib.type == 'function' then
        return asFunction(source)
    end
end

local function asString(source)
    local str = source[1]
    if type(str) ~= 'string' then
        return ''
    end
    local len = #str
    local charLen = utf8.len(str, 1, -1, true)
    -- TODO 翻译
    if len == charLen then
        return ('%d 个字节'):format(len)
    else
        return ('%d 个字节，%d 个字符'):format(len, charLen)
    end
end

return function (source, caller)
    if source.type == 'function' then
        return asFunction(source, caller)
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
    end
end
