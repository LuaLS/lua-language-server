local findResult = require 'matcher.find_result'

local function parseResult(result, declarat)
    local positions = {}
    local tp = result.type
    if     tp == 'local' then
        for _, info in ipairs(result.object) do
            if declarat or info.type == 'get' then
                positions[#positions+1] = {info.source.start, info.source.finish}
            end
        end
    elseif tp == 'field' then
        for _, info in ipairs(result.object) do
            if declarat or info.type == 'get' then
                positions[#positions+1] = {info.source.start, info.source.finish}
            end
        end
    elseif tp == 'label' then
        local label = result.label
        for _, info in ipairs(label) do
            if declarat or info.type == 'goto' then
                positions[#positions+1] = {info.source.start, info.source.finish}
            end
        end
    else
        error('Unknow result type:' .. result.type)
    end
    return positions
end

return function (vm, pos, declarat)
    local result = findResult(vm.results, pos)
    if not result then
        return nil
    end
    local positions = parseResult(result, declarat)
    return positions
end
