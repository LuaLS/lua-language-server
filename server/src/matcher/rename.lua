local findResult = require 'matcher.find_result'
local parser = require 'parser'

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

local function parseResult(result, newName)
    local positions = {}
    local tp = result.type
    if     tp == 'var' then
        local var = result.var
        local key = result.info.source[1]
        if var.disable_rename and key == 'self' then
            return positions
        end
        if result.info.source.index then
            if not parser.grammar(newName, 'Exp') then
                return positions
            end
        else
            if not parser.grammar(newName, 'Name') then
                return positions
            end
        end
        for _, info in ipairs(var) do
            if info.source[1] == key then
                positions[#positions+1] = {info.source.start, info.source.finish}
            end
        end
        local metavar = tryMeta(var)
        if metavar then
            for _, info in ipairs(metavar) do
                if info.source[1] == key then
                    positions[#positions+1] = {info.source.start, info.source.finish}
                end
            end
        end
    elseif tp == 'label' then
        local label = result.label
        for _, info in ipairs(label) do
            positions[#positions+1] = {info.source.start, info.source.finish}
        end
    else
        error('Unknow result type:' .. result.type)
    end
    return positions
end

return function (results, pos, newName)
    local result = findResult(results, pos)
    if not result then
        return nil
    end
    local positions = parseResult(result, newName)
    return positions
end
