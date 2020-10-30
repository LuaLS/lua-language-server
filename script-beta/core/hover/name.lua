local guide    = require 'parser.guide'
local vm       = require 'vm'

local buildName

local function asLocal(source)
    local name = guide.getName(source)
    if not source.attrs then
        return name
    end
    local label = {}
    label[#label+1] = name
    for _, attr in ipairs(source.attrs) do
        label[#label+1] = ('<%s>'):format(attr[1])
    end
    return table.concat(label, ' ')
end

local function asMethod(source)
    local class = vm.getClass(source.node, 'deep')
    local node = class or guide.getName(source.node) or '?'
    local method = guide.getName(source)
    return ('%s:%s'):format(node, method)
end

local function asField(source)
    local class = vm.getClass(source.node, 'deep')
    local node = class or guide.getName(source.node) or '?'
    local method = guide.getName(source)
    return ('%s.%s'):format(node, method)
end

local function asTableField(source)
    if not source.field then
        return
    end
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

local function asDocFunction(source)
    local doc = guide.getParentType(source, 'doc.type')
    if not doc or not doc.bindSources then
        return ''
    end
    for _, src in ipairs(doc.bindSources) do
        local name = buildName(src)
        if name ~= '' then
            return name
        end
    end
    return ''
end

function buildName(source, oop)
    if oop == nil then
        oop =  source.type == 'setmethod'
            or source.type == 'getmethod'
    end
    if source.type == 'library' then
        return asLibrary(source.value, oop) or ''
    elseif source.library then
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
    if source.type == 'doc.type.function' then
        return asDocFunction(source)
    end
    local parent = source.parent
    if parent then
        return buildName(parent, oop)
    end
    return ''
end

return buildName
