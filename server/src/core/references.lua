local findResult = require 'core.find_result'

local function parseResult(vm, result, declarat)
    local positions = {}
    local tp = result.type
    if     tp == 'local' then
        vm:eachInfo(result, function (info)
            if info.source.uri == '' or not info.source.uri then
                return
            end
            if declarat or info.type == 'get' then
                positions[#positions+1] = {info.source.start, info.source.finish, info.source.uri}
            end
        end)
    elseif tp == 'field' then
        vm:eachInfo(result, function (info)
            if info.source.uri == '' or not info.source.uri then
                return
            end
            if declarat or info.type == 'get' then
                positions[#positions+1] = {info.source.start, info.source.finish, info.source.uri}
            end
        end)
    elseif tp == 'label' then
        vm:eachInfo(result, function (info)
            if declarat or info.type == 'goto' then
                positions[#positions+1] = {info.source.start, info.source.finish, info.source.uri}
            end
        end)
    end
    return positions
end

return function (vm, pos, declarat)
    local result = findResult(vm, pos)
    if not result then
        return nil
    end
    local positions = parseResult(vm, result, declarat)
    return positions
end
