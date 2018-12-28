local findResult = require 'core.find_result'

local function parseResult(result, declarat)
    local positions = {}
    local tp = result.type
    if     tp == 'local' then
        for _, info in ipairs(result) do
            if declarat or info.type == 'get' then
                positions[#positions+1] = {info.source.start, info.source.finish}
            end
        end
    elseif tp == 'field' then
        for _, info in ipairs(result) do
            if declarat or info.type == 'get' then
                positions[#positions+1] = {info.source.start, info.source.finish}
            end
        end
    elseif tp == 'label' then
        for _, info in ipairs(result) do
            if declarat or info.type == 'goto' then
                positions[#positions+1] = {info.source.start, info.source.finish}
            end
        end
    elseif tp == 'string' then
    else
        error('Unknow result type:' .. result.type)
    end
    return positions
end

return function (vm, pos, declarat)
    local result = findResult(vm, pos)
    if not result then
        return nil
    end
    local positions = parseResult(result, declarat)
    return positions
end
