local findResult = require 'matcher.find_result'

local function parseResult(result)
    local positions = {}
    local tp = result.type
    if     tp == 'local' then
        for _, info in ipairs(result) do
            if info.type == 'local' then
                positions[#positions+1] = {info.source.start, info.source.finish}
            end
        end
    elseif tp == 'field' then
        for _, info in ipairs(result) do
            if info.type == 'set' then
                positions[#positions+1] = {info.source.start, info.source.finish}
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
    local positions = parseResult(result)
    return positions
end
