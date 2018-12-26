local function parseResultAcrossUri(positions, vm, result)
    -- 跨越文件时，遍历的是值的绑定信息
    for _, info in ipairs(result.value) do
        if info.type == 'set' and info.source.uri == result.value.uri then
            positions[1] = {
                info.source.start,
                info.source.finish,
                info.source.uri,
            }
        end
    end
    if #positions == 0 then
        for _, info in ipairs(result.value) do
            if info.type == 'return' and info.source.uri == result.value.uri then
                positions[1] = {
                    info.source.start,
                    info.source.finish,
                    info.source.uri,
                }
            end
        end
    end
    if #positions == 0 then
        positions[1] = {
            0, 0,
            result.value.uri,
        }
    end
end

local function parseResult(vm, result)
    local positions = {}
    local tp = result.type
    if     tp == 'local' then
        if result.value.uri ~= vm.uri then
            parseResultAcrossUri(positions, vm, result)
        else
            for _, info in ipairs(result) do
                if info.type == 'set' then
                    positions[#positions+1] = {
                        info.source.start,
                        info.source.finish,
                        info.source.uri,
                    }
                end
            end
        end
    elseif tp == 'field' then
        if result.value.uri ~= vm.uri then
            parseResultAcrossUri(positions, vm, result)
        else
            for _, info in ipairs(result) do
                if info.type == 'set' then
                    positions[#positions+1] = {
                        info.source.start,
                        info.source.finish,
                        info.source.uri,
                    }
                end
            end
        end
    elseif tp == 'label' then
        for _, info in ipairs(result) do
            if info.type == 'set' then
                positions[#positions+1] = {
                    info.source.start,
                    info.source.finish,
                }
            end
        end
    elseif tp == 'string' then
        -- require 'XXX' 专用
        positions[#positions+1] = {
            0,
            0,
            result.uri,
        }
    end
    return positions
end

return function (vm, result)
    if not result then
        return nil
    end
    local positions = parseResult(vm, result)
    return positions
end
