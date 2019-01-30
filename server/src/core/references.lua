local findResult = require 'core.find_result'

local function parseResult(vm, result, declarat, callback)
    local tp = result.type
    if     tp == 'local' then
        vm:eachInfo(result, function (info)
            if info.source.uri == '' or not info.source.uri then
                return
            end
            if declarat or info.type == 'get' then
                callback(info.source)
            end
        end)
        result.value:eachInfo(function (info)
            if info.source.uri == '' or not info.source.uri then
                return
            end
            if declarat or info.type == 'get' then
                callback(info.source)
            end
        end)
    elseif tp == 'field' then
        vm:eachInfo(result, function (info)
            if info.source.uri == '' or not info.source.uri then
                return
            end
            if declarat or info.type == 'get' then
                callback(info.source)
            end
        end)
        result.value:eachInfo(function (info)
            if info.source.uri == '' or not info.source.uri then
                return
            end
            if declarat or info.type == 'get' then
                callback(info.source)
            end
        end)
    elseif tp == 'label' then
        vm:eachInfo(result, function (info)
            if declarat or info.type == 'goto' then
                callback(info.source)
            end
        end)
    end
end

return function (vm, pos, declarat)
    local result = findResult(vm, pos)
    if not result then
        return nil
    end
    local positions = {}
    local mark = {}
    parseResult(vm, result, declarat, function (source)
        if mark[source] then
            return
        end
        mark[source] = true
        positions[#positions+1] = {
            source.start,
            source.finish,
            source.uri,
        }
    end)
    return positions
end
