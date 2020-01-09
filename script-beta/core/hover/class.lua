local vm = require 'vm'

local function getClass(source, deep)
    if deep > 3 then
        return nil
    end
    local classes = {}
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
    if #classes == 0 then
        return
    end
    return vm.mergeTypeViews(table.unpack(classes))
end

return function (source)
    return getClass(source, 1)
end
