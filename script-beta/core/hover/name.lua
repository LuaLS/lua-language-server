local guide    = require 'parser.guide'
local getClass = require 'core.hover.class'

local function asLocal(source)
    return guide.getName(source)
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
    or source.type == 'getfield' then
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
