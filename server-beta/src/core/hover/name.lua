local guide = require 'parser.guide'
local vm    = require 'vm'

local function asLocal(source)
    return guide.getName(source)
end

local function asMethod(source)
    local class = vm.eachField(source.node, function (info)
        if info.key == 's|type' or info.key == 's|__name' then
            if info.value and info.value.type == 'string' then
                return info.value[1]
            end
        end
    end)
    local node = class or guide.getName(source.node) or '*'
    local method = guide.getName(source)
    return ('%s:%s'):format(node, method)
end

return function (source)
    local parent = source.parent
    if not parent then
        return ''
    end
    if parent.type == 'local'
    or parent.type == 'getlocal'
    or parent.type == 'setlocal' then
        return asLocal(parent) or ''
    end
    if parent.type == 'setmethod' then
        return asMethod(parent) or ''
    end
    return ''
end
