local buildName   = require 'core.hover.name'
local buildArg    = require 'core.hover.arg'
local buildReturn = require 'core.hover.return'
local vm          = require 'vm'
local util        = require 'utility'

local function asFunction(source)
    local name = buildName(source)
    local arg  = buildArg(source)
    local rtn  = buildReturn(source)
    local lines = {}
    lines[1] = ('function %s(%s)'):format(name, arg)
    lines[2] = rtn
    return table.concat(lines, '\n')
end

local function asLocal(source)
    local name = buildName(source)
    local type = vm.getType(source)
    local literal = vm.getLiteral(source)
    if literal == nil then
        return ('local %s: %s'):format(name, type)
    else
        return ('local %s: %s = %s'):format(name, type, util.viewLiteral(literal))
    end
end

local function asGlobal(source)
    local name = buildName(source)
    local type = vm.getType(source)
    local literal = vm.getLiteral(source)
    if literal == nil then
        return ('global %s: %s'):format(name, type)
    else
        return ('global %s: %s = %s'):format(name, type, util.viewLiteral(literal))
    end
end

local function isGlobalField(source)
    if source.type == 'field'
    or source.type == 'method' then
        source = source.parent
    end
    if source.type == 'setfield'
    or source.type == 'getfield'
    or source.type == 'setmethod'
    or source.type == 'getmethod'
    or source.type == 'tablefield' then
        local node = source.node
        if node.type == 'setglobal'
        or node.type == 'getglobal' then
            return true
        end
        return isGlobalField(node)
    else
        return false
    end
end

local function asField(source)
    if isGlobalField(source) then
        return asGlobal(source)
    end
    local name = buildName(source)
    local type = vm.getType(source)
    local literal = vm.getLiteral(source)
    if literal == nil then
        return ('field %s: %s'):format(name, type)
    else
        return ('field %s: %s = %s'):format(name, type, util.viewLiteral(literal))
    end
end

return function (source)
    if source.type == 'function' then
        return asFunction(source)
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
    end
end
