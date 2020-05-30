local vm    = require 'vm.vm'
local guide = require 'parser.guide'

local function getClass(source, classes, deep)
    if deep > 3 then
        return
    end
    local lib = vm.getLibrary(source)
    if lib and lib.type == 'table' then
        classes[#classes+1] = lib.name
        return
    end
    local value = guide.getObjectValue(source) or source
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
    if #classes ~= 0 then
        return
    end
    vm.eachMeta(source, function (mt)
        getClass(mt, classes, deep + 1)
    end)
end

function vm.getClass(source)
    local classes = {}
    getClass(source, classes, 1)
    if #classes == 0 then
        return nil
    end
    return vm.mergeViews(table.unpack(classes))
end
