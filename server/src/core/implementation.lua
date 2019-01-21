local function findFieldBySource(positions, source, obj, result)
    if source.type == 'name' and source[1] == result.key then
        if obj.type == 'field' then
            for _, info in ipairs(obj) do
                if info.type == 'set' and info.source == source then
                    positions[#positions+1] = {
                        source.start,
                        source.finish,
                        source.uri,
                    }
                end
            end
        end
    end
end

local function findFieldByName(positions, vm, result)
    for source, obj in pairs(vm.results.sources) do
        if source.type == 'multi-source' then
            for i = 1, #obj do
                findFieldBySource(positions, source, obj[i], result)
            end
        else
            findFieldBySource(positions, source, obj, result)
        end
    end
end

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

local function parseResult(vm, result, lsp)
    local positions = {}
    if result.value.lib then
        return positions
    end
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
            if #positions == 0 then
                findFieldByName(positions, vm, result)
                findFieldCrossUriByName(positions, vm, result, lsp)
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

return function (vm, result, lsp)
    if not result then
        return nil
    end
    local positions = parseResult(vm, result, lsp)
    return positions
end
