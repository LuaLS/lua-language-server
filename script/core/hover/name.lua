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
        class = vm.getInfer(source.node):viewClass()
        if class == 'any' or class == 'unknown' then
            class = nil
        end
    end
    local node = class
        or buildName(source.node, false)
        or guide.getKeyName(source.node)
        or '?'
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

local function asDocFunction(source, oop)
    local doc = guide.getParentType(source, 'doc.type')
            or  guide.getParentType(source, 'doc.overload')
    if not doc or not doc.bindSource then
        return ''
    end
    local name = buildName(doc.bindSource, oop)
    if name ~= '' then
        return name
    end
    return ''
end

local function asDocField(source)
    return source.field[1]
end

function buildName(source, oop)
    if source.type == 'local' then
        return asLocal(source) or '', oop
    end
    if source.type == 'getlocal'
    or source.type == 'setlocal' then
        return asLocal(source.node) or '', oop
    end
    if source.type == 'setglobal'
    or source.type == 'getglobal' then
        return asGlobal(source) or '', oop
    end
    if source.type == 'setmethod'
    or source.type == 'getmethod' then
        return asField(source, oop) or '', oop
    end
    if source.type == 'setfield'
    or source.type == 'getfield' then
        return asField(source, oop) or '', oop
    end
    if source.type == 'tablefield' then
        return asTableField(source) or '', oop
    end
    if source.type == 'doc.type.function' then
        return asDocFunction(source, oop), oop
    end
    if source.type == 'doc.field' then
        return asDocField(source), oop
    end
    if source.type == 'method'
    or source.type == 'field'
    or source.type == 'function' then
        return buildName(source.parent, oop)
    end
    return nil, oop
end

return buildName
