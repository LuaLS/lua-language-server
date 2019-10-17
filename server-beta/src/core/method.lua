local guide    = require 'parser.guide'

local m = {}

function m:def(source, callback)
    local node = source.parent.node
    local key = guide.getKeyName(source)
    self:eachField(node, key, function (src, mode)
        if mode == 'set' then
            callback(src, mode)
        end
    end)
end

function m:ref(source, callback)
    local node = source.parent.node
    local key = guide.getKeyName(source)
    self:eachField(node, key, function (src, mode)
        if mode == 'set' or mode == 'get' then
            callback(src, mode)
        end
    end)
end

function m:field(source, key, callback)
    self:eachField(source.parent, key, callback)
end

function m:value(source, callback)
    self:eachValue(source.parent, callback)
end

return m
