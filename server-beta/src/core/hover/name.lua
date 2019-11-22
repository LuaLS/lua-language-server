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

local function asField(source)
    local class = vm.eachField(source.node, function (info)
        if info.key == 's|type' or info.key == 's|__name' then
            if info.value and info.value.type == 'string' then
                return info.value[1]
            end
        end
    end)
    local node = class or guide.getName(source.node) or '*'
    local method = guide.getName(source)
    return ('%s.%s'):format(node, method)
end

local function buildName(source)
    if source.type == 'local'
    or source.type == 'getlocal'
    or source.type == 'setlocal' then
        return asLocal(source) or ''
    end
    if source.type == 'setmethod' then
        return asMethod(source) or ''
    end
    if source.type == 'setfield' then
        return asField(source) or ''
    end
    local parent = source.parent
    if parent then
        return buildName(parent)
    end
    return ''
end

return buildName
