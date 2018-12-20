local findResult = require 'matcher.find_result'

local function parseResult(vm, result)
    local positions = {}
    local tp = result.type
    if     tp == 'local' then
        if result.value.uri and result.value.uri ~= vm.uri then
            positions[#positions+1] = {
                result.value.source.start,
                result.value.source.finish,
                result.value.uri,
            }
        else
            for _, info in ipairs(result) do
                if info.type == 'local' then
                    positions[#positions+1] = {info.source.start, info.source.finish}
                end
            end
        end
    elseif tp == 'field' then
        if result.value.uri and result.value.uri ~= vm.uri then
            positions[#positions+1] = {
                result.value.source.start,
                result.value.source.finish,
                result.value.uri,
            }
        else
            for _, info in ipairs(result) do
                if info.type == 'set' then
                    positions[#positions+1] = {info.source.start, info.source.finish}
                end
            end
        end
    elseif tp == 'label' then
        for _, info in ipairs(result) do
            if info.type == 'set' then
                positions[#positions+1] = {info.source.start, info.source.finish}
            end
        end
    end
    return positions
end

return function (vm, pos)
    local result = findResult(vm, pos)
    if not result then
        return nil
    end
    local positions = parseResult(vm, result)
    return positions
end
