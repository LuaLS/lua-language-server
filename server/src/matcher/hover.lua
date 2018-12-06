local findResult = require 'matcher.find_result'

return function (results, pos)
    local result = findResult(results, pos)
    if not result then
        return nil
    end

    return nil
end
