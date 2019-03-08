local function parseValueCrossFile(vm, value, lsp)
    local positions = {}
    value:eachInfo(function (info)
        if info.type == 'local' and info.source.uri == value.uri then
            positions[#positions+1] = {
                info.source.start,
                info.source.finish,
                value.uri,
            }
            return true
        end
    end)
    if #positions > 0 then
        return positions
    end
    value:eachInfo(function (info)
        if info.type == 'set' and info.source.uri == value.uri  then
            positions[#positions+1] = {
                info.source.start,
                info.source.finish,
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
    local main = destVM.main
    local mainValue = main:getFunction()
    local mainSource = mainValue.source
    local returnSource = mainSource[#mainSource]
    if returnSource.type == 'return' then
        positions[#positions+1] = {
            returnSource[1].start,
            returnSource[1].finish,
            value.uri,
        }
    end
    return positions
end

local function parseLocal(vm, loc, lsp)
    local value = loc:getValue()
    if value.uri ~= vm.uri then
        return parseValueCrossFile(vm, value, lsp)
    end
    local positions = {}
    positions[#positions+1] = {
        loc.source.start,
        loc.source.finish,
    }
    if #positions == 0 then
        return nil
    end
    return positions
end

local function parseValue(vm, value, lsp)
    if value.uri ~= vm.uri then
        return parseValueCrossFile(vm, value, lsp)
    end
    local positions = {}
    value:eachInfo(function (info)
        if info.type == 'set' then
            positions[#positions+1] = {
                info.source.start,
                info.source.finish,
            }
        end
    end)
    if #positions == 0 then
        return nil
    end
    return positions
end

local function parseValueSimily(vm, source, lsp)
    local key = source[1]
    if not key then
        return nil
    end
    local positions = {}
    for _, other in ipairs(vm.sources) do
        if other == source then
            break
        end
        if other[1] == key and not other:bindLocal() and other:bindValue() and other:action() == 'set' then
            positions[#positions+1] = {
                other.start,
                other.finish,
            }
        end
    end
    if #positions == 0 then
        return nil
    end
    return positions
end

local function parseLabel(vm, label, lsp)
    local positions = {}
    label:eachInfo(function (info)
        if info.type == 'set' then
            positions[#positions+1] = {
                info.source.start,
                info.source.finish,
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
        return parseLocal(vm, source:bindLocal(), lsp)
    end
    if source:bindValue() then
        return parseValue(vm, source:bindValue(), lsp)
            or parseValueSimily(vm, source, lsp)
    end
    if source:bindLabel() then
        return parseLabel(vm, source:bindLabel(), lsp)
    end
    if source:get 'target uri' then
        return jumpUri(vm, source, lsp)
    end
end
