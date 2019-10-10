local guide    = require 'parser.guide'

local m = {}

function m:field(source, key, callback)
    for i = 1, #source do
        local src = source[i]
        if key == guide.getKeyName(src) then
            if     src.type == 'tablefield' then
                callback(src.field, 'set')
            elseif src.type == 'tableindex' then
                callback(src.index, 'set')
            end
        end
    end
end

function m:value(source, callback)
    callback(source)
end

return m
