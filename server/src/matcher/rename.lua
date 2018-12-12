local findResult = require 'matcher.find_result'
local parser = require 'parser'

local function parseResult(result, newName)
    local positions = {}
    local tp = result.type
    if tp == 'local' or tp == 'field' then
        local var = result.object
        local key = result.info.source[1]
        if var.disableRename then
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
        local mark = {}
        for _, info in ipairs(var) do
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
    else
        error('Unknow result type:' .. result.type)
    end
    return positions
end

return function (vm, pos, newName)
    local result = findResult(vm.results, pos)
    if not result then
        return nil
    end
    local positions = parseResult(result, newName)
    return positions
end
