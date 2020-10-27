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

local function getClass(source, classes, deep, simple)
    local lib = vm.getLibrary(source, simple)
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
    if deep > 3 then
        return
    end
    local value = guide.getObjectValue(source) or source
    if simple and value == source then
        if value and value.type == 'string' then
            classes[#classes+1] = value[1]
        end
    else
        vm.eachField(value, function (src)
            local key = vm.getKeyName(src)
            if not key then
                return
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
        end)
    end
    if #classes ~= 0 then
        return
    end
    vm.eachMeta(source, function (mt)
        getClass(mt, classes, deep + 1, simple)
    end)
end

function vm.getClass(source, simple)
    local classes = {}
    getClass(source, classes, 1, simple)
    if #classes == 0 then
        return nil
    end
    return guide.mergeTypes(classes)
end
