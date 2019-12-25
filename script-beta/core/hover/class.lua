local vm = require 'vm'

local function getClass(source, deep)
    if deep > 3 then
        return nil
    end
    local class = vm.eachField(source, function (src)
        local key = vm.getKeyName(src)
        local lkey = key:lower()
        if lkey == 's|type'
        or lkey == 's|__name'
        or lkey == 's|name'
        or lkey == 's|class' then
            if src.value and src.value.type == 'string' then
                return src.value[1]
            end
        end
    end)
    if class then
        return class
    end
    return vm.eachMeta(source, function (meta)
        local cl = getClass(meta, deep + 1)
        if cl then
            return cl
        end
    end)
end

return function (source)
    return getClass(source, 1)
end
