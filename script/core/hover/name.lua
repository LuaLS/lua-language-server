local guide    = require 'parser.guide'
local vm       = require 'vm'

local buildName

local function asLocal(source)
    local name = guide.getKeyName(source)
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

local function asField(source, oop)
    local class
    if source.node.type ~= 'getglobal' then
        class = vm.getClass(source.node, 0)
    end
    local node = class or guide.getKeyName(source.node) or '?'
    local method = guide.getKeyName(source)
    if oop then
        return ('%s:%s'):format(node, method)
    else
        return ('%s.%s'):format(node, method)
    end
end

local function asTableField(source)
    if not source.field then
        return
    end
    return guide.getKeyName(source.field)
end

local function asGlobal(source)
    return guide.getKeyName(source)
end

local function asDocFunction(source)
    local doc = guide.getParentType(source, 'doc.type')
            or  guide.getParentType(source, 'doc.overload')
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

local function asDocField(source)
    return source.field[1]
end

function buildName(source, oop)
    if oop == nil then
        oop =  source.type == 'setmethod'
            or source.type == 'getmethod'
    end
    if source.type == 'local' then
        return asLocal(source) or ''
    end
    if source.type == 'getlocal'
    or source.type == 'setlocal' then
        return asLocal(source.node) or ''
    end
    if source.type == 'setglobal'
    or source.type == 'getglobal' then
        return asGlobal(source) or ''
    end
    if source.type == 'setmethod'
    or source.type == 'getmethod' then
        return asField(source, true) or ''
    end
    if source.type == 'setfield'
    or source.type == 'getfield' then
        return asField(source, oop) or ''
    end
    if source.type == 'tablefield' then
        return asTableField(source) or ''
    end
    if source.type == 'doc.type.function' then
        return asDocFunction(source)
    end
    if source.type == 'doc.field' then
        return asDocField(source)
    end
    local parent = source.parent
    if parent then
        return buildName(parent, oop)
    end
    return ''
end

return buildName
