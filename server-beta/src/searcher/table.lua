local guide    = require 'parser.guide'

local m = {}

function m:eachField(source, key, callback)
    for i = 1, #source do
        local src = source[i]
        if key == guide.getKeyName(src) then
            if     src.type == 'tablefield' then
                callback {
                    source = src,
                    uri    = self.uri,
                    mode   = 'set',
                }
            elseif src.type == 'tableindex' then
                callback {
                    source = src,
                    uri    = self.uri,
                    mode   = 'set',
                }
            end
        end
    end
end

function m:getValue(source)
    return source
end

return m
