local findResult = require 'matcher.find_result'

local function parseResult(result)
    local positions = {}
    local tp = result.type
    if     tp == 'local' then
        for _, info in ipairs(result.object) do
            if info.type == 'local' then
                positions[#positions+1] = {info.source.start, info.source.finish}
            end
        end
    elseif tp == 'field' then
        local mark = {}
        for _, info in ipairs(result.object) do
            if info.type == 'set' and not mark[info.source] then
                mark[info.source] = true
                positions[#positions+1] = {info.source.start, info.source.finish}
            end
        end
        if result.object.value then
            for _, info in ipairs(result.object.value) do
                if info.type == 'set' and not mark[info.source] then
                    mark[info.source] = true
                    positions[#positions+1] = {info.source.start, info.source.finish}
                end
            end
        end
    elseif tp == 'label' then
        for _, info in ipairs(result.object) do
            if info.type == 'set' then
                positions[#positions+1] = {info.source.start, info.source.finish}
            end
        end
    else
        error('Unknow result type:' .. result.type)
    end
    return positions
end

return function (vm, pos)
    local result = findResult(vm.results, pos)
    if not result then
        return nil
    end
    local positions = parseResult(result)
    return positions
end
