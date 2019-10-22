local guide    = require 'parser.guide'

local m = {}

function m:eachField(source, key, callback)
    for i = 1, #source do
        local src = source[i]
        if key == guide.getKeyName(src) then
            if     src.type == 'tablefield' then
                callback(src, 'set')
            elseif src.type == 'tableindex' then
                callback(src, 'set')
            end
        end
    end
end

function m:eachValue(source, callback)
    callback(source)
end

return m
