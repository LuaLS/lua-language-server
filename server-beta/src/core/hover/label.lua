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

return function (source)
    if source.type == 'function' then
        return asFunction(source)
    elseif source.type == 'local'
    or     source.type == 'getlocal'
    or     source.type == 'setlocal' then
        return asLocal(source)
    end
end
