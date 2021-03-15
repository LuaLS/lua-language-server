---@type vm
local vm    = require 'vm.vm'
local guide = require 'core.guide'

local function lookUpDocClass(source)
    local infers = vm.getInfers(source, 0)
    for _, infer in ipairs(infers) do
        if infer.source.type == 'doc.class'
        or infer.source.type == 'doc.type' then
            return guide.viewInferType(infers)
        end
    end
    return nil
end

local function getClass(source, classes, depth, deep)
    local docClass = lookUpDocClass(source)
    if docClass then
        classes[docClass] = true
        return
    end
    if depth > 3 then
        return
    end
    local value = guide.getObjectValue(source) or source
    if not deep then
        if value and value.type == 'string' then
            classes[value[1]] = true
        end
    else
        for _, src in ipairs(vm.getDefFields(value)) do
            local key = vm.getKeyName(src)
            if not key then
                goto CONTINUE
            end
            local lkey = key:lower()
            if lkey == 'type'
            or lkey == '__name'
            or lkey == 'name'
            or lkey == 'class' then
                local value = guide.getObjectValue(src)
                if value and value.type == 'string' then
                    classes[value[1]] = true
                end
            end
            ::CONTINUE::
        end
    end
    if next(classes) then
        return
    end
    vm.eachMeta(source, function (mt)
        getClass(mt, classes, depth + 1, deep)
    end)
end

function vm.getClass(source, deep)
    local classes = {}
    getClass(source, classes, 1, deep)
    if not next(classes) then
        return nil
    end
    return guide.mergeTypes(classes)
end
