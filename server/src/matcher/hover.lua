local findResult = require 'matcher.find_result'
local findLib    = require 'matcher.find_lib'

return function (results, pos)
    local result = findResult(results, pos)
    if not result then
        return nil
    end

    if result.type ~= 'var' then
        return nil
    end
    local var = result.var
    local lib, name = findLib(var)
    if not lib then
        return nil
    end

    if lib.type == 'function' then
        local title = name
        local tip = lib.description or ''
        return ('### %s\n\n* %s'):format(title, tip)
    elseif lib.type == 'table' then
        local tip = lib.description or ''
        return ('%s'):format(tip)
    elseif lib.type == 'string' then
        return lib.description
    end
end
