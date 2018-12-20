local findResult = require 'matcher.find_result'

local function parseResult(vm, result)
    local positions = {}
    local tp = result.type
    if     tp == 'local' then
        if result.value.uri ~= vm.uri then
            for _, info in ipairs(result) do
                if info.type == 'set' then
                    positions[#positions+1] = {
                        info.source.start,
                        info.source.finish,
                        info.source.uri,
                    }
                end
            end
        else
          for _, info in ipairs(result) do
              if info.type == 'local' then
                  positions[#positions+1] = {
                    info.source.start,
                    info.source.finish,
                    info.source.uri,
                }
              end
          end
        end
    elseif tp == 'field' then
        for _, info in ipairs(result) do
            if info.type == 'set' then
                positions[#positions+1] = {
                    info.source.start,
                    info.source.finish,
                    info.source.uri,
                }
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
    end
    return positions
end

return function (vm, pos)
    local result = findResult(vm, pos)
    if not result then
        return nil
    end

    local positions = parseResult(vm, result)
    return positions
end
