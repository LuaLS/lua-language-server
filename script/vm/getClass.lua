---@type vm
local vm    = require 'vm.vm'
local guide = require 'parser.guide'

local function lookUpDocClass(source)
    local infers = vm.getInfers(source, 0)
    for _, infer in ipairs(infers) do
        if infer.source.type == 'doc.class'
        or infer.source.type == 'doc.type' then
            return infer.type
        end
    end
end

local function getClass(source, classes, depth, deep)
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
