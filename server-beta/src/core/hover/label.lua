local buildName   = require 'core.hover.name'
local buildArg    = require 'core.hover.arg'
local buildReturn = require 'core.hover.return'

local function asFunction(source)
    local name = buildName(source)
    local arg  = buildArg(source)
    local rtn  = buildReturn(source)
    return ('function %s(%s)'):format(name, arg)
end

return function (source)
    if source.type == 'function' then
        return asFunction(source)
    end
end
