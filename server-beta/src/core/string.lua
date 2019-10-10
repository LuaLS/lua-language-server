local guide    = require 'parser.guide'

local m = {}

function m:def(source, callback)
    local parent = source.parent
    if not parent then
        return
    end
    if parent.type ~= 'setindex' and parent.type ~= 'getindex' then
        return
    end
    local node = parent.node
    local key = guide.getKeyName(source)
    self:eachField(node, key, function (src, mode)
        if mode == 'set' then
            callback(src, mode)
        end
    end)
end

function m:ref(source, callback)
    local parent = source.parent
    if not parent then
        return
    end
    if parent.type ~= 'setindex' and parent.type ~= 'getindex' then
        return
    end
    local node = parent.node
    local key = guide.getKeyName(source)
    self:eachField(node, key, function (src, mode)
        if mode == 'set' or mode == 'get' then
            callback(src, mode)
        end
    end)
end

function m:value(source, callback)
    callback(source)
end

return m
