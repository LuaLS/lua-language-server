local function parseValueSimily(vm, source, lsp)
    local key = source[1]
    if not key then
        return nil
    end
    local positions = {}
    for _, other in ipairs(vm.sources) do
        if other == source then
            goto CONTINUE
        end
        if      other[1] == key
            and not other:bindLocal()
            and other:bindValue()
            and other:action() == 'set'
            and source:bindValue() ~= other:bindValue()
        then
            positions[#positions+1] = {
                other.start,
                other.finish,
            }
        end
        :: CONTINUE ::
    end
    if #positions == 0 then
        return nil
    end
    return positions
end

local function parseValueCrossFile(vm, source, lsp)
    local value = source:bindValue()
    local positions = {}
    value:eachInfo(function (info, src)
        if info.type == 'local' and src.uri == value.uri then
            positions[#positions+1] = {
                src.start,
                src.finish,
                value.uri,
            }
            return true
        end
    end)
    if #positions > 0 then
        return positions
    end

    value:eachInfo(function (info, src)
        if info.type == 'set' and src.uri == value.uri  then
            positions[#positions+1] = {
                src.start,
                src.finish,
                value.uri,
            }
        end
    end)
    if #positions > 0 then
        return positions
    end

    value:eachInfo(function (info, src)
        if info.type == 'return' and src.uri == value.uri then
            positions[#positions+1] = {
                src.start,
                src.finish,
                value.uri,
            }
        end
    end)
    if #positions > 0 then
        return positions
    end

    local destVM = lsp:getVM(value.uri)
    if not destVM then
        positions[#positions+1] = {
            0, 0, value.uri,
        }
        return positions
    end

    local result = parseValueSimily(destVM, source, lsp)
    if result then
        for _, position in ipairs(result) do
            positions[#positions+1] = position
            position[3] = value.uri
        end
    end
    if #positions > 0 then
        return positions
    end

    return positions
end

local function parseLocal(vm, source, lsp)
    local loc = source:bindLocal()
    local value = source:bindValue()
    if value.uri ~= vm.uri then
        return parseValueCrossFile(vm, source, lsp)
    end
    local positions = {}
    positions[#positions+1] = {
        loc:getSource().start,
        loc:getSource().finish,
    }
    if #positions == 0 then
        return nil
    end
    return positions
end

local function parseValue(vm, source, lsp)
    local value = source:bindValue()
    if value.uri ~= vm.uri then
        return parseValueCrossFile(vm, source, lsp)
    end
    local positions = {}
    value:eachInfo(function (info, src)
        if info.type == 'set' then
            positions[#positions+1] = {
                src.start,
                src.finish,
            }
        end
    end)
    if #positions == 0 then
        return nil
    end
    return positions
end

local function parseLabel(vm, label, lsp)
    local positions = {}
    label:eachInfo(function (info, src)
        if info.type == 'set' then
            positions[#positions+1] = {
                src.start,
                src.finish,
            }
        end
    end)
    if #positions == 0 then
        return nil
    end
    return positions
end

local function jumpUri(vm, source, lsp)
    local uri = source:get 'target uri'
    local positions = {}
    positions[#positions+1] = {
        0, 0, uri,
    }
    return positions
end

return function (vm, source, lsp)
    if not source then
        return nil
    end
    if source:bindLocal() then
        return parseLocal(vm, source, lsp)
    end
    if source:bindValue() then
        return parseValue(vm, source, lsp)
            or parseValueSimily(vm, source, lsp)
    end
    if source:bindLabel() then
        return parseLabel(vm, source:bindLabel(), lsp)
    end
    if source:get 'target uri' then
        return jumpUri(vm, source, lsp)
    end
    if source:get 'in index' then
        source = source:get 'in index'
        return parseValue(vm, source, lsp)
            or parseValueSimily(vm, source, lsp)
    end
end
