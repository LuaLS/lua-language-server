local guide    = require 'parser.guide'
local vm       = require 'vm'

local function asLocal(source)
    return guide.getName(source)
end

local function asMethod(source)
    local class = vm.getClass(source.node)
    local node = class or guide.getName(source.node) or '?'
    local method = guide.getName(source)
    return ('%s:%s'):format(node, method)
end

local function asField(source)
    local class = vm.getClass(source.node)
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

local function asLibrary(source, oop)
    local p
    if oop then
        if source.parent then
            for _, parent in ipairs(source.parent) do
                if parent.type == 'object' then
                    p = parent.name .. ':'
                    break
                end
            end
        end
    else
        if source.parent then
            for _, parent in ipairs(source.parent) do
                if parent.type == 'global' then
                    p = parent.name .. '.'
                    break
                end
            end
        end
    end
    if p then
        return ('%s%s'):format(p, source.name)
    else
        return source.name
    end
end

local function buildName(source, oop)
    if source.library then
        return asLibrary(source, oop) or ''
    end
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
        return buildName(parent, oop)
    end
    return ''
end

return buildName
