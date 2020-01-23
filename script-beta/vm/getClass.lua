local vm = require 'vm.vm'

local function getClass(source, classes, deep)
    if deep > 3 then
        return
    end
    vm.eachField(source, function (src)
        local key = vm.getKeyName(src)
        local lkey = key:lower()
        if lkey == 's|type'
        or lkey == 's|__name'
        or lkey == 's|name'
        or lkey == 's|class' then
            if src.value and src.value.type == 'string' then
                classes[#classes+1] = src.value[1]
            end
        end
    end)
    if source.value then
        vm.eachField(source.value, function (src)
            local key = vm.getKeyName(src)
            local lkey = key:lower()
            if lkey == 's|type'
            or lkey == 's|__name'
            or lkey == 's|name'
            or lkey == 's|class' then
                if src.value and src.value.type == 'string' then
                    classes[#classes+1] = src.value[1]
                end
            end
        end)
    end
    if #classes ~= 0 then
        return
    end
    vm.eachMeta(source, function (mt)
        getClass(mt, classes, deep + 1)
    end)
    if source.value then
        vm.eachMeta(source.value, function (mt)
            getClass(mt, classes, deep + 1)
        end)
    end
end

function vm.getClass(source)
    local classes = {}
    getClass(source, classes, 1)
    if #classes == 0 then
        return nil
    end
    return vm.mergeTypeViews(table.unpack(classes))
end
