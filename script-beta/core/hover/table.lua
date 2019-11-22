local vm = require 'vm'

local function checkClass(source)
end

return function (source)
    local fields = {}
    local class
    vm.eachField(source, function (info)
        if info.key == 's|type' or info.key == 's|__name' or info.key == 's|name' then
            if info.value and info.value.type == 'string' then
                class = info.value[1]
            end
        end
        local type = vm.getType(info.source)
        fields[#fields+1] = ('%s'):format(type)
    end)
    local fieldsBuf
    if #fields == 0 then
        fieldsBuf = '{}'
    else
        local lines = {}
        lines[#lines+1] = '{'
        for _, field in ipairs(fields) do
            lines[#lines+1] = '    ' .. field
        end
        lines[#lines+1] = '}'
        fieldsBuf = table.concat(lines, '\n')
    end
    if class then
        return ('%s %s'):format(class, fieldsBuf)
    else
        return fieldsBuf
    end
end
