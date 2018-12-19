local findResult = require 'matcher.find_result'

return function (vm, pos)
    local result = findResult(vm, pos)
    if not result then
        return nil
    end
end
