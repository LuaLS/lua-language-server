
local function isContainPos(obj, pos)
    return obj.start <= pos and obj.finish + 1 >= pos
end

local function findResult(results, pos)
    for _, var in ipairs(results.vars) do
        for _, info in ipairs(var) do
            if isContainPos(info.source, pos) then
                return {
                    type = 'var',
                    var = var,
                }
            end
        end
    end
    for _, dots in ipairs(results.dots) do
        for _, info in ipairs(dots) do
            if isContainPos(info.source, pos) then
                return {
                    type = 'dots',
                    dots = dots,
                }
            end
        end
    end
    for _, label in ipairs(results.labels) do
        for _, info in ipairs(label) do
            if isContainPos(info.source, pos) then
                return {
                    type = 'label',
                    label = label,
                }
            end
        end
    end
    return nil
end

local function tryMeta(var)
    local keys = {}
    repeat
        if var.childs.meta then
            local metavar = var.childs.meta
            for i = #keys, 1, -1 do
                local key = keys[i]
                metavar = metavar.childs[key]
                if not metavar then
                    return nil
                end
            end
            return metavar
        end
        keys[#keys+1] = var.key
        var = var.parent
    until not var
    return nil
end

local function parseResult(result, declarat)
    local positions = {}
    local tp = result.type
    if     tp == 'var' then
        local var = result.var
        for _, info in ipairs(var) do
            if declarat or info.type == 'get' then
                positions[#positions+1] = {info.source.start, info.source.finish}
            end
        end
        local metavar = tryMeta(var)
        if metavar then
            for _, info in ipairs(metavar) do
                if declarat or info.type == 'get' then
                    positions[#positions+1] = {info.source.start, info.source.finish}
                end
            end
        end
    elseif tp == 'dots' then
        local dots = result.dots
        for _, info in ipairs(dots) do
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

return function (results, pos, declarat)
    local result = findResult(results, pos)
    if not result then
        return nil
    end
    local positions = parseResult(result, declarat)
    return positions
end
