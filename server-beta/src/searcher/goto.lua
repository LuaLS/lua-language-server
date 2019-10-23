local guide    = require 'parser.guide'

local m = {}

function m:eachDef(source, callback)
    local name = source[1]
    local label = guide.getLabel(source, name)
    if label then
        callback {
            source = label,
            uri    = self.uri,
        }
    end
end

return m
