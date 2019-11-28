local guide = require 'parser.guide'
local vm    = require 'vm'

local function getClass(source, deep)
    if deep and deep > 3 then
        return nil
    end
    local class = vm.eachField(source, function (info)
        if info.key == 's|type' or info.key == 's|__name' or info.key == 's|name' then
            if info.value and info.value.type == 'string' then
                return info.value[1]
            end
        end
    end)
    if class then
        return class
    end
    return vm.eachMeta(source, function (meta)
        local cl = getClass(meta, deep and (deep + 1) or 1)
        if cl then
            return cl
        end
    end)
end

local function asLocal(source)
    local class = getClass(source)
    if class then
        return ('%s: %s'):format(guide.getName(source), class)
    else
        return guide.getName(source)
    end
end

local function asMethod(source)
    local class = getClass(source.node)
    local node = class or guide.getName(source.node) or '?'
    local method = guide.getName(source)
    return ('%s:%s'):format(node, method)
end

local function asField(source)
    local class = getClass(source.node)
    local node = class or guide.getName(source.node) or '?'
    local method = guide.getName(source)
    return ('%s.%s'):format(node, method)
end

local function asTableField(source)
    return guide.getName(source.field)
end

local function asGlobal(source)
    return guide.getName(source)
end

local function buildName(source)
    if source.type == 'local'
    or source.type == 'getlocal'
    or source.type == 'setlocal' then
        return asLocal(source) or ''
    end
    if source.type == 'setglobal'
    or source.type == 'getglobal' then
        return asGlobal(source) or ''
    end
    if source.type == 'setmethod'
    or source.type == 'getmethod' then
        return asMethod(source) or ''
    end
    if source.type == 'setfield'
    or source.tyoe == 'getfield' then
        return asField(source) or ''
    end
    if source.type == 'tablefield' then
        return asTableField(source) or ''
    end
    local parent = source.parent
    if parent then
        return buildName(parent)
    end
    return ''
end

return buildName
