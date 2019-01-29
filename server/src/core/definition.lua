local function findFieldBySource(positions, source, vm, result)
    if source.type == 'name' and source[1] == result.key then
        local obj = source.bind
        if obj.type == 'field' then
            vm:eachInfo(obj, function (info)
                if info.type == 'set' and info.source == source then
                    positions[#positions+1] = {
                        source.start,
                        source.finish,
                        source.uri,
                    }
                end
            end)
        end
    end
end

local function findFieldByName(positions, vm, result)
    for _, source in ipairs(vm.results.sources) do
        findFieldBySource(positions, source, vm, result)
    end
end


local function parseResultAcrossUri(positions, vm, result)
    -- 跨越文件时，遍历的是值的绑定信息
    result.value:eachInfo(function (info)
        if info.type == 'set' and info.source.uri == result.value.uri then
            positions[1] = {
                info.source.start,
                info.source.finish,
                info.source.uri,
            }
        end
    end)
    if #positions == 0 then
        result.value:eachInfo(function (info)
            if info.type == 'return' and info.source.uri == result.value.uri then
                positions[1] = {
                    info.source.start,
                    info.source.finish,
                    info.source.uri,
                }
            end
        end)
    end
    if #positions == 0 then
        positions[1] = {
            0, 0,
            result.value.uri,
        }
    end
end

local function findFieldCrossUriByName(positions, vm, result, lsp)
    if not lsp then
        return
    end
    local parentValue = result.parentValue
    if not parentValue then
        return
    end
    if parentValue.uri ~= vm.uri then
        local destVM = lsp:loadVM(parentValue.uri)
        if destVM then
            findFieldByName(positions, destVM, result)
        end
    end
end

local function parseResultAsVar(vm, result, lsp)
    local positions = {}
    local tp = result.type
    if     tp == 'local' then
        if result.link then
            result = result.link
        end
        if result.value.lib then
            return positions
        end
        if result.value.uri ~= vm.uri then
            parseResultAcrossUri(positions, vm, result)
        else
            vm:eachInfo(result, function (info)
                if info.type == 'local' then
                    positions[#positions+1] = {
                        info.source.start,
                        info.source.finish,
                        info.source.uri,
                    }
                end
            end)
        end
    elseif tp == 'field' then
        if result.value.lib then
            return positions
        end
        if result.value.uri ~= vm.uri then
            parseResultAcrossUri(positions, vm, result)
        else
            vm:eachInfo(result, function (info)
                if info.type == 'set' then
                    positions[#positions+1] = {
                        info.source.start,
                        info.source.finish,
                        info.source.uri,
                    }
                end
            end)
            if #positions == 0 then
                findFieldByName(positions, vm, result)
                findFieldCrossUriByName(positions, vm, result, lsp)
            end
        end
    elseif tp == 'label' then
        vm:eachInfo(result, function (info)
            if info.type == 'set' then
                positions[#positions+1] = {
                    info.source.start,
                    info.source.finish,
                }
            end
        end)
    end
    return positions
end

local function parseResultAsValue(vm, value, lsp)
    local tp = value:getType()
    local positions = {}
    if tp == 'string' then
        -- require 'XXX' 专用
        positions[#positions+1] = {
            0,
            0,
            value.uri,
        }
    end
    return positions
end

return function (vm, result, lsp)
    if not result then
        return nil
    end
    if result.type == 'value' then
        return parseResultAsValue(vm, result, lsp)
    else
        return parseResultAsVar(vm, result, lsp)
    end
end
