local vm    = require 'vm.vm'
local guide = require 'parser.guide'

local function lookUpDocClass(source)
    local infers = vm.getInfers(source)
    for _, infer in ipairs(infers) do
        if infer.source.type == 'doc.class'
        or infer.source.type == 'doc.type' then
            return infer.type
        end
    end
end

local function getClass(source, classes, depth, deep)
    local lib = vm.getLibrary(source, deep)
    if lib then
        if lib.value.type == 'table' then
            classes[#classes+1] = lib.value.name
        else
            classes[#classes+1] = lib.value.type
        end
        return
    end
    local docClass = lookUpDocClass(source)
    if docClass then
        classes[#classes+1] = docClass
        return
    end
    if depth > 3 then
        return
    end
    local value = guide.getObjectValue(source) or source
    if not deep then
        if value and value.type == 'string' then
            classes[#classes+1] = value[1]
        end
    else
        for _, src in ipairs(vm.getFields(value)) do
            local key = vm.getKeyName(src)
            if not key then
                goto CONTINUE
            end
            local lkey = key:lower()
            if lkey == 's|type'
            or lkey == 's|__name'
            or lkey == 's|name'
            or lkey == 's|class' then
                local value = guide.getObjectValue(src)
                if value and value.type == 'string' then
                    classes[#classes+1] = value[1]
                end
            end
            ::CONTINUE::
        end
    end
    if #classes ~= 0 then
        return
    end
    vm.eachMeta(source, function (mt)
        getClass(mt, classes, depth + 1, deep)
    end)
end

function vm.getClass(source, deep)
    local classes = {}
    getClass(source, classes, 1, deep)
    if #classes == 0 then
        return nil
    end
    return guide.mergeTypes(classes)
end
