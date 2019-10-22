local guide    = require 'parser.guide'

local m = {}

function m:eachDef(source, callback)
    local name = source[1]
    local label = guide.getLabel(source, name)
    if label then
        callback(label)
    end
end

return m
