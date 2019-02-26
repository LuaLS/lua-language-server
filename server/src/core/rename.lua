local findSource = require 'core.find_source'
local parser = require 'parser'

local function parseResult(result, source, newName)
    local positions = {}
    local tp = result.type
    if tp == 'local' or tp == 'field' then
        local key = source[1]
        if result.hide then
            return positions
        end
        if source.index then
            if not parser.grammar(newName, 'Exp') then
                return positions
            end
        else
            if not parser.grammar(newName, 'Name') then
                return positions
            end
        end
        local mark = {}
        for _, info in ipairs(result) do
            if not mark[info.source] then
                mark[info.source] = info
                if info.source[1] == key then
                    positions[#positions+1] = {info.source.start, info.source.finish}
                end
            end
        end
    elseif tp == 'label' then
        if not parser.grammar(newName, 'Name') then
            return positions
        end
        local label = result.label
        for _, info in ipairs(label) do
            positions[#positions+1] = {info.source.start, info.source.finish}
        end
    end
    return positions
end

return function (vm, pos, newName)
    local result, source = findSource(vm, pos)
    if not result then
        return nil
    end
    local positions = parseResult(result, source, newName)
    return positions
end
