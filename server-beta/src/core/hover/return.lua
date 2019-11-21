local guide = require 'parser.guide'
local vm    = require 'vm'

local function asFunction(source)
    if not source.returns then
        return nil
    end
end

return function (source)
    if source.type == 'function' then
        return asFunction(source)
    end
end
